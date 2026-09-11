{ pkgs, lib, accent, isEevee ? false, ... }:
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
      cls = "pyroclear";
      eevee-local = "mosh --server=/home/bush/.nix-profile/bin/mosh-server --bind-server=10.42.0.2 bush@10.42.0.2";
      eevee-gadget = "mosh --server=/home/bush/.nix-profile/bin/mosh-server bush@eevee.local";
      eevee = "mosh --server=/home/bush/.nix-profile/bin/mosh-server eevee";
      clear = "pyroclear";
      gc="sudo nix-collect-garbage -d && sudo nix store optimise";
      iamb = "iamb -C ~/.config"; 
      kys = "tmux kill-server";
      ll = "eza -lha --git"; 
      ns = "nix shell";
      q = "exit";
      sdr = if isDarwin 
        then "sudo darwin-rebuild switch --flake ~/nix-config#$(hostname -s)"
        else if isEevee
        then "home-manager switch --flake ~/nix-config#bush@eevee"
        else "sudo nixos-rebuild switch --flake ~/nix-config#$(hostname)";      
      size = "du -sh .";
      ts = "tailscale";
      vi = "nvim";
      vim = "nvim";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PATH = "$HOME/.cargo/bin${lib.optionalString isEevee ":/usr/local/sbin:/usr/sbin:/sbin"}:$PATH";
    } // lib.optionalAttrs isDarwin {
      CPPFLAGS = "-I/opt/homebrew/opt/openjdk/include";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:''${INFOPATH:-}";
      MANPATH = "/opt/homebrew/share/man:''${MANPATH:-}";
      PATH = "/opt/homebrew/opt/openjdk/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.cargo/bin:$PATH";
    };

    initContent = lib.mkMerge [
          (lib.mkIf isDarwin (lib.mkOrder 550 ''
            fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
            
          ''))
    ];
    #            clear && ${pkgs.hyfetch}/bin/hyfetch
  };
}
