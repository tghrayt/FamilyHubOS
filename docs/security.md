# FamilyOS - Security

## Minimum Rules

- No hardcoded secrets.
- No secrets committed to Git.
- Telegram access restricted by user and chat allowlists.
- PostgreSQL must not be publicly exposed.
- n8n should be served behind HTTPS.
- Use least privilege for Notion and Google credentials.
- Keep backups for n8n and PostgreSQL.

## Telegram Authorization

The `/whoami` command is the only diagnostic allowlist exception. It may run before the chat is authorized so the family group chat ID can be discovered. It must not create Notion pages, Calendar events, database business records or call external AI providers.

Current authorized Telegram group chat ID: `-5543186089`.

Current authorized Telegram parent user IDs: `6869454917`, `8003324252`.

Required configuration :

```text
TELEGRAM_ALLOWED_USER_IDS
TELEGRAM_ALLOWED_CHAT_IDS
```

Authorization must happen before routing commands or callbacks.

## Logging

Allowed technical fields :

- timestamp
- workflowName
- executionId
- meetingId
- step
- status
- errorCode
- errorMessage
- duration

Forbidden in logs :

- tokens
- passwords
- raw credentials
- unnecessary sensitive data

## Source Safety

FamilyOS must never invent :

- references
- studies
- authors
- URLs
- statistics
- scientific consensus

When a claim cannot be confirmed, the generated meeting should say :

```text
Je ne peux pas confirmer cette information à partir de sources suffisamment fiables.
```

## Infrastructure Safety

Before changing infrastructure, inspect :

- current k3s resources in namespace `automation`
- n8n deployment method
- Traefik Ingress configuration
- cert-manager certificate state
- `n8n-postgres` service, database users and backups
- backup strategy
- environment variables

FamilyOS must use a dedicated PostgreSQL database named `familyos` on the existing `n8n-postgres` instance. It must not write into n8n internal tables.
