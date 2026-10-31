# herdr status bar setup

Bottom tab bar with git, Claude usage, next calendar event, memory and CPU,
plus a per-agent git line in the left sidebar whose branch icon is coloured
green (clean and in sync), yellow (local changes or unpushed) or red (behind or
in conflict). Built for herdr 0.9.5 on macOS.

```
 main ✓ │ 󰚩 Claude 11% · wk 9% │ 📅 Standup in 12m │ 󰍛 18.4/48G │  2%
```

## Requirements

- A [Nerd Font](https://www.nerdfonts.com) in the terminal, for the icons
- `jq` (ships with recent macOS, else `brew install jq`)
- [CodexBar](https://github.com/steipete/CodexBar) with its `codexbar` CLI, for the Claude usage entry
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
| `git-sidebar.sh` | reports each pane's git state to the sidebar `$git_clean` / `$git_dirty` / `$git_behind` icon tokens and `$git` summary; prints nothing |
| `ai-usage.sh` | Claude 5-hour / weekly usage, 🟡 / 🔴 above 60% / 85% |
| `next-event/main.swift` | next timed calendar event within 7 days |
| `memory.sh` | memory used like Activity Monitor |
| `cpu.sh` | CPU busy percentage |
