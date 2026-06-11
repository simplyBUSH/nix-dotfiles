{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    localVariables = {
      PROMPT = "[%n@%F{#bae2de}glaceon%f %~]%% ";
    };

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      cls = "clear";
      gc="sudo nix-collect-garbage -d && sudo nix store optimise";
      iamb = "iamb -C ~/.config"; 
      kys = "tmux kill-server";
      ll = "eza -lha --git";
      ns = "nix-shell";
      q = "exit";
      sdr = "sudo darwin-rebuild switch --flake ~/nix-config/.#glaceon";
      size = "du -sh .";
      ts = "tailscale";
      vi = "nvim";
      vim = "nvim";
    };
    
    sessionVariables = {
      CPPFLAGS = "-I/opt/homebrew/opt/openjdk/include";
      EDITOR = "nvim";
      VISUAL = "nvim";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:''${INFOPATH:-}";
      MANPATH = "/opt/homebrew/share/man:''${MANPATH:-}";
      PATH = "/opt/homebrew/opt/openjdk/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH";
    };


    initContent = lib.mkMerge [
      (lib.mkBefore ''
        autoload -Uz compinit
        if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
          compinit
        else
          compinit -C
        fi

        fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
      '')
      ''

        if [[ -z "$TMUX" && -n "$KITTY_PID" && -n "$KITTY_TMUX" ]]; then
            tmux attach-session -t auto 2>/dev/null || tmux new-session -s auto
        fi


      ''
    ];
  };
}
