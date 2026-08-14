# FamilyHubOS - n8n Workflow

## Strategy

FamilyHubOS uses one n8n workflow:

```text
FAMILYHUBOS-WORKFLOW
```

The workflow is intentionally simple to read in the n8n UI. It contains the full early path in one place.

## Current Sections

Inside the workflow:

1. `Manual Test Trigger`
2. `Telegram Webhook`
3. Security allowlist
4. Family context builder
5. Command and choice parsing
6. `/choose` category buttons
7. Topic suggestion buttons
8. Research placeholder
9. Source validation placeholder
10. Meeting builder placeholder
11. Telegram `sendMessage` for webhook runs
12. Manual test output or webhook response

## Manual Test

The manual test path uses a hard-coded child birth date:

```text
2025-12-01
```

Expected result:

```text
TEST_SUCCESS
```

This proves the workflow imports, executes, builds context and returns a visible status in n8n.

## Next Real Integrations

After the Telegram `/status` path is stable, connect these pieces one by one:

- Notion page creation
- Google Calendar event creation
- Web search provider
- LLM structured summary
- PostgreSQL technical logging

## Idempotency

Stable keys will be used before real writes:

- `meetingId`
- `workflowRunId`
- `calendarEventId`
- `telegramInteractionId`
- `notionPageId`

Retries must not create duplicate Notion pages, Calendar events or Telegram notifications.
