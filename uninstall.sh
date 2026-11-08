#!/bin/bash
# Remove theme-schedule. Keeps the config file unless --purge is given.
set -uo pipefail

BIN="$HOME/.local/bin/theme-schedule"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/theme-schedule.conf"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/theme-schedule.last"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

systemctl --user disable --now theme-schedule.timer theme-schedule.service 2>/dev/null
rm -f "$UNIT_DIR/theme-schedule.service" "$UNIT_DIR/theme-schedule.timer"
systemctl --user daemon-reload

[[ -x $BIN ]] && "$BIN" menu remove
rm -f "$BIN" "$STATE"

if [[ ${1:-} == --purge ]]; then
  rm -f "$CONFIG"
fi
