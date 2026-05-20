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
      ll = "eza -lha --git";
      q = "exit";
      kys = "tmux kill-server";
      cls = "clear";
      size = "du -sh .";
      sout = "diskutil unmountDisk /dev/disk4 && sudo diskutil eject /dev/disk4";
      ts = "tailscale";
      ns = "nix-shell";
      sdr = "sudo darwin-rebuild switch --flake ~/nix-config/.#glaceon";
      iamb = "iamb -C ~/.config"; 
    };
    
    sessionVariables = {
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      MANPATH = "/opt/homebrew/share/man:''${MANPATH:-}";
      INFOPATH = "/opt/homebrew/share/info:''${INFOPATH:-}";
      CPPFLAGS = "-I/opt/homebrew/opt/openjdk/include";
      PATH = "/opt/homebrew/opt/python@3.12/bin:/opt/homebrew/opt/openjdk/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH";
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
