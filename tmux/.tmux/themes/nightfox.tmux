#!/usr/bin/env bash

# Nightfox theme for tmux
# Based on https://github.com/pawmot/nightfox-tmux

# Status bar
set-option -g status-style bg=default
set -g status-fg colour69

# Window status formatting
set-window-option -g window-status-current-format '#[fg=colour69,bold,bg=default]#I#[fg=colour81,bg=default] #W '
set-window-option -g window-status-format '#[fg=colour242,bg=default]#I#[fg=colour245,bg=default] #W '
set-window-option -g window-status-current-style bg=default
set-window-option -g window-status-style bg=default

# Pane borders
set -g pane-border-style fg=colour238,bg=default
set -g pane-active-border-style fg=colour69,bg=default

# CLI and messages
set -g message-style fg=colour253,bg=colour236
