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

Unauthorized requests receive a neutral response.

## Placeholders

The workflow still contains placeholders for research, source validation, Notion, Calendar and notifications. These placeholders are deliberate so import and debugging stay safe before real credentials are wired.
