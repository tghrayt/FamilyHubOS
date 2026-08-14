# FamilyHubOS - Telegram

## Role

Telegram is the FamilyHubOS remote control. It should work mainly through a private family group and inline buttons.

## n8n Environment Variables

Configure the bot token on the n8n deployment, not in Git:

```text
TELEGRAM_BOT_TOKEN
```

`TELEGRAM_BOT_TOKEN` is used by `FAMILYHUBOS-WORKFLOW` to call Telegram `sendMessage`.

For the first Telegram test, the allowed Telegram user/chat id and child birth date are defined directly in the workflow because this n8n instance blocks `$env` access inside Code nodes.

## Security

Every message or callback must be rejected unless both checks pass when configured :

- `TELEGRAM_ALLOWED_USER_IDS`
- `TELEGRAM_ALLOWED_CHAT_IDS`

Unauthorized users should receive no sensitive information.

## Commands

Initial command set:

- `/start`
- `/help`
- `/next`
- `/meeting`
- `/choose`
- `/idea`
- `/history`
- `/decisions`
- `/random`
- `/status`

First command set:

- `/start`
- `/help`
- `/choose`
- `/idea`
- `/status`

## /choose

Flow :

1. Show the main choice.
2. Let parents choose automatic, category, topic, or backlog.
3. If category is selected, show category buttons.
4. If topic is needed, offer generated candidates or free text.

Main buttons :

- `Laisse FamilyOS choisir`
- `Choisir une catégorie`
- `Choisir directement un sujet`
- `Voir les idées en attente`

Categories :

- Développement
- Nutrition
- Santé
- Culture
- Musique
- Sciences
- Loisirs
- Parentalité
- Nature
- Lecture
- Autre

## /idea

Example :

```text
/idea Comment transmettre plusieurs langues à notre enfant ?
```

Expected behavior :

- Create a topic in Notion later.
- Status: `Idea`.
- Source: `Telegram`.
- Store author and date.

## Callback Design

Callbacks should include stable IDs, not raw business text when possible.

Example :

```text
familyhubos:choose:category:science:v1
familyhubos:topic:selected:<topicId>:v1
familyhubos:auto:v1
```

## Telegram Test Scenarios

- Authorized user starts `/choose`.
- Unauthorized user sends `/choose`.
- Unknown command.
- Category callback.
- Topic callback.
- Double click on the same callback.
- Timeout while waiting for parent choice.

## Telegram Webhook Setup

After `FAMILYHUBOS-WORKFLOW` is synced and activated in n8n, configure the Telegram bot webhook to the production webhook URL:

```text
https://<N8N_HOST>/webhook/familyhubos/telegram
```

Use Telegram `setWebhook` with the real bot token from the VM or a secure terminal:

```bash
curl -X POST "https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/setWebhook" \
  -d "url=https://<N8N_HOST>/webhook/familyhubos/telegram"
```

Then send `/status` from the allowed Telegram chat.
