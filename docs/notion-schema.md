# FamilyOS - Notion Schema

## Purpose

Notion is the human-facing memory of FamilyOS.

It stores:

- meetings
- topic backlog
- validated sources
- family decisions
- meeting feedback

It does not store:

- workflow execution logs
- retries
- raw LLM payloads
- temporary Telegram states
- secrets

Technical state belongs in PostgreSQL database `familyos` on `n8n-postgres`.

## Databases

Create five Notion databases:

```text
FamilyOS - Meetings
FamilyOS - Topics
FamilyOS - Sources
FamilyOS - Decisions
FamilyOS - Feedback
```

For n8n configuration, store their IDs in:

```text
NOTION_MEETINGS_DATABASE_ID
NOTION_TOPICS_DATABASE_ID
NOTION_SOURCES_DATABASE_ID
NOTION_DECISIONS_DATABASE_ID
NOTION_FEEDBACK_DATABASE_ID
```

## FamilyOS - Meetings

Purpose: one page per family meeting.

| Property | Type | Required | Phase | Notes |
| --- | --- | --- | --- | --- |
| `Title` | Title | Yes | MVP | Example: `Family Meeting #08 - Les effets de la musique chez le bébé` |
| `MeetingNumber` | Number | Yes | MVP | Sequential number |
| `Date` | Date | Yes | MVP | Planned meeting date |
| `Category` | Select | Yes | MVP | Uses configured category list |
| `Topic` | Rich text | Yes | MVP | Human-readable topic |
| `TopicRelation` | Relation to Topics | No | MVP | Use when topic exists in backlog |
| `Status` | Select | Yes | MVP | Lifecycle status |
| `ChildAge` | Rich text | Yes | MVP | Calculated when page is generated |
| `PreparationStatus` | Select | Yes | MVP | Reading/preparation state |
| `NotionURL` | URL | No | MVP | Can be filled after page creation if needed |
| `CalendarEventId` | Rich text | No | MVP | Enables idempotent Calendar updates |
| `ReadingTimeMinutes` | Number | No | MVP | Sum of selected source reading times |
| `SourceCount` | Number | No | MVP | Number of accepted sources |
| `CreatedAt` | Created time | Yes | MVP | Native Notion field |
| `UpdatedAt` | Last edited time | Yes | MVP | Native Notion field |

Status options:

```text
Idea
Proposed
Researching
Ready
Scheduled
Done
Cancelled
```

PreparationStatus options:

```text
NotStarted
InProgress
Ready
Skipped
```

Page content template:

```text
Pourquoi ce sujet maintenant ?
Résumé
Points importants
À lire
Questions pour notre discussion
Idées à tester
Nos notes
Nos décisions
À revoir
Sources
```

## FamilyOS - Topics

Purpose: backlog and lifecycle of possible meeting topics.

| Property | Type | Required | Phase | Notes |
| --- | --- | --- | --- | --- |
| `Title` | Title | Yes | MVP | Topic idea |
| `Category` | Select | No | MVP | Can be empty when unknown |
| `Status` | Select | Yes | MVP | Topic lifecycle |
| `Priority` | Select | No | Phase 2 | Optional prioritization |
| `SuggestedBy` | Rich text | No | MVP | Telegram username, parent name, or system |
| `Source` | Select | Yes | MVP | Example: Telegram, Notion, FamilyOS |
| `CreatedAt` | Created time | Yes | MVP | Native Notion field |
| `LastUsedAt` | Date | No | MVP | Updated when selected |
| `Meeting` | Relation to Meetings | No | MVP | Meeting that used the topic |
| `Notes` | Rich text | No | MVP | Parent notes |

Status options:

```text
Idea
Candidate
Selected
Done
Archived
```

Priority options:

```text
Low
Normal
High
Someday
```

Source options:

```text
Telegram
Notion
FamilyOS
Parent
Imported
```

## FamilyOS - Sources

Purpose: traceability for selected and rejected sources.

| Property | Type | Required | Phase | Notes |
| --- | --- | --- | --- | --- |
| `Title` | Title | Yes | MVP | Source title |
| `URL` | URL | Yes | MVP | Canonical URL |
| `Domain` | Rich text | Yes | MVP | Extracted domain |
| `Publisher` | Rich text | No | MVP | Institution or publisher |
| `Author` | Rich text | No | MVP | Empty if not available |
| `PublicationDate` | Date | No | MVP | Empty if unknown |
| `SourceType` | Select | Yes | MVP | Official, University, Journal, etc. |
| `ReliabilityScore` | Number | Yes | MVP | Configurable score |
| `Validated` | Checkbox | Yes | MVP | Accepted for meeting |
| `ValidationReason` | Rich text | No | MVP | Why accepted/rejected |
| `Topic` | Relation to Topics | No | MVP | Topic relation when available |
| `Meeting` | Relation to Meetings | No | MVP | Meeting that used the source |
| `Summary` | Rich text | No | MVP | Short source summary |
| `ReadingTimeMinutes` | Number | No | MVP | Estimated reading time |

SourceType options:

```text
Official
HealthAuthority
University
Hospital
ScientificJournal
ScientificStudy
EducationalInstitution
CulturalInstitution
QualityPopularization
Media
Commercial
Unknown
```

## FamilyOS - Decisions

Purpose: decisions made during meetings and later review.

| Property | Type | Required | Phase | Notes |
| --- | --- | --- | --- | --- |
| `Decision` | Title | Yes | Phase 2 | Decision text |
| `Meeting` | Relation to Meetings | Yes | Phase 2 | Source meeting |
| `CreatedAt` | Created time | Yes | Phase 2 | Native Notion field |
| `ReviewAt` | Date | No | Phase 2 | Follow-up date |
| `Status` | Select | Yes | Phase 2 | Decision lifecycle |
| `ReviewResult` | Rich text | No | Phase 2 | Review notes |

Status options:

```text
Testing
Adopted
Rejected
Modified
ToReview
```

## FamilyOS - Feedback

Purpose: post-meeting feedback.

| Property | Type | Required | Phase | Notes |
| --- | --- | --- | --- | --- |
| `Title` | Title | Yes | Phase 2 | Example: `Feedback - Meeting #08` |
| `Meeting` | Relation to Meetings | Yes | Phase 2 | Meeting relation |
| `InterestRating` | Number | No | Phase 2 | 1 to 5 |
| `UsefulnessRating` | Number | No | Phase 2 | 1 to 5 |
| `DeepenTopic` | Checkbox | No | Phase 2 | Create follow-up topic if true |
| `Notes` | Rich text | No | Phase 2 | Parent feedback |
| `FollowUpTopics` | Relation to Topics | No | Phase 2 | Suggested next topics |
| `CreatedAt` | Created time | Yes | Phase 2 | Native Notion field |

## Relations

Recommended relations:

```text
Topics.Meeting -> Meetings
Sources.Topic -> Topics
Sources.Meeting -> Meetings
Decisions.Meeting -> Meetings
Feedback.Meeting -> Meetings
Feedback.FollowUpTopics -> Topics
```

For the MVP, only these relations are needed:

```text
Meetings.TopicRelation -> Topics
Sources.Meeting -> Meetings
Sources.Topic -> Topics
Topics.Meeting -> Meetings
```

## n8n Mapping

### Meeting Builder to Meetings

| n8n field | Notion property |
| --- | --- |
| `meeting.title` | `Title` |
| `meeting.number` | `MeetingNumber` |
| `meeting.date` | `Date` |
| `meeting.category` | `Category` |
| `meeting.topic` | `Topic` |
| `meeting.topicPageId` | `TopicRelation` |
| `meeting.status` | `Status` |
| `meeting.childAgeLabel` | `ChildAge` |
| `meeting.preparationStatus` | `PreparationStatus` |
| `meeting.calendarEventId` | `CalendarEventId` |
| `meeting.readingTimeMinutes` | `ReadingTimeMinutes` |
| `meeting.sourceCount` | `SourceCount` |

### Research to Sources

| n8n field | Notion property |
| --- | --- |
| `source.title` | `Title` |
| `source.url` | `URL` |
| `source.domain` | `Domain` |
| `source.publisher` | `Publisher` |
| `source.author` | `Author` |
| `source.publicationDate` | `PublicationDate` |
| `source.sourceType` | `SourceType` |
| `source.score` | `ReliabilityScore` |
| `source.accepted` | `Validated` |
| `source.reason` | `ValidationReason` |
| `source.summary` | `Summary` |
| `source.readingTimeMinutes` | `ReadingTimeMinutes` |

### Telegram /idea to Topics

| n8n field | Notion property |
| --- | --- |
| `idea.text` | `Title` |
| `idea.category` | `Category` |
| `Idea` | `Status` |
| `idea.author` | `SuggestedBy` |
| `Telegram` | `Source` |
| `idea.notes` | `Notes` |

## Creation Checklist

1. Create the five databases in Notion.
2. Add the properties with the exact names above.
3. Configure select options.
4. Add relations between databases.
5. Share every database with the Notion integration.
6. Copy database IDs into n8n configuration.
7. Run a small n8n test that creates one `Topic` from `/idea`.
8. Run a small n8n test that creates one `Meeting` page.

## MVP Required Fields

Minimum to start workflows:

```text
Meetings: Title, MeetingNumber, Date, Category, Topic, Status, ChildAge, PreparationStatus, CalendarEventId
Topics: Title, Category, Status, SuggestedBy, Source, LastUsedAt, Meeting
Sources: Title, URL, Domain, Publisher, SourceType, ReliabilityScore, Validated, ValidationReason, Topic, Meeting, Summary, ReadingTimeMinutes
```

## Modeling Notes

- Notion database query requests put the database ID in the URL, not in the JSON body.

- Child age is calculated from birth date. Do not store a fixed child age as source truth.
- `ChildAge` in Meetings is a historical display label generated at meeting creation time.
- `CalendarEventId` supports idempotent Calendar updates.
- Rejected sources may be stored with `Validated = false` if useful for traceability.
- If a Notion property type must change during real setup, update this document before updating n8n workflows.
