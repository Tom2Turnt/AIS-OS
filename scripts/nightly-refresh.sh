#!/bin/bash
# Nightly refresh for the AI OS. Runs from a LaunchAgent (bare PATH), so every path is absolute.
# 1. mirror the VPS fantasy-brain vault   2. pull the three Obsidian vaults   3. rebuild the 3D brain
# Each step is allowed to fail on its own (cellular link, no network, VPS down); the rest still runs.

set -u
AIOS="/Users/tom2turnt/AI/projects/AIS-OS"
NODE="/Users/tom2turnt/.local/share/fnm/node-versions/v24.19.0/installation/bin/node"
LOG="$AIOS/logs/cadence.log"
mkdir -p "$AIOS/logs" "/Users/tom2turnt/AI/vps/mirrors/fantasy-brain"
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"

stamp() { date "+%Y-%m-%d %H:%M"; }
note=""

# 1. VPS mirror (ssh alias `vps` from ~/.ssh/config, key auth, no prompt)
if /usr/bin/rsync -az --timeout=40 -e "/usr/bin/ssh -o BatchMode=yes -o ConnectTimeout=15" \
    --include='*/' --include='*.md' --exclude='*' \
    vps:~/fantasy-brain/vault/ /Users/tom2turnt/AI/vps/mirrors/fantasy-brain/ >/dev/null 2>&1; then
  note="$note vps=ok"
else
  note="$note vps=fail"
fi

# 2. Vault pulls (fast-forward only; skip quietly if offline or dirty)
for v in PageCrispBrain HermesClawVault SchoolWork; do
  d="/Users/tom2turnt/AI/$v"
  if /usr/bin/git -C "$d" pull --ff-only -q >/dev/null 2>&1; then
    note="$note $v=ok"
  else
    note="$note $v=skip"
  fi
done

# 3. Rebuild the brain
if out=$(cd "$AIOS/apps/3d-brain" && "$NODE" build.mjs 2>&1); then
  note="$note brain=[$(echo "$out" | tail -1 | tr -d '\n')]"
else
  note="$note brain=fail"
fi

echo "$(stamp) nightly-refresh:$note" >> "$LOG"
