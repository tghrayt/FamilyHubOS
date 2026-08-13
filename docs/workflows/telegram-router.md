# FAMILYOS_05_TELEGRAM_ROUTER

## Purpose

`FAMILYOS_05_TELEGRAM_ROUTER` is the entrypoint for Telegram messages and callbacks.

It normalizes Telegram updates into the `telegram-interaction.schema.json` contract, checks authorization, then routes commands to the right MVP behavior.

## Inputs

Telegram webhook update:

```json
{
  "update_id": 123,
  "message": {
    "text": "/choose",
    "chat": { "id": -100123 },
    "from": { "id": 123, "username": "parent" }
  }
}
```

## Authorization

The workflow reads:

```text
TELEGRAM_ALLOWED_USER_IDS
TELEGRAM_ALLOWED_CHAT_IDS
```

Both must match. If either allowlist is empty, the interaction is rejected.

Unauthorized interactions return:

```json
{ "ok": true }
```

No sensitive details are returned.

## Normalized Contract

The workflow emits:

```json
{
  "interactionId": "string",
  "chatId": "string",
  "userId": "string",
  "username": "string|null",
  "receivedAt": "date-time",
  "type": "command|callback|message",
  "command": "string|null",
  "callbackData": "string|null",
  "messageText": "string|null",
  "authorized": true,
  "payload": {}
}
```

See:

```text
schemas/telegram-interaction.schema.json
```

## MVP Routes

Implemented skeleton routes:

- `/start`
- `/help`
- `/choose`
- `/idea`
- `/status`
- callback data
- unknown message/command

## Current Behavior

The skeleton currently returns JSON responses to the webhook so the routing can be tested without sending real Telegram messages.

Later iterations will replace or extend the response step with Telegram `sendMessage` calls using n8n credentials.

## Next Integrations

- `/choose` should call `FAMILYOS_01_WEEKLY_PLANNER`.
- `/idea` should create a `Topic` in Notion.
- callback routes should update conversation state in PostgreSQL database `familyos`.
- repeated callback interactions should use `idempotency_keys`.

## Test Scenarios

Given an authorized user and chat, when `/start` is received, then route is `start`.

Given an authorized user and chat, when `/choose` is received, then route is `choose` and next workflow is `FAMILYOS_01_WEEKLY_PLANNER`.

Given an authorized user and chat, when `/idea Texte` is received, then route is `idea` and the idea payload contains `Texte`.

Given an unauthorized user, when any command is received, then no sensitive route information is returned.

Given an authorized callback, when callback data is received, then route is `callback`.

