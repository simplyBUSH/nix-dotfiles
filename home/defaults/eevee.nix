{ pkgs, ... }:
{
  imports = [
    ../git.nix
    ../nvim.nix
    ../tmux.nix
    ../yazi.nix
    ../zsh.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/home/bush";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    kitty.terminfo
    alacritty.terminfo
    ripgrep
    fd
    eza
    fzf
    jq
    btop
    tree
    wget
    curl
    fastfetch
  ];

  programs.home-manager.enable = true;
}
