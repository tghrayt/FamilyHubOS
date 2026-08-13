# FamilyOS - n8n Subworkflows

This folder contains reusable n8n workflow exports.

## Current subworkflows

- `SUB_CONTEXT_BUILDER.json`: builds the family context and calculates child age dynamically from birth date.
- `SUB_WEB_SEARCH.json`: normalizes web search requests and acts as the future provider boundary.
- `SUB_SOURCE_VALIDATOR.json`: scores and filters source candidates.
- `SUB_NOTION.json`: prepares Notion operations without embedding credentials.
- `SUB_CALENDAR.json`: prepares Google Calendar operations without embedding credentials.
- `SUB_NOTIFICATION.json`: prepares Telegram/admin notifications without embedding credentials.

## Rule

Subworkflows should own repeated infrastructure/application logic so the main workflows stay readable.
