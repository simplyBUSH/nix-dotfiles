{ pkgs, ... }:

{
  # Install tmux but don't manage config — we drop in our own.
  home.packages = with pkgs; [
    tmux
  ];

  # Drop in existing config file.
  xdg.configFile."tmux/tmux.conf".source = ../configs/tmux/tmux.conf;
}
