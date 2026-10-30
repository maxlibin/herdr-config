#!/bin/sh
# Prints a one-line git summary of directory $1,
# e.g. "🌿 main ↑1 ↓2 +3 ~2 ?1" (ahead, behind, staged, modified, untracked),
# or nothing when $1 is not inside a git repository.

git -C "$1" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git -C "$1" status --porcelain=v2 --branch | awk '
  /^# branch.head/ { branch = $3 }
  /^# branch.ab/   { ahead = substr($3, 2) + 0; behind = substr($4, 2) + 0 }
  /^[12u] /        { if (substr($2, 1, 1) != ".") staged++; if (substr($2, 2, 1) != ".") modified++ }
  /^\? /           { untracked++ }
  END {
    out = "🌿 " branch
    if (ahead)     out = out " ↑" ahead
    if (behind)    out = out " ↓" behind
    if (staged)    out = out " +" staged
    if (modified)  out = out " ~" modified
    if (untracked) out = out " ?" untracked
    if (!staged && !modified && !untracked) out = out " ✓"
    printf "%s", out
  }'
