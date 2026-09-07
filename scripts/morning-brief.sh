#!/bin/bash
# Morning brief for the AI OS. Runs from a LaunchAgent at 07:00 (bare PATH, absolute paths only).
# Asks Claude Code, non-interactively and from the AI OS folder, for today's brief built only from
# the context files. Writes briefs/YYYY-MM-DD.md and shows a macOS notification with the first line.
# A closed laptop gets the brief the next time it wakes: launchd runs missed calendar jobs on wake.

set -u
AIOS="/Users/tom2turnt/AI/projects/AIS-OS"
CLAUDE="/Users/tom2turnt/.local/bin/claude"
LOG="$AIOS/logs/cadence.log"
TODAY="$(date +%Y-%m-%d)"
OUT="$AIOS/briefs/$TODAY.md"
mkdir -p "$AIOS/logs" "$AIOS/briefs"
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/Users/tom2turnt/.local/bin"
export HOME="/Users/tom2turnt" USER="tom2turnt" LOGNAME="tom2turnt"

# Skip if today's brief already exists (kickstart or a second wake in one day).
if [ -s "$OUT" ] && [ "${1:-}" != "--force" ]; then
  echo "$(date '+%Y-%m-%d %H:%M') morning-brief: already have $OUT" >> "$LOG"
  exit 0
fi

PROMPT="Write today's brief for $(date '+%A, %B %-d, %Y'). Use only context/priorities.md, context/about-me.md, context/about-business.md and, if present, the newest file in briefs/. Format: a one-line title, then 3 bullets, each tied to one of the 90-day priorities and saying the one concrete thing to move it today. Then one line starting 'First today:' with the single thing to do first. Then one line starting 'Ask:' with a question of the form 'where could AI take [this task] off my plate?'. Plain words, short sentences, no jargon, no headers, under 150 words. Output only the brief."

cd "$AIOS" || exit 1
if brief=$("$CLAUDE" -p "$PROMPT" --output-format text 2>>"$AIOS/logs/morning-brief.err"); then
  printf '%s\n' "$brief" > "$OUT"
  first=$(printf '%s\n' "$brief" | sed -n '1p' | cut -c1-120)
  /usr/bin/osascript -e "display notification \"$(printf '%s' "$first" | sed 's/"/\\"/g')\" with title \"AI OS morning brief\" subtitle \"$TODAY\"" >/dev/null 2>&1
  echo "$(date '+%Y-%m-%d %H:%M') morning-brief: wrote $OUT ($(printf '%s' "$brief" | wc -w | tr -d ' ') words)" >> "$LOG"
else
  echo "$(date '+%Y-%m-%d %H:%M') morning-brief: FAILED (see logs/morning-brief.err)" >> "$LOG"
  exit 1
fi
