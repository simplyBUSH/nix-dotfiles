{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Piotr Malowiecki";
    userEmail = "01197368@pw.edu.pl";

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };
}
