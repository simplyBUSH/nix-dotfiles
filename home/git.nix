{ pkgs, ... }:

{
  programs.git = {
    
    enable = true;
    
    settings = {
      user = {
        name = "Piotr Malowiecki";       
        email = "01197368@pw.edu.pl";     
      };

    alias = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
    };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";

    };
  };
}
