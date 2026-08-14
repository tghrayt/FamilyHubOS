# FamilyHubOS - n8n Naming

## Goal

Keep the n8n interface readable.

## Naming Convention

Use one workflow name:

```text
FAMILYHUBOS-WORKFLOW
```

Avoid extra prefixes such as `MVP`, numeric ordering, `LIB`, `SUB`, `MAIN`, or `TEST` in n8n workflow names.

## Why

FamilyHubOS is still early. A single workflow is easier to inspect, execute and debug in the n8n UI.

If the workflow becomes too large later, split only when there is a concrete maintenance problem.

## Existing Old Names

If n8n already contains old workflows, delete them manually after `FAMILYHUBOS-WORKFLOW` has synced:

```text
FAMILYOS_*
SUB_*
```

The GitHub sync updates workflows by name. It cannot know that old names should be removed.
