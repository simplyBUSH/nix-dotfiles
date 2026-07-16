{ pkgs, accent ? "#FFFF00", ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";
      exec-once = [ "qs -c noctalia-shell" ];

      monitor = ", preferred, auto, 1";
      exec-once = [ "swaybg -o DP-4 -i /home/bush/wallpaper.png -m fill"];
      cursor = {
        no_hardware_cursors = true;
      };

      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 4;
        border_size = 3;
        "col.active_border" = "rgb(${builtins.substring 1 6 accent})";
        "col.inactive_border" = "rgb(444444)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
        };
      };

      animations = {
        enabled = true;
        bezier = "ease, 0.25, 0.1, 0.25, 1.0";
        animation = [
          "windows, 1, 4, ease"
          "windowsOut, 1, 4, ease, popin 80%"
          "fade, 1, 4, ease"
          "workspaces, 1, 3, ease"
        ];
      };


      input = {
        follow_mouse = 1;
        sensitivity = 0;
      };

      # Workspace switching
      bind = [
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"
        "$mod, right, movefocus, r"

        # Swap
        "$mod SHIFT, left, swapwindow, l"
        "$mod SHIFT, right, swapwindow, r"

        # Layout
        "$mod SHIFT, space, togglefloating,"
        "$mod SHIFT, F, fullscreen,"

        # Apps
        "$mod SHIFT, C, exec, code"
        "$mod SHIFT, E, exec, nautilus"
        "$mod SHIFT, Return, exec, alacritty -e tmux"
        "$mod SHIFT, M, exec, element-desktop"
        "$mod SHIFT, R, exec, hyprctl reload"
        "$mod SHIFT, S, exec, XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
        "$mod SHIFT, T, exec, env AUTO_TMUX=1 kitty"
        "$mod SHIFT, V, exec, vesktop"
        "$mod SHIFT, W, exec, firefox"

        # Wofi launcher
        "$mod, space, exec, wofi --show drun"

        # Close window
        "$mod, Q, killactive,"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
