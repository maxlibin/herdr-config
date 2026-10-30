#!/bin/sh
# Tab bar entry: memory in use like Activity Monitor (app + wired + compressed),
# e.g. "🧠 18.4/36G", with a 🟡 / 🔴 warning above 75% / 90%.

total=$(sysctl -n hw.memsize)
vm_stat | awk -v total="$total" '
  /page size of/                { page = $8 }
  /^Anonymous pages/            { anon = $3 }
  /^Pages purgeable/            { purgeable = $3 }
  /^Pages wired down/           { wired = $4 }
  /^Pages occupied by compressor/ { compressed = $5 }
  END {
    used = (anon - purgeable + wired + compressed) * page
    pct = used * 100 / total
    dot = pct >= 90 ? " 🔴" : (pct >= 75 ? " 🟡" : "")
    printf "🧠 %.1f/%.0fG%s", used / 1073741824, total / 1073741824, dot
  }'
