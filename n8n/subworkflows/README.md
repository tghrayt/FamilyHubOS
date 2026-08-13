# FamilyOS - n8n Subworkflows

This folder contains reusable n8n workflow exports.

## Current subworkflows

- `FAMILYOS_LIB_01_CONTEXT_BUILDER.json`: builds the family context and calculates child age dynamically from birth date.
- `FAMILYOS_LIB_02_WEB_SEARCH.json`: normalizes web search requests and acts as the future provider boundary.
- `FAMILYOS_LIB_03_SOURCE_VALIDATOR.json`: scores and filters source candidates.
- `FAMILYOS_LIB_04_NOTION.json`: prepares Notion operations without embedding credentials.
- `FAMILYOS_LIB_05_CALENDAR.json`: prepares Google Calendar operations without embedding credentials.
- `FAMILYOS_LIB_06_NOTIFICATION.json`: prepares Telegram/admin notifications without embedding credentials.

## Rule

Subworkflows should own repeated infrastructure/application logic so the main workflows stay readable.

