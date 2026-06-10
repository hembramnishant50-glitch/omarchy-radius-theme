# Omarchy Radius Theme

A dark desktop theme for Hyprland with deep purple-black backgrounds, warm gold/teal accents, smooth rounded corners, and an integrated gaming mode toggle.

## Preview

<p align="center">
  <img width="49%" alt="Desktop" src="https://github.com/user-attachments/assets/958ed953-3659-4111-8bf6-766148613335" />
  <img width="49%" alt="Terminal" src="https://github.com/user-attachments/assets/ea63f344-2c17-47f6-987c-2eccb98b2651" />
</p>

<p align="center">
  <img width="49%" alt="Waybar" src="https://github.com/user-attachments/assets/e5d39b61-0317-4117-8d61-a61c8fe64eeb" />
  <img width="49%" alt="Launcher" src="https://github.com/user-attachments/assets/80787969-ea70-4972-8c44-d7b5118ac302" />
</p>

<p align="center">
  <img width="49%" alt="Colors" src="https://github.com/user-attachments/assets/a02b335e-a1a3-4712-a302-aae8c0f4267e" />
</p>

## Installation

### Install the theme

```bash
git clone https://github.com/hembramnishant50-glitch/omarchy-radius-theme.git /tmp/omarchy-radius

```

### Install waybar config

Backs up existing waybar config if present, then installs the themed config and scripts.

```bash
# Backup existing waybar config if it exists
if [ -d ~/.config/waybar ]; then
  backup_name="waybar-back-$(date +%d-%m-%Y-%H-%M)"
  cp -r ~/.config/waybar ~/.config/"$backup_name"
  echo "Backed up existing waybar to ~/.config/$backup_name"
fi

# Install theme waybar config
cp -r /tmp/omarchy-radius/config/waybar/* ~/.config/waybar/

# Ensure scripts are executable
chmod +x ~/.config/waybar/scripts/*.sh
pkill waybar && waybar &
```

## Gaming Mode

A performance toggle accessible via the waybar battery menu (Power Profile → Gaming) or directly from the terminal.

### What it does

| Setting | Normal | Gaming |
|---|---|---|
| Compositor blur | enabled | disabled |
| Window rounding | 14px | 0 |
| Window opacity | 0.95 | 1.0 (forced override) |
| Per-app transparency (alacritty, kitty, etc.) | respected | forced opaque |
| Waybar backgrounds | alpha transparency | solid |
| Walker border-radius | 28px / 10px | 0 |
| Heavy background apps | running | suspended (SIGSTOP) |

### How it works

The script tracks state with `/tmp/gaming-mode`.

**ON:** Backs up Hyprland config and CSS files, disables blur and rounding, appends `windowrule = opacity 1.0 override 1.0 override` (forces all windows to full opacity regardless of per-app settings), strips alpha from waybar CSS, zeros walker rounding, suspends heavy apps via SIGSTOP.

**OFF:** Restores all configs from backups, runs `hyprctl reload` to clear runtime overrides, resumes suspended apps via SIGCONT. No stale state left behind.

## Theme Colors

| Color | Hex | Usage |
|---|---|---|
| Background | `#160D16` | Deep purple-black |
| Foreground | `#FEF9F3` | Warm off-white text |
| Cyan | `#91E3E1` | Borders, clock |
| Magenta | `#E382D2` | Active workspace, selection |
| Blue | `#6A9EF0` | Functions, hover |
| Red | `#FF5252` | Errors, warnings |
| Green | `#69DB7C` | Success, strings |
| Yellow | `#FFD54F` | Strings, variables |
| Orange | `#FFB347` | Variables, warnings |

