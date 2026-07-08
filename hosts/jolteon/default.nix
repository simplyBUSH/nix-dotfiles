{ pkgs, ... }:

let
  accent = "#FFFF00";
in
{
  imports = [ ./hardware-configuration.nix ];
  home-manager.extraSpecialArgs = { inherit accent; isJolteon = true; };

  environment.systemPackages = with pkgs; [
    efibootmgr
    fastfetch
    ffmpeg
    git
    gping
    hyfetch
    mosh
    ollama
    openvpn
    python313
    refind
    speedtest-cli
    uv
    wofi
    element-desktop
    firefox
    spotify
    vesktop
    nautilus
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";

  networking.hostName = "jolteon";
  networking.networkmanager.enable = true;

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
  

  # OpenGL
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
