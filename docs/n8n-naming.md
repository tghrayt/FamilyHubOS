# FamilyOS - n8n Naming

## Goal

Keep the n8n interface readable.

## Naming Convention

Main MVP workflows:

```text
FAMILYOS_MAIN_00_TELEGRAM_ROUTER
FAMILYOS_MAIN_01_WEEKLY_PLANNER
FAMILYOS_MAIN_02_RESEARCH
FAMILYOS_MAIN_03_MEETING_BUILDER
FAMILYOS_MAIN_90_ERROR_HANDLER
```

Phase 2 workflows:

```text
FAMILYOS_PHASE2_04_FOLLOW_UP
```

Reusable internal workflows:

```text
FAMILYOS_LIB_01_CONTEXT_BUILDER
FAMILYOS_LIB_02_WEB_SEARCH
FAMILYOS_LIB_03_SOURCE_VALIDATOR
FAMILYOS_LIB_04_NOTION
FAMILYOS_LIB_05_CALENDAR
FAMILYOS_LIB_06_NOTIFICATION
```

## How To Read The List

- `MAIN` means parent-facing or orchestration workflows.
- `LIB` means internal reusable workflows.
- `PHASE2` means intentionally not part of the MVP.
- Numeric prefixes define the order.

## Existing Old Names

If n8n already contains workflows with the previous names, delete them manually after the new names have synced:

```text
FAMILYOS_01_WEEKLY_PLANNER
FAMILYOS_02_RESEARCH
FAMILYOS_03_MEETING_BUILDER
FAMILYOS_04_FOLLOW_UP
FAMILYOS_05_TELEGRAM_ROUTER
FAMILYOS_90_ERROR_HANDLER
SUB_CONTEXT_BUILDER
SUB_WEB_SEARCH
SUB_SOURCE_VALIDATOR
SUB_NOTION
SUB_CALENDAR
SUB_NOTIFICATION
```

The GitHub sync updates workflows by name. It cannot know that these old names should be renamed.

