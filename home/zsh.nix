{ pkgs, lib, accent, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
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
      gc="sudo nix-collect-garbage -d && sudo nix store optimise";
      gemini="agy";
      iamb = "iamb -C ~/.config"; 
      kys = "tmux kill-server";
      ll = "eza -lha --git"; 
      ns = "nix-shell";
      q = "exit";
      sdr = if isDarwin
        then "sudo darwin-rebuild switch --flake ~/nix-config/.#glaceon"
        else "home-manager switch --flake ~/nix-config#bush@eevee";
      size = "du -sh .";
      ts = "tailscale";
      vi = "nvim";
      vim = "nvim";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    } // lib.optionalAttrs isDarwin {
      CPPFLAGS = "-I/opt/homebrew/opt/openjdk/include";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:''${INFOPATH:-}";
      MANPATH = "/opt/homebrew/share/man:''${MANPATH:-}";
      PATH = "/opt/homebrew/opt/openjdk/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH";
    };

    initContent = lib.mkMerge [
      (lib.mkIf isDarwin (lib.mkOrder 550 ''
        fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
      ''))
      ''
        if [[ -z "$TMUX" && -n "$AUTO_TMUX" ]]; then
            tmux attach-session -t auto 2>/dev/null || tmux new-session -s auto
        fi
      ''
    ];
  };
}
