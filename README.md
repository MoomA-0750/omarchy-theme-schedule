# omarchy-theme-schedule

Switch your [Omarchy](https://omarchy.org/) theme between its light and dark variant by time of day — or keep it manual, chosen from the Omarchy menu.

[日本語](README.ja.md)

## What it does

- In **auto** mode the theme switches to its light variant at `LIGHT_AT` and to its dark variant at `DARK_AT`.
- In **manual** mode nothing happens on its own (the default).
- Pick the mode from the Omarchy menu (**Appearance → Light/Dark**) or with `theme-schedule auto|manual`.
- If you change the theme by hand, it stays until the next switch time.
- Themes without a light/dark partner are left alone.
- Messages and menu labels follow your language: Omarchy's language setting first, then the locale. Japanese and English are bundled; other languages fall back to English.

## Requirements

Omarchy (Hyprland, systemd user session). Nothing else.

## Install

```sh
git clone https://github.com/MoomA-0750/omarchy-theme-schedule
cd omarchy-theme-schedule
./install.sh
```

This installs:

| File | Purpose |
|---|---|
| `~/.local/bin/theme-schedule` | the command |
| `~/.config/omarchy/theme-schedule.conf` | settings (kept if it already exists) |
| `~/.config/systemd/user/theme-schedule.{service,timer}` | runs the command at login and every minute |
| a marked block in `~/.config/omarchy/extensions/omarchy-menu.jsonc` | the Light/Dark menu entries |

It starts in manual mode. Turn on auto with `theme-schedule auto` or from the menu.

## Uninstall

```sh
./uninstall.sh          # keeps ~/.config/omarchy/theme-schedule.conf
./uninstall.sh --purge  # removes it too
```

## Usage

```sh
theme-schedule auto       # auto mode, and switch to the theme for the current time now
theme-schedule manual     # manual mode (the theme stays as it is)
theme-schedule toggle     # flip between auto and manual
theme-schedule --status   # mode, current theme, partner theme, current period
theme-schedule --now      # apply the theme for the current time right away
theme-schedule menu       # (re)write the menu entries in the current language
```

After changing Omarchy's language, run `theme-schedule menu` once so the menu labels follow.

## Settings

`~/.config/omarchy/theme-schedule.conf`:

```sh
MODE=manual        # auto or manual
LIGHT_AT=07:00     # switch to the light theme at
DARK_AT=18:00      # switch to the dark theme at
PAIRS=(            # pairs the naming rule does not find: "light dark"
  "catppuccin-latte catppuccin"
)
```

The timer checks every minute, so new times take effect without touching systemd.

## How partner themes are found

1. A pair listed in `PAIRS`.
2. The naming rule: `<name>-light` ↔ `<name>` (or `<name>-dark`).

Which one is light is read from `mode` in each theme's `colors.toml`, so a pair works whichever side you are on. Themes are looked up in `~/.config/omarchy/themes/` and in Omarchy's stock themes.

## License

MIT
