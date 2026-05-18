{ pkgs, ... }:

{
  # System packages — minimal, since most stuff goes in home-manager.
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "bush";

  # Hostname.
  networking.hostName = "glaceon";
  networking.localHostName = "glaceon";
  networking.computerName = "glaceon";

  users.users.bush = {
    name = "bush";
    home = "/Users/bush";
  };

  # Fonts — needed for kitty later.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # macOS defaults — equivalent of running `defaults write` commands.
  system.defaults = {
    NSGlobalDomain = {
      # Fast key repeat.
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      # Disable all the autocorrect nonsense.
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      # Show file extensions.
      AppleShowAllExtensions = true;
      # Expand save panel by default.
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;  # don't reorder spaces — important for aerospace
      tilesize = 42;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;  # show hidden files
      FXPreferredViewStyle = "Nlsv";  # list view
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    trackpad = {
      Clicking = true;  # tap to click
      TrackpadThreeFingerDrag = true;
    };
  };

  # Homebrew — for GUI apps not in nixpkgs.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # uninstall casks not declared here
      upgrade = true;
    };
    casks = [
      "firefox"
      "raycast"
      "linearmouse"
      "vesktop"
      "element"
      "visual-studio-code"
    ];
    brews = [
      "openjdk"
      "python@3.12"
      "felixkratz/formulae/borders"
    ];
  };
}
