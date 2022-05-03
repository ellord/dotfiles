# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias vim="nvim"
alias vi="nvim"
alias ll="ls -al"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Autojump (j search)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Secret envs
[ -f $HOME/.secrets ] && source $HOME/.secrets

# JetBrains IDE CLIs
export PATH=$PATH:$HOME/bin

# Go
export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
export GOBIN=$(go env GOPATH)/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Old version of Python 
export PATH="$HOME/Library/Python/2.7/bin:$PATH"

# To manage Python versions - mainly for gcloud compatibility
eval "$(pyenv init -)"

# Set Python version for gcloud CLI
export CLOUDSDK_PYTHON=python3

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/opt/homebrew/opt/helm@2/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
