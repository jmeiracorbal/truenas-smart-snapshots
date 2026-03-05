#!/bin/bash

folder=tmp
out="/${folder}/disk_report_$(date +%F_%H%M%S).txt"
for d in /dev/sd{a..z}; do
  [ -b "$d" ] || continue
  echo "================================================================================" >> "$out"
  echo "DISK: $d  $(lsblk -dn -o MODEL,SERIAL,SIZE,HCTL,TRAN "$d" 2>/dev/null)" >> "$out"
  echo "--------------------------------------------------------------------------------" >> "$out"
  echo "[SMART SUMMARY]" >> "$out"
  smartctl -H -i -c "$d" >> "$out" 2>&1
  echo >> "$out"
  echo "[SMART ATTRS - physical/media + electronic/link]" >> "$out"
  smartctl -A "$d" >> "$out" 2>&1
  echo >> "$out"
  echo "[SMART ERROR LOG - includes link/device errors history]" >> "$out"
  smartctl -l error "$d" >> "$out" 2>&1
  echo >> "$out"
  echo "[SMART SELF-TEST LOG]" >> "$out"
  smartctl -l selftest "$d" >> "$out" 2>&1
  echo >> "$out"
  echo "[SATAPHY (link events, if supported)]" >> "$out"
  smartctl -l sataphy "$d" >> "$out" 2>&1
  echo >> "$out"
done
echo "$out"
