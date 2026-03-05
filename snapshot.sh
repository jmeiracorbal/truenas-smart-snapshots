#!/bin/bash

ts=$(date +%F_%H%M%S)
folder=tmp
out="/${folder}/smart_snapshot_${ts}.txt"
for d in /dev/sd{a..z}; do
  [ -b "$d" ] || continue
  echo "===== $d $(lsblk -dn -o MODEL,SERIAL $d 2>/dev/null) =====" >> "$out"
  smartctl -A "$d" | egrep -i '^(  5|187|188|197|198|199) ' >> "$out" || true
done
echo "$out"
