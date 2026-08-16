# FamilyHubOS - Google Calendar Setup

## Goal

Enable `FAMILYHUBOS-WORKFLOW` to create one Google Calendar event after a meeting topic is validated and the Notion meeting page exists.

The workflow already prepares a `calendarPayload` with:

- event title
- event description
- start and end dates
- timezone `Europe/Paris`
- Notion page URL when available

The workflow now creates the event through the native n8n Google Calendar node after OAuth is configured in n8n.

## n8n Credential

Create one credential in n8n:

```text
Google Calendar OAuth2 - FamilyHubOS
```

Use OAuth2, not a service account. According to n8n's Google credentials documentation, Google Calendar supports OAuth2, while service account support is not available for Google Calendar nodes.

For this self-hosted n8n instance, use Custom OAuth2. Managed OAuth2 is for n8n Cloud.

## Google Cloud Console

1. Open Google Cloud Console.
2. Create or select a project, for example:

```text
FamilyHubOS
```

3. Enable this API:

```text
Google Calendar API
```

4. Configure the OAuth consent screen.
5. Audience can be `External` if this is a personal Google account.
6. Add your Google account as a test user if Google keeps the app in testing mode.
7. Create credentials:

```text
OAuth client ID
Application type: Web application
Name: FamilyHubOS n8n
```

8. In n8n, open the Google Calendar credential and copy its OAuth Redirect URL.
9. Paste that URL in Google Cloud Console under:

```text
Authorized redirect URIs
```

For this VM, it should look close to:

```text
https://n8n.51-210-40-78.sslip.io/rest/oauth2-credential/callback
```

Use the exact URL shown by n8n if it differs.

10. Copy the Google Client ID and Client Secret into the n8n credential.
11. Click `Sign in with Google` in n8n and authorize the account.
12. Save the credential.

## Calendar ID

Choose where events should be created.

For the main calendar, Google usually accepts:

```text
primary
```

For a shared family calendar, use the calendar's real Calendar ID from Google Calendar settings.

The workflow currently uses:

```text
GOOGLE_CALENDAR_ID=primary
```

A later change can move this to a shared family calendar ID.

## Safety

Do not commit Client ID, Client Secret, OAuth tokens or refresh tokens to Git.

The repository only stores workflow structure and documentation. Secrets stay inside n8n credentials or GitHub Actions secrets.

## Current Workflow Path

```text
14 Prepare Notion Confirmation
  -> 15 Build Google Calendar Event Payload
  -> 16 Create Google Calendar Event
  -> 17 Prepare Calendar Confirmation
  -> Telegram confirmation
```

The native Google Calendar node creates events in the main calendar for now (`primary`). A later improvement should add full idempotency using a stable event key derived from topic, category and meeting date.
