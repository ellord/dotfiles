#!/usr/bin/env bash
# Measure clean time-to-first-prompt for a login+interactive zsh, with a coarse
# per-phase breakdown (.zshenv / .zprofile / .zshrc / prompt). No xtrace overhead.
#
# Uses a throwaway ZDOTDIR that wraps the REAL ~/.zsh* files, records EPOCHREALTIME
# at each phase boundary, and exits from a precmd hook (so prompt render is counted).
# Your real config is never modified.
#
# This is the primary "did I regress?" check — run it before and after any change to
# shell startup. Numbers vary with system load; take the median and ignore readings
# that coincide with a high load average.
#
# Usage: ./measure-ttfp.sh [runs]   (default 12)
set -euo pipefail

RUNS="${1:-12}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

cat >"$WORK/.zshenv" <<'EOF'
zmodload zsh/datetime
typeset -gF __T0=$EPOCHREALTIME __TE __TP __TR
source "$HOME/.zshenv"
__TE=$EPOCHREALTIME
ZSH_CONFIG_DIR="$HOME"
EOF

cat >"$WORK/.zprofile" <<'EOF'
source "$HOME/.zprofile"
__TP=$EPOCHREALTIME
EOF

cat >"$WORK/.zshrc" <<'EOF'
source "$HOME/.zshrc"
__TR=$EPOCHREALTIME
autoload -Uz add-zsh-hook
__report() {
  printf 'zshenv=%.1f zprofile=%.1f zshrc=%.1f prompt=%.1f TOTAL=%.1f\n' \
    $(( (__TE-__T0)*1000 )) $(( (__TP-__TE)*1000 )) $(( (__TR-__TP)*1000 )) \
    $(( (EPOCHREALTIME-__TR)*1000 )) $(( (EPOCHREALTIME-__T0)*1000 ))
  exit
}
add-zsh-hook precmd __report
EOF

echo "### Time-to-first-prompt, $RUNS runs (first run = cold, usually discard) ###"
for _ in $(seq 1 "$RUNS"); do
    ZDOTDIR="$WORK" zsh -l -i 2>/dev/null </dev/null
done | tee "$WORK/runs.txt"

echo
echo "=== Median per field (excluding run 1) ==="
for field in zshenv zprofile zshrc prompt TOTAL; do
    med=$(tail -n +2 "$WORK/runs.txt" | tr ' ' '\n' | grep "^$field=" | cut -d= -f2 |
        sort -n | awk '{a[NR]=$1} END{n=NR; if(n==0)exit;
            m=(n%2)?a[int((n+1)/2)]:(a[n/2]+a[n/2+1])/2; printf "%.1f", m}')
    printf "  %-10s %7s ms\n" "$field" "$med"
done
