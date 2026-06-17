{ pkgs, ... }:

{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      start-at-login = false;

      after-startup-command = [
        "exec-and-forget borders active_color=0xff4ca0b3 inactive_color=0x00000000 width=7.5"
      ];

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "main";
        "7" = "main";
        "8" = "main";
        "9" = "main";
        "10" = "secondary";
      };

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 5;
        outer.bottom = 5;
        outer.top = 5;
        outer.right = 5;
      };

      mode.main.binding = {
        # workspace switching
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 10";

        # move node to workspace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        # focus
        alt-left = "focus left";
        alt-down = "focus down";
        alt-up = "focus up";
        alt-right = "focus right";

        # swap
        alt-shift-left = "swap left";
        alt-shift-right = "swap right";

        # tiling
        alt-slash = "layout h_tiles v_tiles";
        alt-comma = "layout tiles accordion";
        alt-shift-space = "layout floating tiling";

        # apps
        alt-shift-c = "exec-and-forget code";
        alt-shift-e = "exec-and-forget open -a finder";
        alt-shift-enter = "exec-and-forget env AUTO_TMUX=1 open -n -a alacritty --args -o window.startup_mode=Fullscreen";
        alt-shift-f = "fullscreen";
        alt-shift-m = "exec-and-forget open -a element";
        alt-shift-r = "reload-config";
        alt-shift-s = "exec-and-forget open -a 'System Settings'";
        alt-shift-t = "exec-and-forget env AUTO_TMUX=1 open -a kitty";
        alt-shift-v = "exec-and-forget open -a vesktop";
        alt-shift-w = ''exec-and-forget sh -c "sleep 0.1 && open -a firefox"'';
      };
    };
  };
}
