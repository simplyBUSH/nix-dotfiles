{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.alacritty = {
    enable = true;
    theme = "carbonfox";
    
    settings = {
      window = {
        decorations = "none";
          padding = {
            x = 6; 
            y = 6; 
          };
        };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };
      env = {
        LC_CTYPE = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };

      colors.primary = {
        background = "#000000";
      };
    };
  };
}
