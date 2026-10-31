#!/bin/sh
# Tab bar entry: git summary of the focused herdr pane's directory,
# or "no repo" when it is not inside a git repository.

cwd=$(herdr pane current | jq -r '.result.pane.foreground_cwd // .result.pane.cwd')
summary=$(~/.config/herdr/git-summary.sh "$cwd" | cut -f2)
printf "\356\202\240 %s" "${summary:-no repo}" # Nerd Font git branch, U+E0A0
