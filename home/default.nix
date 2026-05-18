{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./kitty.nix
    ./tmux.nix
    ./aerospace.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/Users/bush";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # CLI tools you want everywhere.
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
