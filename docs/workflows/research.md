# FAMILYOS_02_RESEARCH

## Purpose

Research a selected topic, validate sources and produce strict JSON.

## Current Skeleton

The skeleton:

- requires `topic` and `category`
- prepares search queries
- calls `SUB_WEB_SEARCH`
- calls `SUB_SOURCE_VALIDATOR`
- emits a `research-output.schema.json` compatible structure

## Next Implementation

- Configure a real Web Search provider.
- Add LLM summarization constrained by accepted sources.
- Validate output against JSON schema.
- Cache research in PostgreSQL database `familyos`.

