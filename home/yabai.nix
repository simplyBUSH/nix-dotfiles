# home/yabai.nix
{ config, pkgs, lib, ... }:

{
  xdg.configFile."yabai/yabairc" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      yabai -m config layout bsp
      yabai -m config window_placement second_child
      yabai -m config top_padding    12
      yabai -m config bottom_padding 12
      yabai -m config left_padding   12
      yabai -m config right_padding  12
      yabai -m config window_gap     8

      sudo yabai --load-sa
    '';
  };

  launchd.agents.yabai = {
    enable = true;
    config = {
      ProgramArguments = [ "/opt/homebrew/bin/yabai" "--config" "${config.xdg.configHome}/yabai/yabairc" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/yabai.out.log";
      StandardErrorPath = "/tmp/yabai.err.log";
    };
  };
}
