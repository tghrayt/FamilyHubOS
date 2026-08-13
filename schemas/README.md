# FamilyOS - JSON Schemas

These schemas define the contracts between n8n workflows and sub-workflows.

## Files

- `telegram-interaction.schema.json` validates normalized Telegram messages and callbacks.
- `family-context.schema.json` validates the context passed to planning and research workflows.
- `source-validation.schema.json` validates accepted and rejected source metadata.
- `research-output.schema.json` validates the strict JSON returned by the research workflow.
- `meeting-builder.schema.json` validates the output used to create Notion pages, Calendar events and Telegram confirmations.

## Rule

Workflows should pass structured JSON between steps. Avoid parsing free text with fragile regexes.

If a workflow receives invalid JSON, it should retry or route to `FAMILYOS_MAIN_90_ERROR_HANDLER`.

