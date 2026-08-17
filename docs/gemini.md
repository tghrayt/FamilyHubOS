# FamilyHubOS - Gemini LLM

FamilyHubOS uses the Gemini API free tier path for meeting draft enrichment.

## n8n Credential

Create one n8n credential:

```text
Type: Header Auth
Name: Gemini - FamilyHubOS
Header Name: x-goog-api-key
Header Value: configured outside Git
```

The workflow calls:

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent
```

The request asks for JSON only and includes:

- selected topic
- category
- child age label
- source candidates

The LLM output is treated as a draft. Sources are still marked as candidates and must be verified before important decisions.
