# FamilyHubOS - Source Checks

FamilyHubOS starts with curated source candidates, then performs lightweight URL checks before the Gemini draft step.

The workflow checks up to two accepted source candidates per meeting topic:

- HTTP status
- response content type
- HTML title when available
- checked timestamp

These checks prove that a URL was reachable at execution time. They do not prove that the source content was fully read or scientifically validated.

Gemini receives the reachable source candidates with their HTTP status and fetched title. The Notion meeting page still labels them as source candidates.

The next source milestone is real content extraction and source-specific summaries.


If n8n does not expose an HTTP status code but returns a response body without an error, FamilyHubOS records the source as `HTTP 200 estimé`. This means the request succeeded from the workflow point of view, but the exact upstream status code was not available in the node output.
