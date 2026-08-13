# FamilyOS - GitHub Actions

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

- `dry_run = true`: lists workflow files only
- `dry_run = false`: fails intentionally

This prevents accidental overwrite or duplication of workflows in the live n8n instance.

## Future Real Sync

When manual import is stable, choose one sync method:

- n8n API import using `N8N_URL` and `N8N_API_KEY`
- SSH to VM and import through the n8n pod

Required GitHub secrets later:

```text
VM_HOST
VM_USER
VM_SSH_KEY
VM_SSH_PORT
N8N_URL
N8N_API_KEY
```

Do not add these values to repository files.

