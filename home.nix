{ config, pkgs, ... }:
let
  hyprConfDir = ".config/hypr";
  waybarDir = ".config/waybar";
  rofiDir = ".config/rofi";
  kittyDir = ".config/kitty";
  kanshiDir = ".config/kanshi";
  hyprlockDir = ".config/hyprlock";
in
{
  home.username = "oskar";
  home.homeDirectory = "/home/oskar";

  programs.home-manager.enable = true;

  # Shell
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh.enable = false;
  };
  programs.starship.enable = true;

  # Catppuccin theming (Mocha applied globally)
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "mocha";
    tty.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
    rofi.enable = true;
    kitty.enable = true;
    neovim.enable = true;
    # starship too if desired:
    starship.enable = true;
  };

  # Neovim + LazyVim + Catppuccin
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [ gcc gnumake nodejs python3 ripgrep fd lua-language-server ];
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      catppuccin-nvim
      # Add a minimal LazyVim-like starter; users can extend as needed.
    ];
    extraConfig = ''
      lua << EOF
        -- Lazy.nvim bootstrap
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({ "git", "clone", "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
        end
        vim.opt.rtp:prepend(lazypath)

        require("lazy").setup({
          -- Core plugins you can extend later
          { "catppuccin/nvim", name = "catppuccin" },
          { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
          { "neovim/nvim-lspconfig" },
          { "hrsh7th/nvim-cmp" },
          { "hrsh7th/cmp-nvim-lsp" },
          { "L3MON4D3/LuaSnip" },
          { "nvim-lualine/lualine.nvim" },
          { "nvim-tree/nvim-web-devicons" },
          { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        })

        -- Theme
        require("catppuccin").setup({
          flavour = "mocha",
          integrations = { cmp = true, gitsigns = true, treesitter = true, telescope = true, lsp_trouble = true, which_key = true }
        })
        vim.cmd.colorscheme("catppuccin-mocha")
      EOF
    '';
  };

  # Kitty config
  xdg.configFile."${kittyDir}/kitty.conf".text = ''
    font_family      JetBrainsMono Nerd Font
    font_size        12.0
    disable_ligatures never
    enable_audio_bell no
    cursor_shape     beam
    hide_window_decorations yes
    confirm_os_window_close 0
  '';

  # Hyprland config
  xdg.configFile."${hyprConfDir}/hyprland.conf".text = ''
    # Import Catppuccin Mocha palette (provided by catppuccin module)
    source = ~/.config/hypr/mocha.conf

    monitor = ,preferred,auto,1

    # Input
    input {
      kb_layout = se
      touchpad {
        natural_scroll = true
        tap = true
        drag_lock = true
      }
    }

    general {
      gaps_in = 6
      gaps_out = 12
      border_size = 2
      col.active_border = rgb($lavender)
      col.inactive_border = rgb($surface1)
    }

    decoration {
      rounding = 8
      blur = yes
      blur_size = 6
      blur_passes = 2
    }

    animations {
      enabled = yes
    }

    dwindle {
      preserve_split = true
      pseudotile = true
    }

    misc {
      disable_hyprland_logo = true
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
    }

    # Execs
    exec-once = nm-applet
    exec-once = waybar
    exec-once = hyprpaper
    exec-once = kanshi

    $mod = SUPER

    # Launchers / apps
    bind = $mod, Return, exec, kitty
    bind = $mod, D, exec, rofi -show drun

    # Lock screen
    bind = $mod, L, exec, hyprctl dispatch lock

    # Volume
    bindle = , XF86AudioRaiseVolume, exec, pamixer -i 5
    bindle = , XF86AudioLowerVolume, exec, pamixer -d 5
    bindle = , XF86AudioMute, exec, pamixer -t

    # Brightness
    bindle = , XF86MonBrightnessUp, exec, brightnessctl set +10%
    bindle = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

    # Screenshots
    bind = $mod, S, exec, grim -g "$(slurp)" - | wl-copy

    # Window management
    bind = $mod, Q, killactive,
    bind = $mod, F, fullscreen, 0
    bind = $mod, Space, togglefloating,
    bind = $mod, H, movefocus, l
    bind = $mod, J, movefocus, d
    bind = $mod, K, movefocus, u
    bind = $mod, L, movefocus, r

    # Workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10
  '';

  # Hyprpaper
  xdg.configFile."${hyprConfDir}/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/wallpaper.png
    wallpaper = ,~/.config/hypr/wallpaper.png
  '';

  # Provide wallpaper file
  xdg.configFile."${hyprConfDir}/wallpaper.png".source = ./assets/wallpaper-mocha-3840x2160.png;

  # Hyprlock
  xdg.configFile."${hyprlockDir}/hyprlock.conf".text = ''
    general {
      grace = 0
      hide_cursor = true
      no_fade_in = false
      disable_loading_bar = true
    }

    background {
      # use current wallpaper blurred by default
      blur_passes = 2
      blur_size = 6
    }

    label {
      text = cmd[update:1000] echo "$(date +'%H:%M')"
      font_size = 90
      color = rgb($lavender)
      position = 0.5,0.35
      halign = center
      valign = center
    }

    input-field {
      size = 300, 60
      outline_thickness = 2
      dots_center = true
      fade_on_empty = false
      inner_color = rgb($surface0)
      outer_color = rgb($lavender)
      font_color = rgb($text)
      rounding = 12
      placeholder_text = <enter to unlock>
      position = 0.5,0.55
      halign = center
      valign = center
    }
  '';

  # Waybar
  xdg.configFile."${waybarDir}/config".text = builtins.toJSON {
    "layer": "top",
    "position": "top",
    "height": 28,
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "battery", "network", "tray"],
    "clock": { "format": "{:%Y-%m-%d  %H:%M}" },
    "battery": { "format": "{capacity}% {icon}", "format-icons": ["󰂎","󰁺","󰁼","󰁾","󰂀","󰁹"] },
    "pulseaudio": { "format": "{volume}% 󰕾", "format-muted": "muted 󰖁" },
    "network": { "format-wifi": "{essid} 󰤨", "format-ethernet": "eth 󰈁", "format-disconnected": "󰤭" },
    "tray": { "icon-size": 18, "spacing": 8 }
  };

  # Rofi (Catppuccin module handles theme); basic config if needed
  xdg.configFile."${rofiDir}/config.rasi".text = ''
    @theme "Catppuccin-Mocha"
  '';

  # Kanshi profiles for laptop/external monitor
  # When an external monitor is connected, disable the internal panel (eDP-1).
  # When on the go (no external), enable eDP-1.
  programs.kanshi = {
    enable = true;
    profiles = [
      {
        name = "mobile";
        outputs = [
          { criteria = "eDP-1"; status = "enable"; mode = "1920x1080@60Hz"; scale = 1.0; position = "0,0"; }
        ];
      }
      {
        name = "docked";
        outputs = [
          { criteria = "eDP-1"; status = "disable"; }
          # You can adjust criteria names (e.g., "DP-1", "HDMI-A-1") after checking `hyprctl monitors`
          { criteria = "DP-1"; status = "enable"; mode = "preferred"; position = "0,0"; }
          { criteria = "HDMI-A-1"; status = "enable"; mode = "preferred"; position = "0,0"; }
        ];
      }
    ];
  };

  # Ensure kanshi starts (also exec-once in Hyprland)
  systemd.user.services.kanshi = {
    Unit = { Description = "Kanshi output auto-profile"; };
    Service = {
      ExecStart = "${pkgs.kanshi}/bin/kanshi -c ${config.xdg.configHome}/kanshi/config";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  # Apply on login
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  home.stateVersion = "24.05";
}