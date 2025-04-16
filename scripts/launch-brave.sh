#!/bin/bash

brave_pid=$(pgrep -x brave)

if [ -n "$brave_pid" ]; then
  hyprctl dispatch focuswindow class:^(Brave-browser)$
else
  brave
fi
