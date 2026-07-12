{ pkgs, inputs, accent ? "#FFFF00", ... }:

{

  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
  };
}
