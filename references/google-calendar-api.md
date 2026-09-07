# Google Calendar — how it's wired

**Mechanism:** `mcp` — the first-party **claude.ai Google Calendar connector**. Same setup as Gmail: a hosted MCP server run by Google (`https://calendarmcp.googleapis.com/mcp/v1`) that Claude Code picks up from your claude.ai account. Nothing installed on this Mac, no key in this repo, no `.env` entry.

**Status (2026-09-07): staged, needs one OAuth click.** Not verified with live data yet. Gmail and Drive are already connected this way; Calendar is the only one missing.

## The one click (Tom)

1. Open `https://claude.ai/settings/connectors` in the personal Chrome profile (`browser open https://claude.ai/settings/connectors`). It must be the same claude.ai account Claude Code is logged into.
2. Find **Google Calendar** → **Connect**.
3. Pick the personal Gmail account on the Google screen, click **Allow**.
4. Back in the terminal, in this folder: `claude mcp list`. You should see `claude.ai Google Calendar ... Connected`.
5. Test: `claude -p "list my next 3 calendar events"`. If it answers with real events, change the status line at the top of this file to "verified on <date>" and set row 3 of `connections.md` to connected.

## Auth flow

- Scope in Claude Code: `claude.ai config`, account-level, works in every folder.
- Grant lives on claude.ai. Scopes the server offers run from `calendar.readonly` and `calendar.events.readonly` up to full `calendar`. You get whatever you accept on the Google screen.

## Re-auth

Same as Gmail: `https://claude.ai/settings/connectors` → Google Calendar → Disconnect → Connect. Then `/mcp` in a session or restart it.

## Tools (expected prefix `mcp__claude_ai_Google_Calendar__`, per Google's server docs)

| Want to | Tool |
|---|---|
| See which calendars exist | `list_calendars` |
| What's on tomorrow / this week | `list_events` (time window, calendar id) |
| One event's details | `get_event` |
| Free slots | `suggest_time` |
| Make / change / remove | `create_event`, `update_event`, `delete_event` |
| RSVP | `respond_to_event` |

Confirm the exact tool names after connecting: they appear in the deferred tool list, or run `claude mcp get "claude.ai Google Calendar"`.

## Common questions → what to call

| Ask | Call |
|---|---|
| What's on my calendar tomorrow | `list_events` from tomorrow 00:00 to 23:59 local (Los Angeles) on the primary calendar |
| This week at a glance | `list_events` Mon–Sun, then group by day |
| When am I free for a client call | `suggest_time` or `list_events` + gaps outside school hours |
| Add a PageCrisp call | `create_event` with title, time, attendee email; show me first |

House rule: read freely; creating, moving, or deleting events gets shown to me before it happens.

## Plan B (only if the claude.ai connector is not an option)

Point Claude Code at Google's server directly with your own Google Cloud OAuth client (Desktop app type, Google Calendar API enabled). Google's auth server does not do dynamic client registration, so the client id is required:

```
claude mcp add --transport http google-calendar https://calendarmcp.googleapis.com/mcp/v1 \
  --scope project --client-id <id> --client-secret
```

This writes `.mcp.json` with the client id only (the secret is prompted and stored by Claude Code, or read from `MCP_CLIENT_SECRET`). Then `/mcp` in a session to log in. Needs a Google Cloud project, so it is more work than the one click above.
