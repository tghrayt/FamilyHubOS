# FamilyOS

FamilyOS is a semi-automatic, human-in-the-loop family meeting system.

The goal is to help prepare a weekly family ritual around child development, health, culture, science, reading, music, nature and parenting.

## MVP

The MVP flow is:

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

For the MVP, do not deploy a second n8n instance and do not create a second PostgreSQL pod.

## Repository Structure

```text
config/                 Business configuration examples
docs/                   Architecture and setup documentation
infrastructure/k8s/     k3s notes and PostgreSQL example schema
n8n/workflows/          Main n8n workflow exports
n8n/subworkflows/       Reusable n8n workflow exports
schemas/                JSON contracts between workflows
tests/scenarios/        Manual test scenarios
```

## Setup Order

1. Review `IMPLEMENTATION_PLAN.md`.
2. Create Notion databases from `docs/notion-schema.md`.
3. Create the PostgreSQL database `familyos` on `n8n-postgres`.
4. Review and apply `infrastructure/k8s/familyos-postgres-init.example.sql`.
5. Configure n8n environment variables from `.env.example`.
6. Configure credentials inside n8n.
7. Import subworkflows first.
8. Import main workflows.
9. Test with `tests/scenarios/mvp.md`.

## GitHub Actions

The repository includes:

- `.github/workflows/ci.yml`: validates JSON, n8n workflow connections, required files and obvious secret leaks on push/PR.
- `.github/workflows/sync-n8n.yml`: manual placeholder for future n8n sync. It runs in dry-run mode by default and does not import anything yet.

Start with CI only. Enable real n8n sync after the workflows have been imported and tested manually.

## Secrets

No secret belongs in this repository.

Use:

- n8n credentials
- Kubernetes secrets
- environment variables

## Current Status

The repository currently contains skeletons and contracts. They are ready for review/import, but the external integrations still need to be configured in n8n.
