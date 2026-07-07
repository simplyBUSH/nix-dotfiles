{ pkgs, accent ? "#FFFF00", ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 500;
      height = 400;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      insensitive = true;
      prompt = "";
    };

    style = ''
      window {
        margin: 0;
        border: 2px solid ${accent};
        border-radius: 12px;
        background-color: rgba(20, 22, 27, 0.95);
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      #input {
        margin: 8px;
        padding: 8px 12px;
        border: none;
        border-bottom: 2px solid ${accent};
        border-radius: 8px;
        background-color: rgba(40, 42, 50, 0.8);
        color: #e0e0e0;
      }

      #input:focus {
        border-bottom-color: ${accent};
        outline: none;
      }

      #inner-box {
        margin: 4px 8px;
      }

      #outer-box {
        margin: 0;
        padding: 0;
      }

      #entry {
        padding: 6px 12px;
        border-radius: 8px;
        color: #c0c0c0;
      }

      #entry:selected {
        background-color: rgba(255, 255, 0, 0.15);
        color: ${accent};
      }

      #text {
        color: inherit;
      }

      #text:selected {
        color: ${accent};
      }
    '';
  };
}
