{ pkgs, ... }:

let
  accent = "#bae2de";
in
{
  home-manager.extraSpecialArgs = { inherit accent; };
  environment.systemPackages = with pkgs; [
    fastfetch
    ffmpeg
    git
    gping
    hyfetch
    mosh
    ollama
    python313
    speedtest-cli
    stats
    uv
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "bush";

  networking.hostName = "glaceon";
  networking.localHostName = "glaceon";
  networking.computerName = "glaceon";
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true; 
  };


  users.users.bush = {
    name = "bush";
    home = "/Users/bush";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      AppleShowAllExtensions = true;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
      tilesize = 42;
      autohide-delay = 10.0;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
      extraFlags = [ "--force" ];
    };
    taps = [
    "TheBoredTeam/boring-notch"
    ];

    casks = [
      "affinity"
      "boring-notch"
      "element"
      "firefox"
      "linearmouse"
      "mx-power-gadget"
      "pearcleaner"
      "raycast"
      "skim"
      "spotify"
      "steam"
      "tailscale-app"
      "vesktop"
      "visual-studio-code"
      "antigravity-cli"
      "antigravity"
     ];
    brews = [
      "felixkratz/formulae/borders"
      "matthart1983/tap/netwatch"
      "openjdk"
    ];
  };
}
