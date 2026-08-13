# FamilyOS - Architecture

## Current State

Le repository ne contient pas encore de workflow n8n, de configuration Notion, de configuration Google Calendar ou de schéma PostgreSQL FamilyOS.

La VM cible existe déjà :

- Ubuntu `51.210.40.78`.
- k3s.
- Traefik dans `kube-system`.
- cert-manager avec Let's Encrypt.
- namespace `automation` avec `n8n`, `n8n-postgres`, Ingress Traefik et certificat HTTPS.

FamilyOS doit donc s'intégrer à l'infrastructure existante au lieu de créer un nouveau déploiement n8n.

## Principles

- Construire une V1 simple qui fonctionne de bout en bout.
- Garder l'utilisateur dans la boucle pour les choix importants.
- Ne jamais présenter une information médicale, éducative ou développementale importante sans source fiable.
- Ne jamais stocker de secrets dans Git.
- Éviter la duplication : Notion garde le métier, PostgreSQL garde la technique.
- Préserver la possibilité de remplacer le LLM ou le moteur de recherche.

## Target Diagram

```mermaid
flowchart TD
    Telegram["Telegram Bot"] --> Router["FAMILYOS_MAIN_00_TELEGRAM_ROUTER"]
    Schedule["Schedule Trigger"] --> Planner["FAMILYOS_MAIN_01_WEEKLY_PLANNER"]
    subgraph K3S["VM k3s"]
    subgraph Automation["namespace automation"]
    N8N["n8n existing instance"]
    FamilyDb["n8n-postgres / database familyos"]
    end
    Traefik["Traefik"]
    CertManager["cert-manager"]
    end
    Traefik --> N8N
    CertManager --> Traefik
    N8N --> Router
    N8N --> Planner
    Router --> Planner
    Planner --> Context["FAMILYOS_LIB_01_CONTEXT_BUILDER"]
    Planner --> Research["FAMILYOS_MAIN_02_RESEARCH"]
    Research --> WebSearch["FAMILYOS_LIB_02_WEB_SEARCH"]
    Research --> Validator["FAMILYOS_LIB_03_SOURCE_VALIDATOR"]
    Research --> LLM["LLM Provider"]
    Research --> Builder["FAMILYOS_MAIN_03_MEETING_BUILDER"]
    Builder --> Notion["FAMILYOS_LIB_04_NOTION / Notion"]
    Builder --> Calendar["FAMILYOS_LIB_05_CALENDAR / Google Calendar"]
    Builder --> Notify["FAMILYOS_LIB_06_NOTIFICATION / Telegram"]
    Planner --> FamilyDb
    Research --> FamilyDb
    Builder --> FamilyDb
    Router --> FamilyDb
    Planner --> ErrorHandler["FAMILYOS_MAIN_90_ERROR_HANDLER"]
    Research --> ErrorHandler
    Builder --> ErrorHandler
    ErrorHandler --> FamilyDb
    ErrorHandler --> Telegram
```

## Domain Boundaries

Domain :

- Topic
- Meeting
- Source
- Decision
- Feedback

Application :

- PlanMeeting
- ResearchTopic
- CreateMeeting
- ReviewDecision

Infrastructure :

- Telegram
- Notion
- Google Calendar
- Web Search
- LLM
- PostgreSQL

## Data Ownership

Notion owns :

- Meetings
- Topics
- Sources
- Decisions
- Feedbacks
- Human notes

PostgreSQL owns :

- Workflow runs
- Workflow errors
- Conversation states
- Idempotency keys
- Research cache

For the MVP, these technical tables live in a dedicated PostgreSQL database named `familyos` on the existing `n8n-postgres` instance.

Google Calendar owns :

- Meeting event scheduling
- Preparation reminders when enabled

Telegram owns no durable business data. It is an interaction channel.

## MVP Flow

```mermaid
sequenceDiagram
    participant Parent as Parent
    participant TG as Telegram
    participant N8N as n8n
    participant Search as Web Search
    participant LLM as LLM
    participant Notion as Notion
    participant Cal as Google Calendar

    N8N->>TG: Propose next meeting choices
    Parent->>TG: Choose category, topic, or automatic mode
    TG->>N8N: Command/callback
    N8N->>N8N: Build family and child context
    N8N->>Search: Search reliable sources
    Search-->>N8N: Normalized results
    N8N->>N8N: Validate sources
    N8N->>LLM: Build structured meeting content from accepted sources
    LLM-->>N8N: Strict JSON output
    N8N->>Notion: Create/update meeting page
    N8N->>Cal: Create/update event
    N8N->>TG: Confirm meeting ready
```

## Recommended Technical Choices

- Reuse the existing n8n instance in the Kubernetes namespace `automation`.
- Reuse the existing PostgreSQL instance `n8n-postgres`.
- Create a dedicated database `familyos` for FamilyOS technical tables.
- Notion databases for human-facing data.
- Google Calendar for scheduling.
- Telegram Bot API with private group allowlist.
- JSON schemas for structured LLM outputs.
- Configurable source scoring thresholds.

## Risks

- Source quality can degrade if the search provider returns SEO-heavy results.
- n8n workflows can become hard to maintain if business logic is duplicated.
- Calendar and Notion retries can create duplicates without idempotency.
- Telegram bots can leak functionality if user/chat allowlists are missing.
- Sharing the `n8n-postgres` instance can couple FamilyOS availability to automation infrastructure.

## Mitigations

- Use source tiers and explicit validation.
- Keep reusable logic in sub-workflows.
- Use stable IDs for meetings, events, notifications and callbacks.
- Reject unauthorized Telegram users and chats before any action.
- Isolate FamilyOS tables in the `familyos` database and avoid writing into n8n internal tables.
- Add backup coverage for `familyos` before relying on it for important state.

