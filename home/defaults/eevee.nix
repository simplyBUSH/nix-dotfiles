{ pkgs, accent, isEevee, ... }:

{
  imports = [
    ../zsh.nix
    ../git.nix
    ../yazi.nix
    ../kitty.nix
    ../alacritty.nix
    ../tmux.nix
    ../nvim.nix
    ../iamb.nix
  ];

  home = {
    username = "bush";
    homeDirectory = "/home/bush";
    stateVersion = "25.05"; 

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
    };

  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
    curl
    eza
    fastfetch
    fd
    ffmpeg
    fzf
    git
    gping
    hyfetch
    jq
    mosh
    nix
    ollama
    ripgrep
    speedtest-cli
    tree
    uv
    wget
  ];
}
