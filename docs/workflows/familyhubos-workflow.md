# FAMILYHUBOS-WORKFLOW

This is the only n8n workflow exported by the project.

## Test Path

`Manual Test Trigger` builds a safe test input with:

```text
child.birthDate = 2025-12-01
now = 2026-08-14T12:00:00.000Z
```

Expected status:

```text
TEST_SUCCESS
```

## Telegram Path

`Telegram Webhook` normalizes Telegram updates from the n8n webhook body, applies user/chat allowlists, then routes commands and sends a Telegram message with `sendMessage`.

Supported early commands:

- `/start`
- `/help`
- `/status`
- `/choose`
- `/idea`
- `/last`
- `/whoami`

`/start` and `/help` return a compact Telegram menu with a direct topic proposal action. `/choose` returns inline category buttons. `/last` reads PostgreSQL and returns the latest recorded meeting. Natural text such as `dernier meeting` is also accepted. Category button clicks are handled through Telegram callback queries.

`/whoami` is a limited diagnostic exception: it can pass the allowlist check so a new Telegram group ID can be discovered before the group is authorized.

Unauthorized requests receive a neutral response.

## Placeholders

The workflow now creates deterministic source candidates for each category and writes them into the Notion meeting page. These are not fetched or verified automatically yet; they are clearly marked as candidates until the web search and LLM steps are connected.
