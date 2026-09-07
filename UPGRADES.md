# Upgrades in this fork

Everything below is added on top of [Nate Herk's AIS-OS](https://github.com/nateherkai/AIS-OS). The kit itself is his. MIT license and trademark notices are unchanged.

| Upgrade | What it does | Where |
|---|---|---|
| **AI OS Mac app** | One click opens the 3D brain in a native window. Starts the local server itself, stops it on quit. Adds a Connections tab for MCP servers, API keys, and a Four Cs status board. | Separate repo: [`ai-os-app`](https://github.com/Tom2Turnt/ai-os-app) |
| **Google connection** | Gmail + Google Calendar wired in so "what's on my calendar tomorrow" answers with live data. | `connections.md`, `references/gmail-api.md`, `references/google-calendar-api.md` |
| **Nightly cadence** | Mirrors remote vaults, rebuilds the brain, and drops a morning brief while the laptop is closed. | `scripts/`, `references/cadence.md` |

Filled-in personal context (`context/`, `references/voice.md`, the intake answers) is kept out of this public fork on purpose. Clone the kit, run `/onboard`, and yours stays local too.
