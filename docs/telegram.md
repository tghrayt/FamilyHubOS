# FamilyHubOS - Telegram

## Role

Telegram is the FamilyHubOS remote control. It should work mainly through a private family group and inline buttons.

Current authorized family group chat ID: `-5543186089`.

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

1. `/choose` sends inline category buttons.
2. Parent clicks a category.
3. Telegram sends a callback query to the same webhook.
4. FamilyHubOS sends 3 suggested topic buttons.
5. Parent clicks a topic.
6. FamilyHubOS sends a draft meeting preview with decision buttons.
7. Parent validates the topic or goes back to category selection.
8. When validated, FamilyHubOS checks whether a matching Notion page already exists for the same topic, category and date.
9. If it exists, FamilyHubOS returns the existing page URL. Otherwise it creates a new page in `Meetings`.

Main buttons :

- `Laisse FamilyOS choisir`
- category buttons

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

- Create a page in the Notion `Topics` database immediately.
- Status: `Not started`.
- Source: `Telegram`.
- Store author and return the Notion page URL in Telegram.
- If the same `/idea` text already exists in the `Topics` database, reuse the existing page instead of creating a duplicate.

## Callback Design

Callbacks should include stable IDs, not raw business text when possible.

Example :

```text
familyhubos:choose:category:science:v1
familyhubos:topic:<categoryId>:<topicId>:v1
familyhubos:auto:v1
```

## Main Menu

`/start` and `/help` show inline menu buttons for proposing a topic, preparing a meeting, reading the latest meeting, checking status and learning how to add an idea. The menu uses callback data under `familyhubos:menu:*:v1`. `menu`, `accueil` and `home` also return to the main menu.

## Whoami Diagnostic

`/whoami` returns the current Telegram chat ID, chat type, user ID, username and allowlist status. It is used when preparing the family group with both parents.

## Last Meeting

`/last` returns the latest recorded meeting from PostgreSQL. The same intent can also be sent without a slash by writing `dernier meeting`, `dernier sujet` or `last meeting`.

## Telegram Test Scenarios

- Authorized user starts `/choose`.
- Unauthorized user sends `/choose`.
- Unknown command.
- Category callback.
- Topic callback.
- Topic approval callback.
- Back to categories callback.
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
