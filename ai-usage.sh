#!/bin/sh
# Tab bar entry: Claude and Codex plan usage from the CodexBar CLI,
# e.g. "🟢 Claude 11% wk 9% · 🟢 Codex 0% wk 0%" (5-hour window, then weekly).
# The dot turns 🟡 at 60% and 🔴 at 85% of whichever window is fuller.
# A provider that fails to report shows "⚠️ <name> err" with CodexBar's message.

codexbar usage --provider both --format json 2>/dev/null | jq -j '
  def name: if .provider == "claude" then "Claude" elif .provider == "codex" then "Codex" else .provider end;
  def dot: [.usage.primary.usedPercent, .usage.secondary.usedPercent] | max |
    if . >= 85 then "🔴" elif . >= 60 then "🟡" else "🟢" end;
  [ sort_by(.provider) | .[] |
    if .error then "⚠️ \(name) err: \(.error.message // .error)"
    else "\(dot) \(name) \(.usage.primary.usedPercent)% wk \(.usage.secondary.usedPercent)%" end
  ] | join(" · ")'
