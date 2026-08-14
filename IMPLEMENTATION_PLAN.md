# FamilyHubOS - Implementation Plan

## Current State

Date d'inspection : 2026-08-14

FamilyHubOS utilise l'infrastructure existante du labo DevOps :

- VM Ubuntu `51.210.40.78`
- k3s
- Traefik
- cert-manager avec Let's Encrypt
- namespace `automation`
- instance n8n existante
- service PostgreSQL existant `n8n-postgres`

Le repository contient maintenant un seul export n8n :

```text
n8n/workflows/FAMILYHUBOS-WORKFLOW.json
```

## Target Architecture

FamilyHubOS doit rester simple :

- `n8n` orchestre le flux.
- `Telegram` sert d'interface parent.
- `Notion` garde la mémoire métier.
- `Google Calendar` planifie les réunions.
- `PostgreSQL` garde uniquement l'état technique.
- `Web Search` et `LLM` seront branchés après stabilisation du workflow.

## Chosen Direction

On garde un seul workflow n8n tant que c'est lisible :

```text
FAMILYHUBOS-WORKFLOW
```

Les anciens sous-workflows ont été retirés du projet parce qu'ils rendaient l'interface n8n trop bruyante. Si la logique devient réellement difficile à maintenir plus tard, on séparera une partie précise, pas toute l'architecture par défaut.

## Repository Tree

```text
FamilyHubOS/
  IMPLEMENTATION_PLAN.md
  README.md
  .env.example
  .github/workflows/
    ci.yml
    sync-n8n.yml
  config/
    familyos.config.example.json
  docs/
    architecture.md
    github-actions.md
    import-n8n.md
    n8n-naming.md
    notion-schema.md
    security.md
    setup.md
    telegram.md
    workflows.md
    workflows/familyhubos-workflow.md
  infrastructure/k8s/
    README.md
    familyos-postgres-init.example.sql
  n8n/
    README.md
    workflows/FAMILYHUBOS-WORKFLOW.json
  schemas/
    family-context.schema.json
    meeting-builder.schema.json
    research-output.schema.json
    source-validation.schema.json
    telegram-interaction.schema.json
  tests/scenarios/
    mvp.md
```

## First Functional Scope

The first working path covers:

1. Manual n8n test trigger.
2. Telegram webhook shell.
3. Telegram user/chat allowlist.
4. Family context builder with child age calculation.
5. Command parsing for `/start`, `/help`, `/status`, `/choose`, `/idea`.
6. Research placeholder.
7. Source validation placeholder.
8. Meeting payload placeholder.
9. Visible `TEST_SUCCESS` / `TEST_FAILED` status in n8n.

## Next Iterations

### Step 1 - Stabilize Single Workflow

- Sync `FAMILYHUBOS-WORKFLOW` through GitHub Actions.
- Run the manual trigger in n8n.
- Delete old `FAMILYOS_*` and `SUB_*` workflows from the n8n UI.

### Step 2 - Telegram Real Output

- Connect Telegram `sendMessage`.
- Test `/status`, `/help`, `/choose`, `/idea`.
- Keep allowlists mandatory.

### Step 3 - Notion Write

- Connect Notion credentials.
- Create/update one meeting page.
- Add idempotency before retry logic.

### Step 4 - Calendar Write

- Connect Google Calendar credentials.
- Create/update one event.
- Store the event id for retries.

### Step 5 - Research And LLM

- Pick the web search provider.
- Validate sources before summarizing.
- Return structured JSON matching the repository schemas.

### Step 6 - PostgreSQL Technical Logging

- Create database `familyos` on existing `n8n-postgres`.
- Apply the example SQL only after VM inspection.
- Log executions, errors and idempotency keys.

## Open Decisions

- Web search provider for V1.
- LLM provider and initial model.
- Exact weekly meeting schedule.
- Final Notion database IDs.
- Google Calendar target.
- Backup strategy for database `familyos`.
