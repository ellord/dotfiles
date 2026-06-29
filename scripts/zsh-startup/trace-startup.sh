#!/usr/bin/env bash
# Capture a microsecond-timestamped xtrace of a full login+interactive startup and
# rank cost by file and by line. Use this to FIND what runs and in what order.
# Your real config is never modified (a throwaway ZDOTDIR wraps the real ~/.zsh*).
#
# ⚠️ xtrace inflates absolute times ~2-3x (a line is logged per command, so anything
# that fans out into many calls — e.g. compinit's compdef cascade — looks heavier
# than it is). Trust ordering/relative signal here; trust measure-ttfp.sh and
# bench-components.sh for absolute numbers.
#
# The trace is written to a temp file (it contains your full environment, so it is
# kept out of the repo) and the path is printed so you can inspect it.
#
# Usage: ./trace-startup.sh   (prints a ranking + the trace path)
#
# $HOME below is written verbatim into wrapper rc files for the child zsh to expand,
# so it must not be expanded here.
# shellcheck disable=SC2016
set -euo pipefail

WORK="$(mktemp -d)"
OUT="$(mktemp -t zsh-startup-trace.XXXXXX)"

cat >"$WORK/.zshenv" <<'EOF'
zmodload zsh/datetime
setopt xtrace prompt_subst
PS4='+$EPOCHREALTIME|%N:%i> '
source "$HOME/.zshenv"
ZSH_CONFIG_DIR="$HOME"
EOF
echo 'source "$HOME/.zprofile"' >"$WORK/.zprofile"
printf 'source "$HOME/.zshrc"\nunsetopt xtrace\n' >"$WORK/.zshrc"

ZDOTDIR="$WORK" zsh -l -i -c exit 2>"$OUT"
echo "Trace: $OUT ($(wc -l <"$OUT") lines) — contains your environment; delete when done."
rm -rf "$WORK"

python3 - "$OUT" <<'PYEOF'
import re, collections, sys, os
txt = open(sys.argv[1]).read()
toks = re.findall(r'\+(\d+\.\d+)\|([^:>]+):(\d+)>', txt)
ev = [(float(t), f, int(l)) for t, f, l in toks]
home = os.path.expanduser("~") + "/"
short = lambda f: f.replace(home, "~/")
by_file, by_line = collections.defaultdict(float), collections.defaultdict(float)
for i in range(len(ev)-1):
    d = ev[i+1][0] - ev[i][0]
    if d < 0: continue
    by_file[short(ev[i][1])] += d
    by_line[(short(ev[i][1]), ev[i][2])] += d
print("\n=== Cost by file (xtrace-inflated; relative signal only) ===")
for f, d in sorted(by_file.items(), key=lambda x:-x[1])[:15]:
    print(f"  {d*1000:7.1f} ms   {f}")
print("\n=== Top 20 lines ===")
for (f, l), d in sorted(by_line.items(), key=lambda x:-x[1])[:20]:
    print(f"  {d*1000:7.1f} ms   {f}:{l}")
PYEOF
