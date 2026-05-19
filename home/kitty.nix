{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

  xdg.configFile."kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
}
