# FamilyOS - n8n Import Guide

## Goal

Import the prepared workflow skeletons into the existing n8n instance deployed in the Kubernetes namespace `automation`.

## Before Import

Confirm the n8n deployment:

```bash
sudo k3s kubectl -n automation get pods,svc,ingress,certificate
```

Confirm `n8n-postgres` exists:

```bash
sudo k3s kubectl -n automation get svc n8n-postgres
```

Do not paste secrets into workflow JSON files.

## Automatic Import

Preferred method:

```text
GitHub Actions -> Sync n8n Workflows
```

The sync workflow uses the n8n public API and repository secrets:

```text
N8N_URL
N8N_API_KEY
```

Run it first with `dry_run = true`.

Then run it with `dry_run = false` to create or update workflows in n8n.

The sync does not activate workflows automatically.

## Manual Import Order

Import subworkflows first:

```text
n8n/subworkflows/SUB_CONTEXT_BUILDER.json
n8n/subworkflows/SUB_WEB_SEARCH.json
n8n/subworkflows/SUB_SOURCE_VALIDATOR.json
n8n/subworkflows/SUB_NOTION.json
n8n/subworkflows/SUB_CALENDAR.json
n8n/subworkflows/SUB_NOTIFICATION.json
```

Then import main workflows:

```text
n8n/workflows/FAMILYOS_05_TELEGRAM_ROUTER.json
n8n/workflows/FAMILYOS_01_WEEKLY_PLANNER.json
n8n/workflows/FAMILYOS_02_RESEARCH.json
n8n/workflows/FAMILYOS_03_MEETING_BUILDER.json
n8n/workflows/FAMILYOS_04_FOLLOW_UP.json
n8n/workflows/FAMILYOS_90_ERROR_HANDLER.json
```

## Environment Variables

Configure values based on:

```text
.env.example
```

Required for the first Telegram tests:

```text
TELEGRAM_ALLOWED_USER_IDS
TELEGRAM_ALLOWED_CHAT_IDS
```

Required later:

```text
NOTION_MEETINGS_DATABASE_ID
NOTION_TOPICS_DATABASE_ID
NOTION_SOURCES_DATABASE_ID
NOTION_DECISIONS_DATABASE_ID
NOTION_FEEDBACK_DATABASE_ID
GOOGLE_CALENDAR_ID
WEB_SEARCH_PROVIDER
LLM_PROVIDER
LLM_MODEL
```

## Credentials To Configure In n8n

- Telegram Bot API
- Notion
- Google Calendar
- LLM provider
- Web Search provider
- PostgreSQL connection to database `familyos`

## First Test

Start with:

```text
FAMILYOS_05_TELEGRAM_ROUTER
```

Test the webhook with a sample Telegram update before connecting the real Telegram webhook.

Expected routes:

- `/start` -> `start`
- `/help` -> `help`
- `/choose` -> `choose`
- `/idea Some idea` -> `idea`
- `/status` -> `status`

## Notes

The current workflows are skeletons. Some nodes return JSON instead of sending real Telegram messages or writing to Notion/Calendar. This is intentional for safe import and step-by-step testing.
