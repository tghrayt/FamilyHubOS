# FamilyHubOS - PostgreSQL Technical State

FamilyHubOS stores business knowledge in Notion and technical state in PostgreSQL.

Target:

```text
Kubernetes namespace: automation
Service: n8n-postgres
Database: familyos
```

## Apply Schema

First create or verify the dedicated database and user on the existing PostgreSQL instance. Then apply:

```bash
sudo k3s kubectl -n automation cp infrastructure/k8s/familyos-postgres-init.example.sql <postgres-pod>:/tmp/familyos-postgres-init.sql
sudo k3s kubectl -n automation exec -it <postgres-pod> -- psql -U familyos -d familyos -f /tmp/familyos-postgres-init.sql
```

Replace `<postgres-pod>` with the pod running `n8n-postgres`.

## n8n Credential

Create one PostgreSQL credential in n8n:

```text
Name: PostgreSQL - FamilyHubOS
Host: n8n-postgres
Port: 5432
Database: familyos
User: familyos
Password: configured outside Git
SSL: off, unless your cluster PostgreSQL requires it
```

The workflow writes the sanitized `technicalLog` object into `workflow_runs` through the `18 Log Workflow Run` PostgreSQL node. If the workflow sync does not bind the credential automatically, open this node in n8n and select `PostgreSQL - FamilyHubOS`.

## Logged Fields

The workflow log deliberately stores only operational fields:

- workflow name and n8n execution id
- Telegram interaction/chat/user ids
- route, step, status
- meeting id, category, topic when a meeting or idea exists
- source count
- Notion page URL
- Google Calendar event id/URL
- error code/message when relevant

Do not store tokens, passwords, raw credentials or full Telegram payloads in this database.


## Verify Logs

After publishing the workflow and sending a Telegram command, verify recent rows:

```bash
POSTGRES_POD="n8n-postgres-8449876dcc-mw2wj"
PGUSER="n8n"

sudo k3s kubectl -n automation exec -it "$POSTGRES_POD" -- psql -U "$PGUSER" -d familyos -c "select created_at, route, step, status, topic from workflow_runs order by created_at desc limit 10;"
```
