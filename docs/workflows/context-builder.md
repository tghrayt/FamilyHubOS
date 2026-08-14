# FAMILYOS_LIB_01_CONTEXT_BUILDER

## Purpose

`FAMILYOS_LIB_01_CONTEXT_BUILDER` builds the standard context passed to FamilyOS planning and research workflows.

It calculates child age dynamically from `birthDate`. Age must not be manually stored as source truth.

## Input

Minimum input:

```json
{
  "config": {
    "family": {
      "child": {
        "birthDate": "2025-12-01"
      },
      "preferences": {
        "sourceLanguages": ["fr", "en"]
      }
    }
  }
}
```

Optional test input with fixed time:

```json
{
  "now": "2026-08-13T12:00:00.000Z",
  "child": {
    "birthDate": "2025-12-01"
  },
  "recentMeetings": [],
  "recentCategories": ["sante", "culture"],
  "topicBacklog": [],
  "preferences": {
    "sourceLanguages": ["fr", "en"]
  }
}
```

## Output

The output follows:

```text
schemas/family-context.schema.json
```

Example:

```json
{
  "child": {
    "birthDate": "2025-12-01",
    "ageMonths": 8,
    "ageYears": 0,
    "ageLabel": "8 mois"
  },
  "recentMeetings": [],
  "recentCategories": ["sante", "culture"],
  "existingTopics": [],
  "openDecisions": [],
  "topicBacklog": [],
  "preferences": {
    "sourceLanguages": ["fr", "en"]
  }
}
```

## MVP Behavior

The skeleton only:

- reads `birthDate`
- calculates `ageMonths`, `ageYears`, `ageLabel`
- passes through recent meetings, categories, topics and preferences when provided
- includes a manual test path with `testOnly = true`

Later, it will load recent meetings and topic backlog from Notion.

## Manual n8n Test

Prefer the dedicated test workflow:

```text
FAMILYOS_TEST_01_CONTEXT_BUILDER
```

It ends on a clearly named node:

```text
TEST_SUCCESS - Context Builder OK
```

or:

```text
TEST_FAILED - Context Builder KO
```

The test injects:

```json
{
  "testOnly": true,
  "now": "2026-08-14T12:00:00.000Z",
  "child": {
    "birthDate": "2025-12-01"
  }
}
```

Expected result:

```json
{
  "testResult": {
    "status": "TEST_SUCCESS",
    "passed": true
  },
  "ageMonths": 8,
  "ageYears": 0,
  "ageLabel": "8 mois"
}
```

The real production path remains `Execute Workflow Trigger -> Build Family Context`.

## Error Cases

Missing birth date:

```text
Missing child birthDate. Provide config.family.child.birthDate or input.child.birthDate.
```

Invalid birth date format:

```text
child birthDate must use YYYY-MM-DD format.
```

## Test Scenarios

Given `birthDate = 2025-12-01` and `now = 2026-08-13T12:00:00.000Z`, output age is `8 mois`.

Given no birth date, the workflow fails explicitly.

Given an invalid birth date format, the workflow fails explicitly.


