# FamilyOS - Decisions

This file records architecture decisions for the project.

## ADR-001 - Start With n8n-First MVP

Status : Accepted

Decision :

Use n8n as the primary orchestrator for the MVP, with small workflows and reusable sub-workflows.

Context :

The goal is to validate a weekly family ritual with Telegram, research, Notion and Calendar before adding custom services.

Consequences :

- Faster MVP.
- Less code to deploy.
- Business logic must be kept disciplined to avoid scattered workflow logic.

## ADR-002 - Notion Owns Business Memory

Status : Accepted

Decision :

Store meetings, topics, sources, decisions and feedback in Notion.

Context :

Notion is the human-facing memory and interface.

Consequences :

- Parents can inspect and edit data easily.
- Technical logs must stay outside Notion.

## ADR-003 - PostgreSQL Owns Technical State

Status : Accepted

Decision :

Use PostgreSQL for workflow runs, errors, idempotency, cache and conversation state.

Context :

Retries and Telegram interactions require reliable technical state.

Consequences :

- Avoids polluting Notion.
- Requires a small schema later in the MVP.

## ADR-005 - Reuse Existing n8n and n8n-postgres

Status : Accepted

Decision :

Use the existing n8n instance in the Kubernetes namespace `automation` and the existing PostgreSQL instance `n8n-postgres`. Create a dedicated database named `familyos` for FamilyOS technical tables.

Context :

The VM is a DevOps lab running k3s, Traefik, cert-manager and an `automation` namespace that already hosts n8n with PostgreSQL.

Consequences :

- No second n8n deployment for the MVP.
- No new PostgreSQL pod for the MVP.
- FamilyOS technical data is isolated from n8n internals by database.
- Backup coverage for `familyos` must be confirmed before important production use.

## ADR-004 - Source Validation Is Explicit

Status : Accepted

Decision :

Use a dedicated source validation step before meeting generation.

Context :

FamilyOS can touch health, child development and education. Trust must be traceable.

Consequences :

- More reliable outputs.
- Research may fail gracefully when sources are insufficient.
