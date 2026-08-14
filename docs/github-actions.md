# FamilyHubOS - GitHub Actions

## CI

`.github/workflows/ci.yml` runs on:

- push to `main`
- pull request to `main`
- manual dispatch

It validates:

- all JSON files can be parsed
- n8n workflow connections point to existing nodes
- required project files exist
- no obvious secrets were committed

## n8n Sync

`.github/workflows/sync-n8n.yml` is intentionally manual.

Current behavior:

- `dry_run = true`: validates and prints the sync plan only
- `dry_run = false`: creates or updates `FAMILYHUBOS-WORKFLOW` through the n8n public API

The sync matches the workflow by name. Existing workflow is updated, missing workflow is created.

The sync does not activate the workflow automatically.

## Required GitHub Secrets

Required repository secrets:

```text
N8N_URL
N8N_API_KEY
```

`N8N_URL` must be the base URL of the n8n instance, without a trailing slash.

Example:

```text
https://n8n.example.com
```

`N8N_API_KEY` is sent as the `X-N8N-API-KEY` header.

## Recommended First Run

Run the workflow manually with:

```text
dry_run = true
```

If the plan shows only `FAMILYHUBOS-WORKFLOW`, run again with:

```text
dry_run = false
```

Then check n8n UI before activating the workflow.
