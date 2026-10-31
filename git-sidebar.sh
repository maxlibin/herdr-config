#!/bin/sh
# Reports each pane's git state to the Agent sidebar rows: the branch icon as
# one of $git_clean, $git_dirty or $git_behind (each coloured in config.toml)
# and the summary as $git. Values expire after TTL_MS, so they vanish if this
# stops running. Run periodically from a tab bar command entry; prints nothing.

TTL_MS=15000
TAB="$(printf '\t')"
ICON="$(printf '\356\202\240')" # Nerd Font git branch, U+E0A0

herdr pane list | jq -r '.result.panes[] | [.pane_id, (.foreground_cwd // .cwd)] | @tsv' |
  while IFS="$TAB" read -r pane cwd; do
    IFS="$TAB" read -r state summary <<SUMMARY
$(~/.config/herdr/git-summary.sh "$cwd")
SUMMARY
    for s in clean dirty behind; do
      if [ "$s" = "$state" ]; then
        herdr pane report-metadata "$pane" --source git-sidebar --token "git_$s=$ICON" --ttl-ms "$TTL_MS" >/dev/null
      else
        herdr pane report-metadata "$pane" --source git-sidebar --clear-token "git_$s" >/dev/null
      fi
    done
    if [ -n "$summary" ]; then
      herdr pane report-metadata "$pane" --source git-sidebar --token "git=$summary" --ttl-ms "$TTL_MS" >/dev/null
    else
      herdr pane report-metadata "$pane" --source git-sidebar --clear-token git >/dev/null
    fi
  done
