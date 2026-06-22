{ pkgs, ... }:
{
  imports = [
    ../git.nix
    ../nvim.nix
    ../tmux.nix
    ../yazi.nix
    ../zsh.nix
    ../iamb.nix
  ];

  home.packages = [
    pkgs.kitty.terminfo
    pkgs.alacritty.terminfo
  ];

  home.stateVersion = "24.11";
}
