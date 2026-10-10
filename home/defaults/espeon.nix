{ config, pkgs, ... }:

{
  imports = [
    ../zsh.nix
    ../git.nix
    ../yazi.nix
    ../tmux.nix
    ../nvim.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/home/bush";
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
    ripgrep
    speedtest-cli
    tree
    uv
    wget
  ];


  programs.home-manager.enable = true;
}
