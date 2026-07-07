{ config, pkgs, ... }:

{
  imports = [
    ../zsh.nix
    ../git.nix
    ../yazi.nix
    ../kitty.nix
    ../alacritty.nix
    ../tmux.nix
    ../nvim.nix
    ../hyprland.nix
    ../wofi.nix
    ../iamb.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/home/bush";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ripgrep
    fd
    eza
    fzf
    jq
    btop
    tree
    wget
    curl
  ];

  programs.home-manager.enable = true;
}
