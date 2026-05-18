{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;  # nix replaces the brew zsh-autosuggestions line
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
      iamb = "iamb -C ~/.config/";
      brewseek = "taproom";
      cls = "clear";
      size = "du -sh .";
      sout = "diskutil unmountDisk /dev/disk4 && sudo diskutil eject /dev/disk4";
      # nix-darwin convenience
      rebuild = "darwin-rebuild switch --flake ~/nix-config#glaceon";
    };

    # Runs BEFORE most other zsh setup — brew shellenv has to be early
    # because everything depends on the PATH it sets.
    initExtraFirst = ''
      # Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    # Runs after plugins/completions are set up.
    initContent = ''
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
    '';
  };
}
