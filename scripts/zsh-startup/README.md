# Zsh startup profiling toolkit

Three small, non-invasive tools for measuring and diagnosing zsh startup time. None
of them modify your real dotfiles — each builds a throwaway `ZDOTDIR` that *wraps*
`~/.zshenv` / `~/.zprofile` / `~/.zshrc`.

See the **Zsh Startup Performance** section in the repo `CLAUDE.md` for the design
decisions behind the current config (what was optimized and what must not be naively
reverted).

| Script | Purpose | Trust for |
|---|---|---|
| `measure-ttfp.sh [runs]` | Clean time-to-first-prompt + per-phase split | **Absolute totals** — the regression check |
| `bench-components.sh` | Micro-bench individual init commands | Relative comparison (warm-loop = optimistic) |
| `trace-startup.sh` | Microsecond xtrace, ranked by file/line | **Ordering / what-runs** (times inflated ~2-3×) |

## Workflow

```bash
# 1. Establish / re-check the baseline (run before and after any change):
./measure-ttfp.sh

# 2. If a phase looks heavy, see what runs in it and in what order:
./trace-startup.sh        # prints a ranking; writes a temp trace file

# 3. Sanity-check a specific command's cost:
./bench-components.sh
```

## Why three tools?

No single method is both accurate and complete:

- **xtrace** sees everything and the exact order, but logging per-command inflates
  anything that fans out (e.g. `compinit` → hundreds of `compdef`).
- **warm micro-benchmarks** are clean but optimistic (caches warm across iterations).
- **time-to-first-prompt phase timing** (what `measure-ttfp.sh` does) is the
  trustworthy absolute measure.

Cross-reference all three and they reconcile.

## Notes

- Numbers vary with system load and with which tools you have installed / which
  profile is active. Take medians and discard readings that coincide with a high load
  average (`uptime`).
- `trace-startup.sh` writes its trace to a temp file (it captures your full
  environment), not into the repo. Delete it when done.
- A "snappy" interactive shell is usually considered < 200 ms to first prompt.

## Baseline reference (Apple Silicon, warm, median)

```
                  before     after
zshenv          ~18 ms      ~7 ms
zprofile       ~246 ms     ~14 ms
zshrc          ~199 ms   ~110 ms
prompt          ~40 ms     ~40 ms
TOTAL          ~490 ms    ~170 ms
```
