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

### Mise Maintenance
- When bumping a tool version in mise config, old versions remain installed on disk
- `mise prune` does not reliably catch orphaned versions (known limitation with some backends)
- Use `mise ls` to find versions without a Source — those are orphans safe to remove
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
