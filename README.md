# omarchy-theme-schedule

Switch your [Omarchy](https://omarchy.org/) theme between its light and dark variant at fixed times or at sunrise and sunset — or keep it manual, chosen from the Omarchy menu.

[日本語](README.ja.md)

## What it does

- **Automatic (by time)**: light at `LIGHT_AT`, dark at `DARK_AT`.
- **Automatic (sunrise and sunset)**: light at sunrise, dark at sunset. Computed offline — no network, no location service. The location is your system time zone's reference city unless you set `LOCATION`.
- **Manual**: nothing happens on its own (the default).
- Pick one from the Omarchy menu (**Appearance → Light/Dark**) or with `theme-schedule time|sun|manual`.
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

It starts in manual mode. Turn on auto with `theme-schedule time` / `theme-schedule sun` or from the menu.

## Uninstall

```sh
./uninstall.sh          # keeps ~/.config/omarchy/theme-schedule.conf
./uninstall.sh --purge  # removes it too
```

## Usage

```sh
theme-schedule time       # automatic by clock time, and apply it now
theme-schedule sun        # automatic by sunrise and sunset, and apply it now
theme-schedule auto       # automatic with the last used schedule
theme-schedule manual     # manual mode (the theme stays as it is)
theme-schedule toggle     # flip between automatic and manual
theme-schedule --status   # mode, themes, today's switch times, location
theme-schedule --now      # apply the theme for the current time right away
theme-schedule menu       # (re)write the menu entries in the current language
```

After changing Omarchy's language, run `theme-schedule menu` once so the menu labels follow.

## Settings

`~/.config/omarchy/theme-schedule.conf`:

```sh
MODE=manual        # auto or manual
SCHEDULE=time      # what auto follows: time or sun
LIGHT_AT=07:00     # time: switch to the light theme at
DARK_AT=18:00      # time: switch to the dark theme at
LOCATION=""        # sun: "latitude,longitude", e.g. "35.68,139.77"; empty = from the time zone
SUNRISE_OFFSET=0   # sun: minutes to shift from sunrise (negative = earlier)
SUNSET_OFFSET=0    # sun: minutes to shift from sunset
PAIRS=(            # pairs the naming rule does not find: "light dark"
  "catppuccin-latte catppuccin"
)
```

The timer checks every minute, so new times take effect without touching systemd.

The sun schedule uses the standard sunrise equation (accurate to a couple of minutes). It falls back to `LIGHT_AT` / `DARK_AT` when the location is unknown and on days the sun does not rise or set (polar night and midnight sun).

## How partner themes are found

1. A pair listed in `PAIRS`.
2. The naming rule: `<name>-light` ↔ `<name>` (or `<name>-dark`).

Which one is light is read from `mode` in each theme's `colors.toml`, so a pair works whichever side you are on. Themes are looked up in `~/.config/omarchy/themes/` and in Omarchy's stock themes.

## License

MIT
