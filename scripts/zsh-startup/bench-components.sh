#!/usr/bin/env bash
# Clean high-resolution micro-benchmarks of individual startup commands.
# NOTE: warm-loop medians UNDER-report (FS/PATH caches warm up across iterations),
# so they are optimistic. Good for RELATIVE comparison ("which init is heaviest").
# For trustworthy absolute per-phase numbers use measure-ttfp.sh.
# Resolution is microseconds via zsh/datetime.
#
# Usage: ./bench-components.sh
#
# Snippets below are deliberately single-quoted: they are passed verbatim to a
# sub-shell (`zsh -f -c`) which does the expansion, not this bash script.
# shellcheck disable=SC2016
set -euo pipefail

hb() {
    local label="$1" snippet="$2" N="${3:-9}"
    local out
    out=$(zsh -f -c '
    zmodload zsh/datetime
    N='"$N"'
    typeset -a t
    for i in {1..$N}; do
      t0=$EPOCHREALTIME
      eval "'"$snippet"'" >/dev/null 2>&1
      t1=$EPOCHREALTIME
      t+=$(( (t1-t0)*1000 ))
    done
    print -l $t | sort -n | awk "{a[NR]=\$1} END{n=NR; m=(n%2)?a[int((n+1)/2)]:(a[n/2]+a[n/2+1])/2; printf \"%7.1f ms  (min %.1f, max %.1f)\", m, a[1], a[n]}"
  ')
    printf "%-42s %s\n" "$label" "$out"
}

echo "### Clean component micro-benchmarks (median) ###"
echo
hb "compinit (full, with security audit)" 'autoload -Uz compinit; compinit'
hb "compinit -C (skip audit + dump check)" 'autoload -Uz compinit; compinit -C'
hb "compaudit (insecure-dir scan)" 'autoload -Uz compaudit; compaudit'
echo
command -v mise >/dev/null && hb "mise activate zsh" 'eval "$(mise activate zsh)"'
command -v starship >/dev/null && hb "starship init zsh" 'eval "$(starship init zsh)"'
command -v zoxide >/dev/null && hb "zoxide init zsh" 'eval "$(zoxide init zsh)"'
command -v fzf >/dev/null && hb "fzf --zsh" 'eval "$(fzf --zsh)"'
command -v pyenv >/dev/null && hb "pyenv init --path" 'eval "$(pyenv init --path)"'
if command -v brew >/dev/null; then
    hb "brew shellenv" 'eval "$('"$(command -v brew)"' shellenv)"'
fi
command -v go >/dev/null && hb "go env GOPATH" 'go env GOPATH'
