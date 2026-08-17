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
8. Draft meeting preview after topic selection
9. Draft approval or back-to-categories buttons
10. Notion `Topics` page creation from `/idea`
11. Notion duplicate check by topic, category and date
12. Notion `Meetings` page creation after approval
13. Google Calendar event creation after Notion meeting creation
14. Source candidate builder
15. Source candidate validation
16. Meeting builder placeholder
17. Telegram `sendMessage` for webhook runs
18. Manual test output or webhook response

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

After the Telegram, Notion and Google Calendar paths are stable, connect these pieces one by one:

- Web search provider
- LLM structured summary
- PostgreSQL technical logging

The current workflow already adds source candidates to the Notion meeting page. They are selected from a small curated catalog and clearly marked as candidates, not as fetched or verified research.

## Idempotency

Stable keys will be used before real writes:

- `selectedCategory`
- `selectedTopic`
- meeting date
- later: `meetingId`, `workflowRunId`, `calendarEventId`, `telegramInteractionId`, `notionPageId`

Retries must not create duplicate Notion pages, Calendar events or Telegram notifications.
