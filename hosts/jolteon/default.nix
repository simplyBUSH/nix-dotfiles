{ pkgs, ... }:

let
  accent = "#FFFF00";
in
{
  imports = [ ./hardware-configuration.nix ];
  home-manager.extraSpecialArgs = { inherit accent; isJolteon = true; };

  environment.systemPackages = with pkgs; [
    efibootmgr
    element-desktop
    fastfetch
    ffmpeg
    firefox
    git
    gping
    hyfetch
    mosh
    nautilus
    ollama-rocm
    openvpn
    python313
    refind
    speedtest-cli
    spotify
    steam
    swaybg
    uv
    vesktop
    wofi
  ];

  nix.settings.experimental-features = "nix-command flakes";
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
};

  users.users.bush = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    home = "/home/bush";
    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  programs ={
    hyprland.enable = true;
    zsh.enable = true;
    dconf.enable = true;
  };

  services = {
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
    openssh.enable = true;
    tailscale.enable = true;
  }; 

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
    vulkan-loader
    mesa.opencl
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [ "usbcore.autosuspend=-1" ];
    initrd.kernelModules = [ "usbhid" "hid_generic" ];
    loader = {
      efi.canTouchEfiVariables = false;
      systemd-boot.enable = true;
    };
  };
}
