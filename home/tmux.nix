{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = ../configs/tmux/tmux.conf;
}
