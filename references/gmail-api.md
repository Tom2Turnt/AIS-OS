# Gmail (personal) — how it's wired

**Mechanism:** `mcp` — the first-party **claude.ai Gmail connector**. It is a hosted MCP server run by Google (`https://gmailmcp.googleapis.com/mcp/v1`) that Claude Code picks up automatically from your claude.ai account. Nothing is installed on this Mac and no key lives in this repo.

**Verified on 2026-09-07:** `claude -p "list my 3 newest inbox emails"` run from this folder returned real subjects and senders.

## Auth flow

- Scope in Claude Code: `claude.ai config` (`claude mcp get "claude.ai Gmail"`). It is account-level, so it works in every folder, including this one.
- The OAuth grant lives on claude.ai, tied to the personal Gmail account. No client secret, no token file, nothing in `.env`.
- Scopes the server offers: `gmail.readonly`, `gmail.metadata`, `gmail.compose`, `gmail.modify`, full `mail.google.com`. What you actually granted is whatever you clicked through on claude.ai.

## Check it is alive

```
claude mcp list            # look for: claude.ai Gmail ... Connected
claude mcp get "claude.ai Gmail"
```

## Re-auth (if it says "Needs authentication" or tools error with 401)

1. Open `https://claude.ai/settings/connectors` in the personal Chrome profile (`browser open https://claude.ai/settings/connectors`).
2. Find **Gmail**, click **Disconnect** then **Connect**, pick the personal Gmail account, accept.
3. Back in Claude Code run `/mcp` or restart the session. `claude mcp list` should show Connected again.

## Tools (all prefixed `mcp__claude_ai_Gmail__`)

| Want to | Tool |
|---|---|
| Find threads | `search_threads` (Gmail query syntax, max 50/page, returns subject + snippet, not the body) |
| Read a full thread / one message | `get_thread`, `get_message` |
| Labels | `list_labels`, `create_label`, `update_label`, `delete_label`, `label_thread`, `unlabel_thread`, `label_message`, `unlabel_message`, `update_message_labels` |
| Drafts | `list_drafts`, `get_draft`, `create_draft`, `update_draft` |
| Send | `send_message`, `reply`, `forward` |
| Clean up | `trash_thread`, `trash_message`, `untrash_*`, `mark_thread_spam`, `mark_message_spam`, `unmark_*` |

House rule from CLAUDE.md: draft first, show me, then send. Never send external mail without a shown draft.

## Common queries (pass as `query` to `search_threads`)

| Ask | Gmail query |
|---|---|
| What's in my inbox today | `in:inbox newer_than:1d` |
| Unread only | `in:inbox is:unread` |
| Anything from a client | `from:client@example.com newer_than:30d` |
| Waiting on replies I sent | `in:sent newer_than:7d` then check for no reply in thread |
| Attachments this week | `has:attachment newer_than:7d` |
| Skip promos | `in:inbox -category:promotions -category:social newer_than:2d` |
| Stripe / money | `from:stripe.com OR subject:(invoice OR payout) newer_than:30d` |

Tips: `search_threads` gives snippets only. Call `get_thread` with the thread id when you need the body. Label filters take label IDs, not names; get them from `list_labels`. Full operator list: `~/.claude/skills/google-workspace/references/gmail-search-syntax.md`.

## Plan B (only if the claude.ai connector ever goes away)

Add Google's Gmail MCP directly, project-scoped, with your own Google Cloud OAuth client (Desktop app type, Gmail API enabled):

```
claude mcp add --transport http gmail https://gmailmcp.googleapis.com/mcp/v1 \
  --scope project --client-id <id> --client-secret
```

That writes `.mcp.json` with only the client id (secret goes to the keychain via the prompt, or `MCP_CLIENT_SECRET`). Then `/mcp` in a session to log in. Not needed today.
