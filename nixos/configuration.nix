{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Basic system
  networking.hostName = "t480";
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "sv_SE.UTF-8";
  console.keyMap = "sv-latin1";

  # Users
  users.users.oskar = {
    isNormalUser = true;
    description = "Oskar";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  # Allow unfree (Rider, fonts, etc.) handled at flake import

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Power / Laptop specifics
  services.tlp.enable = true;
  powerManagement.powertop.enable = true;

  # Lid behavior: suspend on battery, ignore when docked or on AC (for external display workflows)
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  # Graphics & Wayland stack
  services.xserver.enable = true; # for SDDM, Xwayland, etc.
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland";
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # For Nvidia laptops (if applicable):
    # nvidiaPatches = true;
  };

  # Input (touchpad, trackpoint) via libinput
  services.xserver.libinput.enable = true;

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Network
  networking.networkmanager.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    noto-fonts noto-fonts-emoji
    jetbrains-mono
    fira-code
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    # Desktop essentials
    kitty waybar rofi hyprpaper hyprlock kanshi mako
    wl-clipboard grim slurp brightnessctl pamixer networkmanagerapplet
    playerctl pavucontrol

    # Dev tools
    git gnupg
    vscode
    jetbrains.rider
    dotnet-sdk_8
    mono

    # Rust toolchain
    rustup

    # Shell / utils
    zsh starship neofetch htop jq ripgrep fd unzip wget curl
  ];

  # SDDM Wayland (auto-detected) – Hyprland session will appear
  services.displayManager.sddm.wayland.enable = true;

  # Polkit (some apps require it under Wayland)
  security.polkit.enable = true;

  # Allow running applications that need the portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Home Manager + Catppuccin global flavor
  catppuccin.flavor = "mocha";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}