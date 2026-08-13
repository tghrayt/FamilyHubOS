# FamilyOS - n8n Workflows

## Workflow Strategy

Prefer several small workflows over one monolithic workflow. For V1, create only the workflows required for the end-to-end MVP.

## FAMILYOS_01_WEEKLY_PLANNER

Purpose : start weekly planning and collect parent choice.

Trigger :

- Configurable schedule.
- Manual trigger for testing.
- Telegram callback from router.

Main steps :

1. Load family context.
2. Load child context.
3. Load recent meetings.
4. Load topic backlog.
5. Determine allowed categories.
6. Send Telegram proposal.
7. Wait for parent choice.
8. Resolve selected category/topic/mode.
9. Launch research workflow.

Skeleton export :

```text
n8n/workflows/FAMILYOS_01_WEEKLY_PLANNER.json
```

Detailed spec :

```text
docs/workflows/weekly-planner.md
```

Modes :

- Automatic category and topic.
- Forced category.
- Forced topic.

## FAMILYOS_02_RESEARCH

Input :

```json
{
  "topic": "",
  "category": "",
  "childContext": {},
  "familyContext": {}
}
```

Purpose : find, normalize and validate sources, then produce structured research output.

Skeleton export :

```text
n8n/workflows/FAMILYOS_02_RESEARCH.json
```

Detailed spec :

```text
docs/workflows/research.md
```

Rules :

- Use source validation before final summary.
- Link important claims to sources.
- Return strict JSON.
- Explicitly state when information cannot be confirmed.

## FAMILYOS_03_MEETING_BUILDER

Purpose : convert research output into a Notion-ready meeting page and Calendar-ready event payload.

Skeleton export :

```text
n8n/workflows/FAMILYOS_03_MEETING_BUILDER.json
```

Detailed spec :

```text
docs/workflows/meeting-builder.md
```

Output includes :

- Topic.
- Category.
- Date.
- Child age.
- Why now.
- Summary.
- Key points.
- Reading list.
- Discussion questions.
- Practical ideas.
- Notes section.
- Decisions section.
- Review section.
- Sources section.

## FAMILYOS_04_FOLLOW_UP

Purpose : phase 2 workflow for decisions with `ReviewAt`.

Not part of the MVP.

## FAMILYOS_05_TELEGRAM_ROUTER

Purpose : receive Telegram commands and callbacks, enforce authorization, and route to the right workflow.

Commands :

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

MVP commands :

- `/start`
- `/help`
- `/choose`
- `/idea`
- `/status`

Skeleton export :

```text
n8n/workflows/FAMILYOS_05_TELEGRAM_ROUTER.json
```

Detailed spec :

```text
docs/workflows/telegram-router.md
```

## FAMILYOS_90_ERROR_HANDLER

Purpose : centralize error logging, retry decisions and admin notification.

Logs :

- timestamp
- workflowName
- executionId
- meetingId
- step
- status
- errorCode
- errorMessage
- duration

Never log :

- tokens
- passwords
- credentials
- unnecessary sensitive data

## Recommended Sub-Workflows

- `SUB_CONTEXT_BUILDER`
- `SUB_WEB_SEARCH`
- `SUB_SOURCE_VALIDATOR`
- `SUB_NOTION`
- `SUB_CALENDAR`
- `SUB_NOTIFICATION`

For V1, create only the sub-workflows that reduce duplication immediately.

### SUB_CONTEXT_BUILDER

Skeleton export :

```text
n8n/subworkflows/SUB_CONTEXT_BUILDER.json
```

Detailed spec :

```text
docs/workflows/context-builder.md
```

Purpose : build the standard family context and calculate child age dynamically from birth date.

## Idempotency

Stable keys :

- `meetingId`
- `workflowRunId`
- `calendarEventId`
- `telegramInteractionId`
- `notionPageId`

Retries must not create duplicate Notion pages, Calendar events or Telegram notifications.
