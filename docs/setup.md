# FamilyOS - Setup

## Current Setup Status

No setup files exist yet in the repository.

## Prerequisites

Expected for the MVP :

- Existing k3s VM.
- Existing Traefik and cert-manager.
- Existing n8n in namespace `automation`.
- Existing PostgreSQL service `n8n-postgres`.
- Dedicated PostgreSQL database `familyos` on `n8n-postgres`.
- Telegram bot token.
- Notion integration token.
- Google Calendar credentials.
- LLM API key.
- Web Search API key.

## Configuration

Secrets must be configured through :

- n8n credentials.
- Environment variables.
- Local `.env` files excluded from Git.

The repository provides `.env.example` as a non-secret checklist. Real values must be configured in the deployed n8n environment or credentials.

`.env.example` variables :

```text
TZ=Europe/Paris
N8N_HOST=
N8N_PROTOCOL=https
POSTGRES_DB=familyos
POSTGRES_USER=familyos
POSTGRES_PASSWORD=
POSTGRES_HOST=n8n-postgres
POSTGRES_PORT=5432
TELEGRAM_ALLOWED_USER_IDS=
TELEGRAM_ALLOWED_CHAT_IDS=
NOTION_MEETINGS_DATABASE_ID=
NOTION_TOPICS_DATABASE_ID=
NOTION_SOURCES_DATABASE_ID=
NOTION_DECISIONS_DATABASE_ID=
GOOGLE_CALENDAR_ID=
LLM_PROVIDER=
LLM_MODEL=
WEB_SEARCH_PROVIDER=
SOURCE_SCORE_THRESHOLD=5
```

Business configuration is documented in `config/familyos.config.example.json`. It contains no secrets and defines defaults for meeting scheduling, source scoring, research limits, Telegram behavior and idempotency prefixes.

## Technical Database

FamilyOS uses a dedicated PostgreSQL database named `familyos` on the existing `n8n-postgres` instance.

The example schema is available at:

```text
infrastructure/k8s/familyos-postgres-init.example.sql
```

It must be reviewed before execution. It is not applied automatically.

## Business Configuration

Future configurable fields :

- timezone
- meetingDay
- meetingTime
- preparationReminder
- feedbackDelay
- allowedCategories
- sourceScoreThreshold
- numberOfSources
- maximumReadingTime
- language

Initial defaults :

- timezone : `Europe/Paris`
- language : `français`
- source languages : `français`, `anglais`

## Deployment Note

Do not modify the existing VM, Traefik, n8n instance or `n8n-postgres` database until they have been inspected.

For the MVP, do not deploy a second n8n instance and do not create a new PostgreSQL pod. Use the existing `automation` namespace and add only the minimum required database/configuration after backup and inspection.
