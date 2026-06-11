{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "nordfox";

    settings = {
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
