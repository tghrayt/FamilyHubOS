# FAMILYOS_MAIN_03_MEETING_BUILDER

## Purpose

Build the Notion page payload, Google Calendar event payload and Telegram confirmation.

## Current Skeleton

The skeleton:

- accepts research output
- builds meeting metadata
- prepares Notion blocks
- prepares Calendar event content
- prepares Telegram confirmation text
- calls `FAMILYOS_LIB_04_NOTION`, `FAMILYOS_LIB_05_CALENDAR` and `FAMILYOS_LIB_06_NOTIFICATION`

## Next Implementation

- Create/update the Notion page.
- Create/update the Calendar event idempotently.
- Send Telegram confirmation.
- Store idempotency keys in PostgreSQL database `familyos`.


