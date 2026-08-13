-- FamilyOS technical database bootstrap example.
-- Review before running. Do not execute blindly in production.
--
-- Recommended target:
--   PostgreSQL instance: n8n-postgres
--   Database: familyos
--
-- This file assumes the database already exists and is connected.

create table if not exists workflow_runs (
    id uuid primary key,
    workflow_name text not null,
    execution_id text,
    meeting_id text,
    status text not null,
    started_at timestamptz not null default now(),
    finished_at timestamptz,
    duration_ms integer,
    input jsonb,
    output jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index if not exists idx_workflow_runs_workflow_name
    on workflow_runs (workflow_name);

create index if not exists idx_workflow_runs_meeting_id
    on workflow_runs (meeting_id);

create index if not exists idx_workflow_runs_status
    on workflow_runs (status);

create table if not exists workflow_errors (
    id uuid primary key,
    workflow_run_id uuid references workflow_runs (id) on delete set null,
    workflow_name text not null,
    execution_id text,
    meeting_id text,
    step text not null,
    error_code text,
    error_message text not null,
    error_details jsonb,
    retry_count integer not null default 0,
    created_at timestamptz not null default now()
);

create index if not exists idx_workflow_errors_workflow_run_id
    on workflow_errors (workflow_run_id);

create index if not exists idx_workflow_errors_meeting_id
    on workflow_errors (meeting_id);

create table if not exists conversation_states (
    id uuid primary key,
    telegram_chat_id text not null,
    telegram_user_id text,
    state_key text not null,
    state_value jsonb not null,
    expires_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    unique (telegram_chat_id, telegram_user_id, state_key)
);

create index if not exists idx_conversation_states_expires_at
    on conversation_states (expires_at);

create table if not exists idempotency_keys (
    key text primary key,
    scope text not null,
    status text not null,
    resource_type text,
    resource_id text,
    request_hash text,
    response jsonb,
    expires_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index if not exists idx_idempotency_keys_scope
    on idempotency_keys (scope);

create index if not exists idx_idempotency_keys_expires_at
    on idempotency_keys (expires_at);

create table if not exists research_cache (
    id uuid primary key,
    topic text not null,
    category text,
    child_context_hash text,
    query_hash text not null,
    result jsonb not null,
    source_count integer not null default 0,
    accepted_source_count integer not null default 0,
    expires_at timestamptz not null,
    created_at timestamptz not null default now(),
    unique (query_hash)
);

create index if not exists idx_research_cache_topic
    on research_cache (topic);

create index if not exists idx_research_cache_expires_at
    on research_cache (expires_at);

