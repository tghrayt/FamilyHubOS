# FamilyOS - JSON Schemas

These schemas define the structured contracts used inside the n8n workflow.

## Files

- `telegram-interaction.schema.json` validates normalized Telegram messages and callbacks.
- `family-context.schema.json` validates the context passed to planning and research workflows.
- `source-validation.schema.json` validates accepted and rejected source metadata.
- `research-output.schema.json` validates the strict JSON returned by the research workflow.
- `meeting-builder.schema.json` validates the output used to create Notion pages, Calendar events and Telegram confirmations.

## Rule

Workflow steps should pass structured JSON. Avoid parsing free text with fragile regexes.

If a live integration receives invalid JSON, it should retry or route to an explicit error handling section inside `FAMILYHUBOS-WORKFLOW`.

