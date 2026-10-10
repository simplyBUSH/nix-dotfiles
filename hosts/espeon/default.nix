{ pkgs, ... }:

let
  accent = "#D582D0";
in
{
  imports = [ ./hardware-configuration.nix ];
  home-manager.extraSpecialArgs = { inherit accent; isJolteon = true; };

  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

  networking = {
  hostName = "espeon";
  networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      "Wired connection 1" = {
        connection = {
          id = "Wired connection 1";
          type = "ethernet";
          interface-name = "enp7s0";
        };
        ipv4.method = "auto";
        ipv6.addr-gen-mode = "default";
        ipv6.method = "auto";
      };
    };
  };
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
  ];

  programs ={
    dconf.enable = true;
    zsh.enable = true;
  };

  services = {
    openssh.enable = true;
    tailscale.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
      mesa.opencl
      ];
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
