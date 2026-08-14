# FamilyHubOS Test Scenarios

## 1. Manual Workflow Test

Given `FAMILYHUBOS-WORKFLOW`,
when `Manual Test Trigger` runs,
then the final output status is:

```text
TEST_SUCCESS
```

Expected context:

```text
birthDate = 2025-12-01
now = 2026-08-14T12:00:00.000Z
ageLabel = 8 mois
ageMonths = 8
```

## 2. Telegram Authorization

Given an allowed Telegram user and allowed chat,
when `/status` is sent,
then the workflow returns route `status`.

Given a non-allowed Telegram user,
when `/status` is sent,
then the workflow returns only `{ "ok": true }` and no FamilyHubOS details.

## 3. Telegram Commands

Given an allowed user,
when `/start` is sent,
then the workflow returns route `start`.

Given an allowed user,
when `/help` is sent,
then the workflow returns route `help`.

Given an allowed user,
when `/choose` is sent,
then the workflow returns route `choose` and sends inline category buttons.

Given an allowed user,
when the `Sciences` category button is clicked,
then the workflow returns route `callback` and confirms `Sciences`.

Given an allowed user,
when `/idea Comment transmettre plusieurs langues à notre enfant ?` is sent,
then the workflow returns route `idea` and extracts the idea text.

Given an allowed user,
when `/unknown` is sent,
then the workflow returns route `unknown`.

## 4. Source Validation Target

Given a source from a trusted institution,
when source validation runs,
then it receives a positive official/health authority score.

Given a source with no date and no author,
when source validation runs,
then it receives negative scoring signals.

Given no accepted source,
when research output is built,
then it clearly states that the information is not confirmed by sufficiently reliable sources.

## 5. Meeting Builder Target

Given a valid research output,
when meeting builder runs,
then it creates:

- meeting payload
- Notion payload
- Calendar payload
- Telegram confirmation payload

## Current Limitation

The current workflow is importable and testable, but live Telegram sending, Notion, Calendar, web search and LLM nodes are still placeholders.
