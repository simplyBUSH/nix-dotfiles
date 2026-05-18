{ pkgs, ... }:

{
  # Install kitty but use our own config file.
  home.packages = with pkgs; [
    kitty
  ];

  xdg.configFile."kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
}
