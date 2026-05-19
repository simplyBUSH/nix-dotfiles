{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep              
    fd                   
    git                  
    gcc                  
    gnumake              
    unzip                
    curl                 
    wget                
    nodejs               
    python3              
    fzf
    pyright 
    jdt-language-server
    texlive.combined.scheme-full
    lazygit                
    ];

  xdg.configFile."nvim".source = ../configs/nvim;
}
