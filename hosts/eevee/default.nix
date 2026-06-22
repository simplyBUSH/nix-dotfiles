{ pkgs, lib, ... }:
let
  accent = "#b58d60";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.extraSpecialArgs = { inherit accent; };

  networking.hostName = "eevee";
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  nixpkgs.hostPlatform = "aarch64-linux";
  
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  users.users.bush = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs1t4lJy6EL5YzlvnEU57CLWxbP6j5UUc0+MOwuxdbN glaceon"
    ];
  };
  
  users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs1t4lJy6EL5YzlvnEU57CLWxbP6j5UUc0+MOwuxdbN glaceon"
  ];

  services.openssh.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    ffmpeg
    git
    gping
    hyfetch
    mosh
    python313
    speedtest-cli
    uv
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
