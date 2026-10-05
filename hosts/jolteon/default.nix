{ pkgs, ... }:

let
  accent = "#FFFF00";
in
{
  imports = [ ./hardware-configuration.nix ];
  home-manager.extraSpecialArgs = { inherit accent; isJolteon = true; };

  environment.systemPackages = with pkgs; [
    efibootmgr
    openvpn
    refind
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

  networking = {
  hostName = "jolteon";
  networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      "Wired connection 1" = {
        connection = {
          id = "Wired connection 1";
          type = "ethernet";
          interface-name = "enp7s0";
        };
        ethernet = {
          wake-on-lan = "magic";
        };
        ipv4.method = "auto";
        ipv6.addr-gen-mode = "default";
        ipv6.method = "auto";
      };
    };
  };
  interfaces.enp7s0.wakeOnLan.enable = true;
  firewall.trustedInterfaces = [ "tailscale0" ];
};

  users.users.bush = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" "uinput" ];
    home = "/home/bush";
    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Warsaw";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  programs ={
    dconf.enable = true;
    hyprland ={
      enable = true;
      xwayland.enable = true;
    };
    steam.enable = true;
    xwayland.enable = true;
    zsh.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh.enable = true;
    tailscale.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
          };
        };
      };

    keyd = {
      enable = true; 
      keyboards = {
        default = {
          ids = [ "*" ]; 
          settings = {
            main = {
              capslock = "leftmeta";
            };
          };
        };
      };
    };

    avahi = {
      enable = true;
      publish.enable = true;
      publish.userServices = true;
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
      mesa.opencl
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    uinput.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;
    kernelParams = [ "usbcore.autosuspend=-1" ];
    initrd.kernelModules = [ "usbhid" "hid_generic" ];

    loader = {
      efi.canTouchEfiVariables = false;
      systemd-boot.enable = true;
    };
  };
}
