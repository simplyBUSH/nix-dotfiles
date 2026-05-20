{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      foreground              = "#cdd6f4";
      background              = "#1e1e2e";
      selection_foreground    = "#1e1e2e";
      selection_background    = "#f5e0dc";

      cursor                  = "#f5e0dc";
      cursor_text_color       = "#1e1e2e";

      scrollbar_handle_color  = "#9399b2";
      scrollbar_track_color   = "#45475a";

      url_color               = "#f5e0dc";

      active_border_color     = "#b4befe";
      inactive_border_color   = "#6c7086";
      bell_border_color       = "#f9e2af";

      active_tab_foreground   = "#11111b";
      active_tab_background   = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#181825";
      tab_bar_background      = "#11111b";

      hide_window_decorations = "titlebar-only";
      macos_titlebar_color    = "#14161B";
      window_padding_width    = "20 10 10 10";
      macos_thicken_font      = "1";

      confirm_os_window_close = "0";
      shell_integration       = "no-sudo";
    };

    extraConfig = ''
      clear_all_mouse_actions yes
      mouse_map left click ungrabbed mouse_handle_click selection link prompt
      mouse_map left press ungrabbed mouse_selection normal
      mouse_map left doublepress ungrabbed mouse_selection word
      mouse_map left triplepress ungrabbed mouse_selection line
    '';
  };
}
