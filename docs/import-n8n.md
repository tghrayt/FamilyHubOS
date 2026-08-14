# FamilyHubOS - n8n Import Guide

## Goal

Import or update only one workflow in the existing n8n instance deployed in the Kubernetes namespace `automation`.

```text
FAMILYHUBOS-WORKFLOW
```

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

Run it first with:

```text
dry_run = true
```

Then run it with:

```text
dry_run = false
```

The sync creates or updates `FAMILYHUBOS-WORKFLOW` by name. It does not activate the workflow automatically.

## Old Workflows To Delete Once

The n8n API sync updates by name; it does not delete old workflows that were imported during earlier experiments.

After `FAMILYHUBOS-WORKFLOW` exists in n8n, manually delete old split workflows such as:

```text
FAMILYOS_*
SUB_*
```

Keep only `FAMILYHUBOS-WORKFLOW`.

## Environment Variables

Configure values based on:

```text
.env.example
```

Required for the first Telegram sendMessage test:

```text
TELEGRAM_BOT_TOKEN
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

For the Notion HTTP node, select the n8n credential created from the Notion internal integration token if n8n does not bind it automatically after sync.

## First Test

Open `FAMILYHUBOS-WORKFLOW` in n8n and run `Manual Test Trigger`.

Expected output:

```text
TEST_SUCCESS
```

The test currently validates the internal path with a hard-coded child birth date. Real Telegram, Notion, Calendar, search and LLM nodes will be connected after this workflow shell is stable.

## First Telegram Test

After setting `TELEGRAM_BOT_TOKEN` on the n8n deployment:

1. Sync `FAMILYHUBOS-WORKFLOW`.
2. Activate the workflow in n8n.
3. Configure Telegram `setWebhook` to:

```text
https://<N8N_HOST>/webhook/familyhubos/telegram
```

4. Send `/status` from the allowed chat.

Expected Telegram response:

```text
FamilyHubOS fonctionne. Age calcule: ...
```
