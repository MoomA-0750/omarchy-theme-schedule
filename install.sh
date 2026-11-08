#!/bin/bash
# Install theme-schedule for the current user.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

BIN_DIR="$HOME/.local/bin"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/theme-schedule.conf"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

install -Dm755 bin/theme-schedule "$BIN_DIR/theme-schedule"

language=$("$BIN_DIR/theme-schedule" language)
if [[ ! -f $CONFIG ]]; then
  install -Dm644 "config/theme-schedule.conf.$language" "$CONFIG"
fi

install -Dm644 systemd/theme-schedule.service "$UNIT_DIR/theme-schedule.service"
install -Dm644 systemd/theme-schedule.timer "$UNIT_DIR/theme-schedule.timer"
systemctl --user daemon-reload
systemctl --user enable theme-schedule.service
systemctl --user enable --now theme-schedule.timer

"$BIN_DIR/theme-schedule" menu install

echo
"$BIN_DIR/theme-schedule" --status
