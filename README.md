# herdr status bar setup

Bottom tab bar with git, Claude/Codex usage, next calendar event, memory and CPU,
plus a per-agent git line in the left sidebar. Built for herdr 0.9.5 on macOS.

```
🌿 main ✓ │ 🟢 Claude 11% wk 9% · 🟢 Codex 0% wk 0% │ 📅 Standup in 12m │ 🧠 18.4/48G │ ⚡ 2%
```

## Requirements

- `jq` (ships with recent macOS, else `brew install jq`)
- [CodexBar](https://github.com/steipete/CodexBar) with its `codexbar` CLI, for the Claude/Codex usage entry
- Xcode command line tools (`swiftc`), for the calendar helper

## Install

This repo is meant to live at `~/.config/herdr`. On a machine without herdr config yet:

```sh
git clone https://github.com/maxlibin/herdr-config.git ~/.config/herdr
cd ~/.config/herdr
(cd next-event && swiftc -O main.swift -o next-event \
  -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __info_plist -Xlinker Info.plist)
next-event/next-event          # first run asks for Calendar access
herdr config check && herdr server reload-config
```

If `~/.config/herdr` already exists, clone elsewhere and merge the `[ui]` and
`[ui.sidebar.agents]` sections of `config.toml` and copy the scripts by hand.
herdr's runtime files (logs, sockets, sessions) are git-ignored.

## Files

| File | Shows |
|---|---|
| `git-status.sh` | git summary of the focused pane (uses `git-summary.sh`) |
| `git-sidebar.sh` | reports each pane's git summary to the sidebar `$git` token; prints nothing |
| `ai-usage.sh` | Claude and Codex 5-hour / weekly usage, 🟢🟡🔴 by level |
| `next-event/main.swift` | next timed calendar event within 24 hours |
| `memory.sh` | memory used like Activity Monitor |
| `cpu.sh` | CPU busy percentage |
