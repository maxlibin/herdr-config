#!/bin/sh
# Tab bar entry: CPU busy percentage, e.g. " 23%", with 🟡 / 🔴 above 70% / 90%.

top -l 2 -s 1 -n 0 | awk '/CPU usage/ { u = $3 + $5 } END {
  dot = u >= 90 ? " 🔴" : (u >= 70 ? " 🟡" : "")
  printf " %.0f%%%s", u, dot
}'
