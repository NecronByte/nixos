# NixOS + Hyprland + Catppuccin Mocha for ThinkPad T480

A complete **flake** configuration for a Lenovo **ThinkPad T480** with **Hyprland** and **Catppuccin Mocha** theme. Optimized for laptop usage and programming.

## Contents
- **Display manager**: SDDM (Wayland), no autologin
- **Compositor**: Hyprland (Wayland, XWayland enabled)
- **Panel**: Waybar (Catppuccin)
- **Launcher**: Rofi (Catppuccin)
- **Terminal**: Kitty (Nerd Font, Catppuccin)
- **Editor**: Neovim + Lazy.nvim (Catppuccin), VS Code, JetBrains Rider
- **Lock**: hyprlock (Catppuccin)
- **Wallpaper**: Mocha-inspired (generated), set via hyprpaper
- **Laptop optimization**: TLP, PowerTop, libinput touchpad, plus **kanshi** for automatic screen profiles
- **Lid/power modes**: 
  - On battery: lid close -> **suspend** (save battery).
  - Docked/external power: lid close -> **no suspend** (continue working on external screen).
  - **kanshi** turns off the internal panel when external screen is connected, and activates it again when you disconnect — effectively fulfilling "lid down = laptop screen off when external screen is used; up = laptop screen on again".

> Tip: Run `hyprctl monitors` to see output names (e.g. `eDP-1`, `DP-1`, `HDMI-A-1`) and adjust the `home.nix` kanshi profiles if your names differ.

## Install
1. **Copy** this directory to your machine (e.g. `/etc/nixos` or a git repo in `$HOME`).  
2. **Update** `nixos/hardware-configuration.nix` from your machine:
   ```bash
   sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
   ```
3. **Build & activate**:
   ```bash
   sudo nixos-rebuild switch --flake .#t480
   ```
4. At login, choose **Hyprland** in SDDM. Keybinds (selection):
   - `Super+Enter` Kitty, `Super+D` Rofi
   - `Super+L` lock (hyprlock)
   - Audio: volume/mute keys (pamixer)
   - Brightness: screen keys (brightnessctl)
   - Screenshot: `Super+S` (grim+slurp)

## Customizations
- **Kanshi**: If you only use HDMI or only DP, remove the other one from the `docked` profile in `home.nix`.
- **Theme**: Global **Catppuccin Mocha** is activated via the nix modules (also Waybar/Rofi/Kitty/Neovim).
- **Neovim**: Base setup via lazy.nvim (LSP, Treesitter, Telescope etc.). Extend plugins in `home.nix`.

## Common troubleshooting
- If internal panel doesn't turn off when docking: check that `kanshi` is running. Test `systemctl --user status kanshi`.
- If output names don't match: update `criteria` in `programs.kanshi.profiles` after `hyprctl monitors`.
- If Rider lacks JDK: install `jdk` or use `jetbrains.jdk` package from nixpkgs.

## License
MIT (config files), wallpaper generated for this repo.