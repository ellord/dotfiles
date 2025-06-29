# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages configuration files for various development tools using GNU Stow. The repository contains configurations for vim, neovim, tmux, zsh, wezterm, and ghostty.

## Key Commands

### Installation
```bash
./install  # Main installation script that uses stow to symlink configurations
```

### Stow Management
```bash
stow vim       # Link vim configuration
stow zsh       # Link zsh configuration (uses --dotfiles flag)
stow tmux      # Link tmux configuration
```

### Homebrew Dependencies
```bash
brew bundle    # Install all dependencies from Brewfile
```

## Architecture & Structure

### Configuration Management
- Uses GNU Stow for symlink management
- Special configurations are manually symlinked (nvim, wezterm, ghostty)
- The `install` script handles all setup including git cloning of tmux plugins

### Key Directories
- `nvim-config/`: Neovim configuration based on kickstart.nvim
  - `lua/custom/plugins/`: Custom plugin configurations
  - Uses lazy.nvim for plugin management
- `zsh/`: Shell configuration with modular setup
  - `dot-zsh/`: Contains aliases, completions, keybindings, and path configurations
- `tmux/`: Tmux configuration with plugin support (TPM)
- `wezterm/`: Terminal emulator configuration
- `ghostty/`: Ghostty terminal configuration

### Notable Tools Configured
- Package managers: Homebrew, npm (via n), pyenv, pipx
- Development tools: neovim, git (with delta), gh, lazygit
- Search/navigation: fzf, ripgrep, zoxide
- Container tools: k9s, kubectx
- Language support: go, deno, luajit/luarocks

### Git Configuration
- Git configuration template at `git/.gitconfig` (copied, not symlinked)
- Current modifications tracked by git show uncommitted changes to ghostty, nvim plugins, wezterm, and zsh configurations