{ config, pkgs, ... }:

{
  imports = [
    ../zsh.nix
    ../git.nix
#    ../yazi.nix
#    ../kitty.nix
    ../alacritty.nix
    ../tmux.nix
    ../nvim.nix
#    ../aerospace.nix
    ../iamb.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/Users/bush";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    btop
    curl
    eza
    fastfetch
    fd
    ffmpeg
    fzf
    git
    gping
    hyfetch
    jq
    mosh
    ollama
    ripgrep
    speedtest-cli
    tree
    uv
    wget
  ];

  programs.home-manager.enable = true;
}
