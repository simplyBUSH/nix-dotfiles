{ config, pkgs, ... }:

{
  imports = [
    ../zsh.nix
    ../git.nix
    ../discordo.nix
    ../yazi.nix
    ../kitty.nix
    ../alacritty.nix
    ../tmux.nix
    ../nvim.nix
    ../aerospace.nix
    ../iamb.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/Users/bush";
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
