# FamilyOS MVP Test Scenarios

## 1. Telegram authorization

Given an allowed Telegram user and allowed chat,
when `/status` is sent,
then the router returns route `status`.

Given a non-allowed Telegram user,
when `/status` is sent,
then the router returns only `{ "ok": true }` and no FamilyOS details.

## 2. Telegram commands

Given an allowed user,
when `/start` is sent,
then the router returns route `start`.

Given an allowed user,
when `/help` is sent,
then the router returns route `help`.

Given an allowed user,
when `/choose` is sent,
then the router returns route `choose` and references `FAMILYOS_MAIN_01_WEEKLY_PLANNER`.

Given an allowed user,
when `/idea Comment transmettre plusieurs langues à notre enfant ?` is sent,
then the router returns route `idea` and extracts the idea text.

Given an allowed user,
when `/unknown` is sent,
then the router returns route `unknown`.

## 3. Context builder

Given `birthDate = 2025-12-01` and `now = 2026-08-13T12:00:00.000Z`,
when `FAMILYOS_LIB_01_CONTEXT_BUILDER` runs,
then output child age is `8 mois`, `ageMonths = 8`, `ageYears = 0`.

Given no birth date,
when `FAMILYOS_LIB_01_CONTEXT_BUILDER` runs,
then it fails explicitly.

## 4. Source validation

Given a source from `who.int`,
when `FAMILYOS_LIB_03_SOURCE_VALIDATOR` runs,
then it receives a positive official/health authority score.

Given a source with no date and no author,
when `FAMILYOS_LIB_03_SOURCE_VALIDATOR` runs,
then it receives negative scoring signals.

Given no accepted source,
when `FAMILYOS_MAIN_02_RESEARCH` builds output,
then it includes:

```text
Je ne peux pas confirmer cette information à partir de sources suffisamment fiables.
```

## 5. Meeting builder

Given a valid research output,
when `FAMILYOS_MAIN_03_MEETING_BUILDER` runs,
then it creates:

- meeting payload
- Notion payload
- Calendar payload
- Telegram confirmation payload

## 6. End-to-end target

Given FamilyOS sends a Telegram planning message,
when the parent chooses category `Sciences`,
then FamilyOS proposes 3 topics.

Given the parent selects one topic,
when research completes,
then accepted sources are attached to the meeting.

Given the meeting is ready,
when Notion and Calendar integrations succeed,
then Telegram confirms:

```text
Meeting prêt
Sujet : ...
Date : ...
Temps de lecture : ...
Notion : ...
```

## Current Skeleton Limitation

The repository currently prepares importable skeletons. Full live tests require n8n credentials and real integration nodes configured in the n8n UI.


