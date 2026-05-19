{ config, pkgs, ... }:

{
  home.username = "bush";
  home.homeDirectory = "/Users/bush";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;
}
