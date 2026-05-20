{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ll = "eza -lha --git";
      q = "exit";
      kys = "tmux kill-server";
      cls = "clear";
      size = "du -sh .";
      sout = "diskutil unmountDisk /dev/disk4 && sudo diskutil eject /dev/disk4";
      ts = "tailscale";
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # ── Completion: cached compinit (regenerates daily) ──
        autoload -Uz compinit
        if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
          compinit
        else
          compinit -C
        fi

        # ── Homebrew (static, no `eval brew shellenv` subshell) ──
        export HOMEBREW_PREFIX="/opt/homebrew"
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
        export HOMEBREW_REPOSITORY="/opt/homebrew"
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
        export MANPATH="/opt/homebrew/share/man:''${MANPATH:-}"
        export INFOPATH="/opt/homebrew/share/info:''${INFOPATH:-}"
        fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
      '')
      ''
        # Prompt: [bush@glaceon ~]%
        PROMPT='[%n@%F{#bae2de}glaceon%f %~]%% '

        # Tmux auto-attach (kitty launched with KITTY_TMUX env var)
        if [[ -z "$TMUX" && -n "$KITTY_PID" && -n "$KITTY_TMUX" ]]; then
            tmux attach-session -t auto 2>/dev/null || tmux new-session -s auto
        fi

        # Java (Homebrew OpenJDK)
        export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
        export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

        # Python 3.12 from Homebrew
        export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"
      ''
    ];
  };
}
