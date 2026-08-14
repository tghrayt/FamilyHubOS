# FamilyHubOS

FamilyHubOS is a semi-automatic, human-in-the-loop family meeting system.

The goal is to help prepare a weekly family ritual around child development, health, culture, science, reading, music, nature and parenting.

## Workflow

The n8n interface should stay simple. The project uses one workflow:

```text
FAMILYHUBOS-WORKFLOW
```

The flow is:

```text
Telegram
  -> choose automatic/category/topic
  -> research
  -> source validation
  -> meeting builder
  -> Notion page
  -> Google Calendar event
  -> Telegram confirmation
```

## Target Infrastructure

FamilyOS uses the existing DevOps lab VM:

- k3s
- Traefik
- cert-manager / Let's Encrypt
- namespace `automation`
- existing n8n instance
- existing `n8n-postgres`
- dedicated PostgreSQL database `familyos`

Do not deploy a second n8n instance and do not create a second PostgreSQL pod.

## Repository Structure

```text
config/                 Business configuration examples
docs/                   Architecture and setup documentation
infrastructure/k8s/     k3s notes and PostgreSQL example schema
n8n/workflows/          Main n8n workflow exports
schemas/                JSON contracts between workflows
tests/scenarios/        Manual test scenarios
```

## n8n Naming

Use only:

```text
FAMILYHUBOS-WORKFLOW
```

See `docs/n8n-naming.md`.

## Setup Order

1. Review `IMPLEMENTATION_PLAN.md`.
2. Create Notion databases from `docs/notion-schema.md`.
3. Create the PostgreSQL database `familyos` on `n8n-postgres`.
4. Review and apply `infrastructure/k8s/familyos-postgres-init.example.sql`.
5. Configure n8n environment variables from `.env.example`.
6. Configure credentials inside n8n.
7. Sync/import `FAMILYHUBOS-WORKFLOW`.
8. Delete old split workflows from the n8n UI if they were imported before.
9. Test with `tests/scenarios/mvp.md`.

## GitHub Actions

The repository includes:

- `.github/workflows/ci.yml`: validates JSON, n8n workflow connections, required files and obvious secret leaks on push/PR.
- `.github/workflows/sync-n8n.yml`: manual n8n API sync. It runs in dry-run mode by default, then can create/update workflows when `dry_run=false`.

Start with dry-run sync. The workflow does not activate n8n workflows automatically.

## Secrets

No secret belongs in this repository.

Use:

- n8n credentials
- Kubernetes secrets
- environment variables

## Current Status

The repository currently contains one importable workflow skeleton and contracts. It is ready for review/import, but the external integrations still need to be configured in n8n.
