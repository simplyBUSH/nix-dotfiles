{ config, pkgs, ... }:

{
  home.username = "bush";
  home.homeDirectory = "/Users/bush";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # We'll add stuff here later.
  ];

  programs.home-manager.enable = true;
}
