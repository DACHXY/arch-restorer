#!/usr/bin/env bash

if pgrep -x "polybar" > /dev/null; then
    polybar-msg cmd quit
fi

echo "---" | tee -a /tmp/polybar_main.log
polybar main 2>&1  | tee -a /tmp/polybar_main.log & disown

echo "[Polybar] Bars launched..."