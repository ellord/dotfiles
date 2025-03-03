#!/usr/bin/env bash

# Dawnfox theme for tmux
# Light theme variant of Nightfox

# Status bar with transparent background
set-option -g status-style bg=default
set -g status-fg colour61

# Window status formatting
set-window-option -g window-status-current-format '#[fg=colour61,bold]#I#[fg=colour25] #W '
set-window-option -g window-status-format '#[fg=colour244]#I#[fg=colour238] #W '
set-window-option -g window-status-current-style bg=default
set-window-option -g window-status-style bg=default

# Pane borders
set -g pane-border-style fg=colour249,bg=default
set -g pane-active-border-style fg=colour61,bg=default

# CLI and messages
set -g message-style fg=colour237,bg=colour252