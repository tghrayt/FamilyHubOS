# FamilyHubOS - Architecture

## Current Infrastructure

FamilyHubOS integrates with the existing DevOps lab instead of deploying duplicate infrastructure:

- Ubuntu VM `51.210.40.78`
- k3s
- Traefik in `kube-system`
- cert-manager with Let's Encrypt
- namespace `automation`
- existing n8n instance
- existing `n8n-postgres`

## Principles

- Build one working path before splitting anything.
- Keep the parent in the loop for important choices.
- Never present important medical, educational or developmental information without reliable sources.
- Never store secrets in Git.
- Let Notion own business memory and PostgreSQL own technical state.
- Keep providers replaceable: LLM, web search, calendar and notifications.

## Target Diagram

```mermaid
flowchart TD
    Parent["Parent"] --> Telegram["Telegram Bot"]
    Telegram --> Workflow["FAMILYHUBOS-WORKFLOW"]
    Manual["Manual Test Trigger"] --> Workflow

    subgraph K3S["VM k3s"]
      subgraph Automation["namespace automation"]
        N8N["existing n8n"]
        FamilyDb["n8n-postgres / database familyos"]
      end
      Traefik["Traefik"]
      CertManager["cert-manager"]
    end

    Traefik --> N8N
    CertManager --> Traefik
    N8N --> Workflow
    Workflow --> FamilyDb
    Workflow --> Notion["Notion"]
    Workflow --> Calendar["Google Calendar"]
    Workflow --> Search["Web Search Provider"]
    Workflow --> LLM["LLM Provider"]
    Workflow --> Telegram
```

## Domain Boundaries

Domain:

- Topic
- Meeting
- Source
- Decision
- Feedback

Application:

- Plan meeting
- Research topic
- Create meeting
- Review decision

Infrastructure:

- Telegram
- Notion
- Google Calendar
- Web Search
- LLM
- PostgreSQL

## Data Ownership

Notion owns:

- Meetings
- Topics
- Sources
- Decisions
- Feedbacks
- Human notes

PostgreSQL owns:

- Workflow runs
- Workflow errors
- Conversation states
- Idempotency keys
- Research cache

Google Calendar owns:

- Meeting event scheduling
- Preparation reminders when enabled

Telegram owns no durable business data. It is only an interaction channel.

## First Flow

```mermaid
sequenceDiagram
    participant Parent as Parent
    participant TG as Telegram
    participant N8N as n8n
    participant Notion as Notion
    participant Cal as Google Calendar

    Parent->>TG: Command or choice
    TG->>N8N: Webhook
    N8N->>N8N: Allowlist
    N8N->>N8N: Build family context
    N8N->>N8N: Parse command
    N8N->>N8N: Build meeting payload
    N8N->>Notion: Create/update page later
    N8N->>Cal: Create/update event later
    N8N->>TG: Confirm later
```

## Risks

- n8n can become hard to maintain if too much logic accumulates.
- Search results can be weak or SEO-heavy.
- Retries can create duplicates without idempotency.
- Telegram bots can expose functionality without allowlists.
- Sharing `n8n-postgres` couples FamilyHubOS to automation infrastructure.

## Mitigations

- Keep one workflow while it is understandable, then split only specific painful sections.
- Validate sources explicitly.
- Use stable IDs for meetings, events, notifications and callbacks.
- Reject unauthorized Telegram users and chats before any action.
- Use a dedicated `familyos` database and avoid n8n internal tables.
