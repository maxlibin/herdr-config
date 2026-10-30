#!/bin/sh
# Reports each pane's git summary as the $git token shown in the Agent
# sidebar rows. Values expire after TTL_MS, so they vanish if this stops
# running. Run periodically from a tab bar command entry; prints nothing.

TTL_MS=15000

herdr pane list | jq -r '.result.panes[] | [.pane_id, (.foreground_cwd // .cwd)] | @tsv' |
  while IFS="$(printf '\t')" read -r pane cwd; do
    summary=$(~/.config/herdr/git-summary.sh "$cwd")
    if [ -n "$summary" ]; then
      herdr pane report-metadata "$pane" --source git-sidebar --token "git=$summary" --ttl-ms "$TTL_MS" >/dev/null
    else
      herdr pane report-metadata "$pane" --source git-sidebar --clear-token git >/dev/null
    fi
  done
