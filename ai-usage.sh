#!/bin/sh
# Tab bar entry: Claude plan usage from the CodexBar CLI, e.g. "󰚩 Claude 11% · wk 9%"
# (5-hour window, then weekly), with 🟡 / 🔴 above 60% / 85% of whichever window is fuller.
# A provider that fails to report shows "⚠️ <name> err" with CodexBar's message.

ICON="$(printf '\363\260\232\251')" # Nerd Font robot, U+F06A9

codexbar usage --provider claude --format json 2>/dev/null | jq -j --arg icon "$ICON" '
  def name: if .provider == "claude" then "Claude" elif .provider == "codex" then "Codex" else .provider end;
  def dot: [.usage.primary.usedPercent, .usage.secondary.usedPercent] | max |
    if . >= 85 then " 🔴" elif . >= 60 then " 🟡" else "" end;
  [ sort_by(.provider) | .[] |
    if .error then "⚠️ \(name) err: \(.error.message // .error)"
    else "\($icon) \(name) \(.usage.primary.usedPercent)% · wk \(.usage.secondary.usedPercent)%\(dot)" end
  ] | join(" · ")'
