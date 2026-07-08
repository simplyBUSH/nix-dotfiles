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

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  programs.home-manager.enable = true;
}
