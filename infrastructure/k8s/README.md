# FamilyOS - k3s Infrastructure Notes

## Current Target

FamilyOS uses the existing VM infrastructure:

- k3s on Ubuntu `51.210.40.78`.
- Existing namespace `automation`.
- Existing n8n deployment.
- Existing PostgreSQL service `n8n-postgres`.
- Existing Traefik Ingress and Let's Encrypt certificate for n8n.

For the MVP, do not deploy a second n8n instance and do not create a new PostgreSQL pod.

## Database Strategy

Create a dedicated PostgreSQL database named `familyos` inside the existing `n8n-postgres` instance.

This keeps FamilyOS technical tables separate from n8n internal tables while avoiding extra infrastructure for the MVP.

## Before Applying Anything

Inspect the VM first:

```bash
sudo k3s kubectl -n automation get pods,svc,ingress,certificate,secrets
sudo k3s kubectl -n automation get pvc
sudo k3s kubectl -n automation logs deployment/n8n --tail=100
```

Confirm PostgreSQL access method:

```bash
sudo k3s kubectl -n automation get pods -l app=n8n-postgres
sudo k3s kubectl -n automation get svc n8n-postgres
```

Confirm backup coverage before storing important state in `familyos`.

## SQL

`familyos-postgres-init.example.sql` is an example schema. It should be reviewed and adapted before execution.

Never commit real database passwords or credentials.

