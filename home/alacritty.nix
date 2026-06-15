{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    theme = "carbonfox";
    
    settings = {
      window.padding = {
        x = 8;
        y = 8;
      };

      colors.primary = {
        background = "#000000";
      };
    };
  };
}
