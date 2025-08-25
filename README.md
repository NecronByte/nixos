# NixOS + Hyprland + Catppuccin Mocha for ThinkPad T480

En komplett **flake**-konfig för en Lenovo **ThinkPad T480** med **Hyprland** och **Catppuccin Mocha**-tema. Optimerad för laptop-användning och programmering.

## Innehåll
- **Display manager**: SDDM (Wayland), ingen autologin
- **Compositor**: Hyprland (Wayland, XWayland aktiverat)
- **Panel**: Waybar (Catppuccin)
- **Launcher**: Rofi (Catppuccin)
- **Terminal**: Kitty (Nerd Font, Catppuccin)
- **Editor**: Neovim + Lazy.nvim (Catppuccin), VS Code, JetBrains Rider
- **Lock**: hyprlock (Catppuccin)
- **Wallpaper**: Mocha-inspirerat (genererat), sätts via hyprpaper
- **Laptop-optimering**: TLP, PowerTop, libinput touchpad, samt **kanshi** för auto-profiler av skärmar
- **Lid/vilka lägen**: 
  - På batteri: locket stänger -> **suspend** (spara batteri).
  - Dockad/extern ström: locket stänger -> **ingen suspend** (fortsätt arbeta på extern skärm).
  - **kanshi** stänger av den interna panelen när extern skärm är ansluten, och aktiverar den igen när du kopplar loss — vilket effektivt uppfyller “locket ned = laptopskärm av när extern skärm används; upp = laptopskärm på igen”.

> Tips: Kör `hyprctl monitors` för att se output-namn (t.ex. `eDP-1`, `DP-1`, `HDMI-A-1`) och justera `home.nix` kanshi-profilerna om dina namn skiljer sig.

## Installera
1. **Kopiera** denna katalog till din maskin (t.ex. `/etc/nixos` eller en git-repo i `$HOME`).  
2. **Uppdatera** `nixos/hardware-configuration.nix` från din maskin:
   ```bash
   sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
   ```
3. **Bygg & aktivera**:
   ```bash
   sudo nixos-rebuild switch --flake .#t480
   ```
4. Vid login, välj **Hyprland** i SDDM. Keybinds (urval):
   - `Super+Enter` Kitty, `Super+D` Rofi
   - `Super+L` lås (hyprlock)
   - Ljud: volym-/mute-tangenter (pamixer)
   - Ljusstyrka: skärmtangenter (brightnessctl)
   - Skärmdump: `Super+S` (grim+slurp)

## Anpassningar
- **Kanshi**: Ifall du använder endast HDMI eller endast DP, ta bort den andra i profilen `docked` i `home.nix`.
- **Tema**: Global **Catppuccin Mocha** aktiveras via nix-modulerna (även Waybar/Rofi/Kitty/Neovim).
- **Neovim**: Bas-setup via lazy.nvim (LSP, Treesitter, Telescope m.m.). Utöka plugins i `home.nix`.

## Vanliga felsökningar
- Om intern panel inte släcks vid dockning: kontrollera att `kanshi` kör. Testa `systemctl --user status kanshi`.
- Om output-namn inte matchar: uppdatera `criteria` i `programs.kanshi.profiles` efter `hyprctl monitors`.
- Om Rider saknar JDK: installera `jdk` eller använd `jetbrains.jdk`-paket från nixpkgs.

## Licens
MIT (konfigfiler), wallpaper genererat för detta repo.