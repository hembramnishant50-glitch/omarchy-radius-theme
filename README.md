# 🌌 Omarchy Radius Theme

> A dreamlike, atmospheric desktop experience for **Hyprland**. Wrapped in deep purple-black midnight tones, warm gold/teal accents, and elegant smooth-radius interfaces where minimalism meets cozy utility.

---

## ✨ Features

* 🟣 **Deep Twilight Palette:** A carefully curated dark-ambient color scheme.
* ⭕ **Signature Smooth Corners:** Clean, modern rounded borders across your entire environment.
* ⚡ **Integrated Gaming Mode:** A seamless, non-destructive performance toggle built for maximum frames.

---

## 📸 Preview

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

---

## 🚀 Installation

### 1. Clone the Theme Repository
```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-radius-theme.git /tmp/omarchy-radius
```

### 2. Install Waybar Configuration

This script safely backs up your existing configuration before deploying the Omarchy Radius theme and its custom scripts.

```bash
# Backup existing waybar config if it exists
if [ -d ~/.config/waybar ]; then
  backup_name="waybar-back-$(date +%d-%m-%Y-%H-%M)"
  cp -r ~/.config/waybar ~/.config/"$backup_name"
  echo "✔ Backed up existing waybar to ~/.config/$backup_name"
fi

# Install theme waybar config
cp -r /tmp/omarchy-radius/config/waybar/* ~/.config/waybar/

# Ensure scripts are executable & reload
chmod +x ~/.config/waybar/scripts/*.sh
pkill waybar && waybar &
```

---

## 🎮 Gaming Mode

Maximize your system performance on the fly. Accessible directly via the **Waybar Battery Menu** (Power Profile → Gaming) or straight from your terminal.

### Comparison Matrix

| Setting | 🍃 Normal Mode | 🚀 Gaming Mode |
|---|---|---|
| Compositor Blur | Enabled | Disabled |
| Window Rounding | 14px | 0px (Sharp) |
| Window Opacity | 0.95 | 1.0 (Forced Override) |
| Per-App Transparency | Respected | Forced Opaque |
| Waybar Backgrounds | Alpha Transparency | Solid |
| Walker Border-Radius | 28px / 10px | 0px |
| Heavy Background Apps | Running | Suspended (SIGSTOP) |

### 🛠️ Mechanics Under the Hood

The engine tracks its toggle state via `/tmp/gaming-mode` to ensure zero conflict:

**When Turned ON:** Safely backs up your active Hyprland and CSS configurations, strips resource-heavy blur/rounding effects, appends standard opacity rules (`windowrule = opacity 1.0 override 1.0 override`), removes Waybar alpha channels, and freezes specified background processes using SIGSTOP.

**When Turned OFF:** Restores original configurations instantly from cache, triggers a clean `hyprctl reload` runtime override refresh, and wakes up suspended apps via SIGCONT. No stale states left behind.

---

## 🎨 Palette Breakdown

| Element | Hex Code | Visual Application |
|---|---|---|
| Background | `#160D16` | Deep, immersive purple-black ambient base |
| Foreground | `#FEF9F3` | Warm off-white for crisp, readable text |
| Cyan | `#91E3E1` | Active borders, accents, and status clock |
| Magenta | `#E382D2` | Focused workspace indicator, active selections |
| Blue | `#6A9EF0` | Interactive functions and UI hover highlights |
| Red | `#FF5252` | Error logs, critical alerts, and system warnings |
| Green | `#69DB7C` | System success indicators and text strings |
| Yellow | `#FFD54F` | Syntax strings and code variables |
| Orange | `#FFB347` | Configuration variables and non-critical warnings |
