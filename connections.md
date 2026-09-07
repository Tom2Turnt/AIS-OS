# Connections

Registry of every system your AIOS can reach. Filled by `/onboard` from Q4-Q7 answers; expanded over time as you wire new tools. `/audit` checks this file for domain coverage and freshness.

| # | Domain | Tool | Mechanism | Auth | Last checked |
|---|---|---|---|---|---|
| 1 | Revenue / Financials | Stripe (bank payout coming); Etsy + YouTube not paying yet | not yet connected | — | — |
| 2 | Customer interactions | Gmail (personal), iMessage, cold email; referrals bring most clients | Gmail: `mcp` (claude.ai Gmail connector, hosted by Google; see `references/gmail-api.md`). iMessage: not yet connected | OAuth on claude.ai, account-level, no local key | 2026-09-07 connected (live inbox read) |
| 3 | Calendar | Google Calendar | `mcp` (claude.ai Google Calendar connector, same mechanism as Gmail; see `references/google-calendar-api.md`) | OAuth on claude.ai. **Staged, needs OAuth click:** claude.ai → Settings → Connectors → Google Calendar → Connect | 2026-09-07 staged, not yet live |
| 4 | Communication | Gmail, iMessage. No team channel (solo) | Gmail: `mcp` (same claude.ai Gmail connector as row 2). iMessage: not yet connected | OAuth on claude.ai | 2026-09-07 Gmail connected; iMessage — |
| 5 | Project / task tracking | Obsidian (SchoolWork vault) + Canvas | not yet connected | — | — |
| 6 | Meeting intelligence | Call recorder (none yet) | not yet connected | — | — |
| 7 | Knowledge / files | Google Drive; Obsidian vaults on GitHub (PageCrispBrain, HermesClawVault, SchoolWork) | not yet connected | — | — |

**Mechanism options:** `mcp` (MCP server), `script` (Python/Bash hitting an API, in `scripts/`), `export` (CSV/JSON dump pipeline), `key+ref` (`.env` key + `references/{tool}-api.md` guide), `not yet connected`.

When you wire a new tool, also save `references/{tool}-api.md` capturing endpoints, auth flow, and common queries — researched-once-saved-forever.
