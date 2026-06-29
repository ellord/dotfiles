# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi
# Interactive shell configuration

# Completion fpath + widget setup. This must precede the modular configs below,
# since keybindings.zsh binds ^X^E to the edit-command-line widget.
fpath_append() {
    if [ -d "$1" ] && [[ ":$FPATH:" != *":$1:"* ]]; then
        export FPATH="$1:$FPATH"
    fi
}

fpath_append "$ZSH_CONFIG_DIR/.zsh/completions"
fpath_append "$HOME/.docker/completions"
fpath_append "$HOME/.local/share/zsh/site-functions"
autoload -U edit-command-line
zle -N edit-command-line

# Load modular configuration files (aliases.zsh, keybindings.zsh, path.zsh).
# These used to be re-sourced explicitly below; sourcing once here (after the
# widget setup above) removes that redundant double-source.
for config_file ($ZSH_CONFIG_DIR/.zsh/*.zsh(N)); do
    source $config_file
done

# Initialize the completion system here, once, with a cached dump. `-C` skips the
# expensive security audit on every shell; a full audit runs at most once a day.
# Running it before the env-specific configs means any of them that source a
# completion include find compdef already defined and skip a second, slower
# compinit. It also ensures completions initialise even when no env config does.
autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d ${_zcompdump:h} ]] || mkdir -p ${_zcompdump:h}
if [[ -e $_zcompdump && -n $_zcompdump(#qN.mh-24) ]]; then
    compinit -C -d "$_zcompdump"   # dump < 24h old: trust it, skip the audit
else
    compinit -d "$_zcompdump"      # missing/stale: full init (rebuild + audit)
fi
unset _zcompdump

# Load environment-specific config files
for config_file ($HOME/dotfiles/env/$DOTFILES_ENV/zsh/dot-zsh/*.zsh(N)); do
    source $config_file
done

# Theme and colors — prefer cached file written by dark-notify-all.sh,
# fall back to generating inline on first run or non-macOS.
if [[ -f "$HOME/.local/state/shell-theme-colors" ]]; then
    source "$HOME/.local/state/shell-theme-colors"
elif command -v vivid >/dev/null; then
    _vivid_theme="catppuccin-mocha"
    if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != "Dark" ]]; then
        _vivid_theme="catppuccin-latte"
    fi
    export LS_COLORS="$(vivid generate "$_vivid_theme")"
    export EZA_COLORS="$LS_COLORS"
    unset _vivid_theme
fi

# Tool initialization for interactive use
_evalcache fzf fzf --zsh
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Auto theme switching based on system appearance (macOS only).
# Guard with a pidfile + `kill -0` (zsh builtin) instead of `pgrep`, which scans
# the whole process table (~25ms) on every interactive shell.
if [[ "$OSTYPE" == darwin* ]] && (( $+commands[dark-notify] )); then
  _dn_pidfile="${XDG_STATE_HOME:-$HOME/.local/state}/dark-notify.pid"
  if ! { [[ -f $_dn_pidfile ]] && kill -0 "$(<$_dn_pidfile)" 2>/dev/null; }; then
    dark-notify -c "$HOME/dotfiles/dark-notify-all.sh" </dev/null >/dev/null 2>&1 &!
    [[ -d ${_dn_pidfile:h} ]] || mkdir -p ${_dn_pidfile:h}
    print -r -- $! >| "$_dn_pidfile"
  fi
  unset _dn_pidfile
fi

# Initialize tools if they exist.
# zoxide/starship init output is static, so cache it. mise is NOT cached: its
# `activate` output bakes in a live $PATH snapshot, so it must run every shell.
_evalcache zoxide zoxide init zsh
command -v mise >/dev/null && eval "$(mise activate zsh)"
_evalcache starship starship init zsh

# zoxide replaces autojump: keep the `j`/`ji` muscle memory.
(( $+functions[__zoxide_z] )) && { alias j=z; alias ji=zi; }
