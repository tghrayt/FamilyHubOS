# FamilyOS - Telegram

## Role

Telegram is the FamilyOS remote control. It should work mainly through a private family group and inline buttons.

## Security

Every message or callback must be rejected unless both checks pass when configured :

- `TELEGRAM_ALLOWED_USER_IDS`
- `TELEGRAM_ALLOWED_CHAT_IDS`

Unauthorized users should receive no sensitive information.

## Commands

Initial command set :

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

MVP command set :

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

- Create a topic in Notion.
- Status : `Idea`.
- Source : `Telegram`.
- Store author and date.

## Callback Design

Callbacks should include stable IDs, not raw business text when possible.

Example :

```text
familyos:choose:category:science:v1
familyos:topic:selected:<topicId>:v1
familyos:auto:v1
```

## Telegram Test Scenarios

- Authorized user starts `/choose`.
- Unauthorized user sends `/choose`.
- Unknown command.
- Category callback.
- Topic callback.
- Double click on the same callback.
- Timeout while waiting for parent choice.

