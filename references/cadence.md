# Cadence: what runs on its own

Two launchd jobs on this Mac. Both survive a closed laptop: launchd runs a missed calendar job the next time the machine wakes, so a brief still lands when the lid opens.

| Job | When | Script | What it does |
|---|---|---|---|
| `com.tomgabel.aios.nightly` | 03:30 daily | `scripts/nightly-refresh.sh` | Mirrors the VPS fantasy-brain vault, pulls the three Obsidian vaults (PageCrispBrain, HermesClawVault, SchoolWork), rebuilds the 3D brain. |
| `com.tomgabel.aios.morning` | 07:00 daily | `scripts/morning-brief.sh` | Runs `claude -p` from this folder with only the context files, writes `briefs/YYYY-MM-DD.md`, shows a macOS notification. Skips if today's brief exists. |

Plists: `~/Library/LaunchAgents/com.tomgabel.aios.{nightly,morning}.plist`.

## Where things land

- `logs/cadence.log` — one line per run, with each step's result (`vps=ok`, `SchoolWork=skip`, `brain=[AI OS: 846 notes ...]`).
- `logs/*.out`, `logs/*.err`, `logs/morning-brief.err` — raw output.
- `briefs/` — one Markdown file per day. Both folders are gitignored.

## Run by hand

```
bash scripts/nightly-refresh.sh
bash scripts/morning-brief.sh --force     # --force rewrites today's brief
```

Or through launchd: `launchctl kickstart -k gui/501/com.tomgabel.aios.morning`.

## Pause and resume

```
launchctl bootout gui/501/com.tomgabel.aios.morning     # pause
launchctl bootstrap gui/501 ~/Library/LaunchAgents/com.tomgabel.aios.morning.plist   # resume
launchctl print gui/501/com.tomgabel.aios.morning | head  # status
```

## Gotchas

- LaunchAgents start with a bare PATH, so the scripts use absolute paths for node, claude, git, rsync.
- `claude -p` needs `USER` and `HOME` set or it reports "Not logged in". The script exports both.
- Email delivery is not wired. Nothing on this Mac sends mail without new credentials, so the brief is a file plus a notification. Once Gmail is connected, the morning script can hand the brief to it.
- The morning job uses Tom's Claude subscription through the normal Claude Code login. No API key.
