{ pkgs, lib, accent, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    localVariables = {
      PROMPT = "[%n@%F{${accent}}%m%f %~] %% ";
    };

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      cls = "clear";
      gc = "nix-collect-garbage -d && nix store optimise";
      kys = "tmux kill-server";
      ll = "eza -lha --git";
      ns = "nix-shell";
      q = "exit";
      sdr = "nix-on-droid switch --flake ~/nix-config#rotom";
      size = "du -sh .";
      vi = "nvim";
      vim = "nvim";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    initExtra = ''
      if [[ -z "$TMUX" && -n "$AUTO_TMUX" ]]; then
          tmux attach-session -t auto 2>/dev/null || tmux new-session -s auto
      fi
    '';
  };
}
