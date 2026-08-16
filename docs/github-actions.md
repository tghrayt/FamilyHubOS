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

`.github/workflows/sync-n8n.yml` runs automatically on push to `main` when these files change:

- `n8n/workflows/**`
- `.github/workflows/sync-n8n.yml`

Current behavior:

- validates n8n JSON
- creates or updates `FAMILYHUBOS-WORKFLOW` through the n8n public API

The sync matches the workflow by name. Existing workflow is updated, missing workflow is created.

The sync does not activate or publish the workflow automatically in n8n.

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

## Normal Usage

Push to `main`. If the changed files include `n8n/workflows/**`, GitHub Actions syncs `FAMILYHUBOS-WORKFLOW` automatically.

After sync, open n8n and publish the workflow when the UI asks for it.
