# Key binding configuration

bindkey '^X^E' edit-command-line
bindkey '^[^[[D' backward-word    # Option + Left Arrow
bindkey '^[^[[C' forward-word     # Option + Right Arrow
bindkey '^[[1;3D' backward-word   # Alt + Left Arrow
bindkey '^[[1;3C' forward-word    # Alt + Right Arrow
bindkey '^[^?' backward-delete-word    # Option + Backspace
bindkey '^[[3;3~' delete-word          # Option + Fn + Backspace
bindkey '^W' backward-kill-word        # Ctrl + W
bindkey '^[d' kill-word                # Option + D
bindkey '^y' autosuggest-accept
bindkey "^R" history-incremental-search-backward
