# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages configuration files for various development tools using GNU Stow. The repository contains configurations for vim, neovim, tmux, zsh, wezterm, and ghostty.

## Key Commands

### Installation
```bash
./install    # Set up all symlinks, stow packages, tmux plugins, and git config
./uninstall  # Remove all symlinks created by install
```

### Stow Management
```bash
stow vim       # Link vim configuration
stow zsh       # Link zsh configuration (uses --dotfiles flag)
stow tmux      # Link tmux configuration
stow mise      # Link mise configuration
stow wezterm   # Link wezterm configuration
```

### Homebrew Dependencies
```bash
brew bundle    # Install all dependencies from Brewfile
```

### Mise Updates
```bash
./update-mise-tools                     # Update pinned Claude Code and latest CLI tools
./update-mise-tools --dry-run           # Preview the planned updates
./update-mise-tools --include-runtimes  # Also upgrade language runtimes within their ranges
```

### Mise Maintenance
- When bumping a tool version in mise config, old versions remain installed on disk
- `mise prune` does not reliably catch orphaned versions (known limitation with some backends)
- Use `mise ls` to find versions without a Source — those are orphans safe to remove
- `./update-mise-tools` reads the CLI sections from `mise/.config/mise/config.toml`, keeps `claude-code` pinned, and upgrades the non-pinned tools one at a time so a single backend failure does not stop the rest
- Uninstall using the short tool name from `mise ls`, not the full backend name:
  ```bash
  # Correct:
  mise uninstall claude-code@2.1.81
  # Wrong (will say "not installed"):
  mise uninstall npm:@anthropic-ai/claude-code@2.1.81
  ```

## Architecture & Structure

### Configuration Management
- Uses GNU Stow for symlink management (vim, zsh, tmux, mise, wezterm)
- Manual symlinks for tools that don't fit stow's directory model (nvim, ghostty, Claude Code)
- The `install` script handles all setup including git cloning of tmux plugins
- Dark mode switching across all tools via a single `dark-notify-all.sh` dispatcher

### Key Directories
- `nvim-config/`: Neovim configuration based on kickstart.nvim
  - `lua/custom/plugins/`: Custom plugin configurations
  - Uses lazy.nvim for plugin management
- `zsh/`: Shell configuration with modular setup
  - `dot-zsh/`: Contains aliases, completions, keybindings, and path configurations
- `tmux/`: Tmux configuration with plugin support (TPM)
- `wezterm/`: Terminal emulator configuration (stow package with `.config/` structure)
- `ghostty/`: Ghostty terminal configuration
- `mise/`: Version manager configuration (stow package with `.config/` structure)
  - Environment-specific configs: `mise.personal.toml`, `mise.work.toml`
- `env/`: Environment-specific overrides (work/personal)

### Notable Tools Configured
- Package managers: Homebrew, mise (manages node, python, go, rust, etc.)
- Development tools: neovim, git (with delta), gh, lazygit
- Search/navigation: fzf, ripgrep, zoxide
- Container tools: k9s, kubectx
- Language support: go, deno, luajit/luarocks

### Git Configuration
- Shared config at `git/.gitconfig` (included via `[include]` from `~/.gitconfig`)
- Personal details (name, email) go in `~/.gitconfig.local` (not tracked)
- Machine-specific overrides (conditional includes for work repos) also in `~/.gitconfig.local`

### Shell Scripts
- Shell scripts follow the bash-script conventions: `set -euo pipefail`, coloured output, idempotent step functions
- Validate with `shellcheck` and `shfmt -i 4` before committing

## Zsh Startup Performance

The startup path (`.zshenv` → `.zprofile` → `.zshrc`) is tuned for fast
time-to-first-prompt (~170 ms median on Apple Silicon, down from ~490 ms; target
< 200 ms). Re-measure with `scripts/zsh-startup/measure-ttfp.sh` before and after any
change to the startup files — it wraps the real rc files in a throwaway `ZDOTDIR` and
reports a per-phase breakdown. `trace-startup.sh` and `bench-components.sh` in the same
dir help diagnose *what* is slow. Numbers vary with system load — take medians.

### Design decisions — do NOT naively revert
- **`pyenv init --path` is intentionally absent** from `.zprofile` (~190 ms). Python is
  provided by mise, whose shims are prepended later and shadow pyenv's regardless, so
  the init was dead weight. The `pyenv` command itself stays on PATH. Only re-add a
  per-shell pyenv init if mise genuinely stops covering Python.
- **`_evalcache` (defined in `.zshenv`) caches static `eval "$(tool init)"` output**
  (brew/fzf/zoxide/starship) under `$XDG_CACHE_HOME/zsh/evalcache/`, regenerating when
  the tool binary is newer than the cache. Do NOT wrap its `source` in
  `emulate -L zsh` / `LOCAL_OPTIONS` — cached inits mutate global options (e.g.
  starship needs `setopt promptsubst`), which a local scope would revert.
- **mise is deliberately NOT cached** — `mise activate` bakes in a live `$PATH`
  snapshot (including ephemeral dirs), so it must run on every shell.
- **`compinit` is owned explicitly** in `.zshrc` with a cached dump (`-C`, full audit at
  most once a day) *before* the env-specific configs, so any completion include they
  source finds `compdef` already defined and skips a second, slower `compinit`.
- **autojump was replaced by zoxide** (`j`/`ji` aliased to `z`/`zi`).
- **dark-notify** is guarded by a pidfile + `kill -0` instead of `pgrep` (process-table
  scan); **`GOPATH` is static** in `.zshenv` instead of forking `go env`.

### Maintenance notes
- After upgrading a cached tool, `_evalcache` auto-regenerates when the binary mtime is
  newer. If a cached init ever looks stale, clear it: `rm -rf $XDG_CACHE_HOME/zsh/evalcache`.
- Base aliases/keybindings load once, before env-specific configs (they used to also
  re-load after). If an env config needs to override a base alias, it must do so after
  the modular-config loop — re-check this if adding such an override.

## Neovim Troubleshooting

### Snippet/Completion Issues
- **Custom snippets**: Defined in `nvim-config/lua/custom/plugins/nvim-cmp.lua`
- **Completion sources order matters**: LuaSnip should come before nvim_lsp to prioritize custom snippets
- **TypeScript/JSX files**: Use `typescript-tools.nvim` (not tsserver) with snippet completions disabled
- **HTML/Emmet completion**: `emmet_ls` restricted to HTML/CSS files only to avoid JSX conflicts
- **Snippet conflicts**: Use high priority values (e.g. 1000) and exclude unwanted sources from friendly-snippets

### Key Plugin Interactions
- **Completion**: nvim-cmp + LuaSnip + typescript-tools + friendly-snippets
- **LSP**: nvim-lspconfig handles most servers, typescript-tools handles TS/JS
- **Emmet**: Both nvim-emmet (manual) and emmet_ls (auto) are configured
