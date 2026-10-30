#!/bin/sh
# Tab bar entry: git summary of the focused herdr pane's directory,
# or "🌿 no repo" when it is not inside a git repository.

cwd=$(herdr pane current | jq -r '.result.pane.foreground_cwd // .result.pane.cwd')
summary=$(~/.config/herdr/git-summary.sh "$cwd")
printf "%s" "${summary:-🌿 no repo}"
