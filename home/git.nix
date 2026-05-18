{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Piotr Malowiecki";       # change to whatever you used
    userEmail = "01197368@pw.edu.pl";  # change

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
    };
  };
}
