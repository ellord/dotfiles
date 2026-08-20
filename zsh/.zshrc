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

# Tool initialization for interactive use
_evalcache fzf fzf --zsh
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Auto theme switching based on system appearance (macOS only).
# Guard with a pidfile instead of `pgrep`, which scans the whole process table
# (~25ms) on every interactive shell. A bare `kill -0` is NOT enough: PIDs are
# recycled across reboots, so a stale pidfile can point at an unrelated live
# process (e.g. mediaremoteagent) and fool the guard into never relaunching —
# leaving theme switching silently dead. Also confirm the pid is actually
# dark-notify with a cheap single-process `ps -p` (not a full-table scan).
if [[ "$OSTYPE" == darwin* ]] && (( $+commands[dark-notify] )); then
  _dn_pidfile="${XDG_STATE_HOME:-$HOME/.local/state}/dark-notify.pid"
  _dn_pid=""
  [[ -f $_dn_pidfile ]] && _dn_pid=$(<$_dn_pidfile)
  if ! { [[ -n $_dn_pid ]] && kill -0 $_dn_pid 2>/dev/null \
         && [[ $(ps -p $_dn_pid -o comm= 2>/dev/null) == *dark-notify ]]; }; then
    dark-notify -c "$HOME/dotfiles/dark-notify-all.sh" </dev/null >/dev/null 2>&1 &!
    [[ -d ${_dn_pidfile:h} ]] || mkdir -p ${_dn_pidfile:h}
    print -r -- $! >| "$_dn_pidfile"
  fi
  unset _dn_pidfile _dn_pid
fi

# Initialize tools if they exist.
# mise is NOT cached: its `activate` output bakes in a live $PATH snapshot, so it
# must run every shell. zoxide/starship init output is static, so cache it — but
# both must run AFTER mise activate since they may be managed by mise.
command -v mise >/dev/null && eval "$(mise activate zsh)"
_evalcache zoxide zoxide init zsh
_evalcache starship starship init zsh

# Inside cmux, its `claude` shim must win over mise's claude-code install, which
# `mise activate` above puts near the front of PATH. The shim execs
# cmux-claude-wrapper, which injects cmux's agent hooks — without it cmux gets no
# agent status, so the sidebar and anything reading `cmux list-status` stays empty.
# cmux puts the shim dir on PATH but exports no variable naming it, so match it
# there. Outside cmux there is no match and path_promote no-ops on the empty arg.
# Runs on every prompt, not just once: mise's own hooks re-apply their PATH
# snapshot on `cd`, which puts the shim back behind claude-code.
_promote_cmux_claude_shim() {
    [[ $path[1] == */cmux-cli-shims/* ]] && return
    path_promote "${path[(r)*/cmux-cli-shims/*]}"
}
_promote_cmux_claude_shim
autoload -Uz add-zsh-hook
add-zsh-hook precmd _promote_cmux_claude_shim

# Theme and colors. Must run AFTER `mise activate` — on Linux vivid is a
# mise-managed tool, so its shim isn't on $PATH until activation (on macOS vivid
# comes from Homebrew and is available earlier, so this ordering is harmless there).
# Priority: forwarded $THEME_MODE (SSH) > cached file (macOS dark-notify) > inline.
if [[ -n "$THEME_MODE" ]] && command -v vivid >/dev/null; then
    case "$THEME_MODE" in
        dark)  _vivid_theme="catppuccin-mocha" ;;
        light) _vivid_theme="catppuccin-latte" ;;
        *)     _vivid_theme="catppuccin-mocha" ;;
    esac
    export LS_COLORS="$(vivid generate "$_vivid_theme")"
    export EZA_COLORS="$LS_COLORS"
    unset _vivid_theme
elif [[ -f "$HOME/.local/state/shell-theme-colors" ]]; then
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

# zoxide replaces autojump: keep the `j`/`ji` muscle memory.
(( $+functions[__zoxide_z] )) && { alias j=z; alias ji=zi; }
