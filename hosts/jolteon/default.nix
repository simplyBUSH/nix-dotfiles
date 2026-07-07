{ pkgs, ... }:

let
  accent = "#FFFF00";
in
{
  home-manager.extraSpecialArgs = { inherit accent; };

  environment.systemPackages = with pkgs; [
    efibootmgr
    fastfetch
    ffmpeg
    git
    gping
    hyfetch
    mosh
    ollama
    openvpn
    python313
    refind
    speedtest-cli
    uv
    wofi
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";

  networking.hostName = "jolteon";

  users.users.bush = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    home = "/home/bush";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Networking
  networking.networkmanager.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Tailscale
  services.tailscale.enable = true;

  # OpenGL
  hardware.graphics.enable = true;

  # Bootloader
  # rEFInd is installed manually as the EFI entry point for OS selection
  # (Windows / NixOS). It chainloads systemd-boot, which manages NixOS
  # generations. Run `sudo refind-install` once after first install.
  # canTouchEfiVariables = false so systemd-boot doesn't override rEFInd
  # as the default EFI boot entry.
  boot.loader = {
    efi.canTouchEfiVariables = false;
    systemd-boot.enable = true;
  };
}
