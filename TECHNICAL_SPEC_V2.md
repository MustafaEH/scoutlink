# Technical Specification V2 — Flutter + FastAPI

Status: authoritative technical specification for the MVP. This supersedes `TECHNICAL_SPEC.md`.

## 1. Architecture decision

Build one Flutter mobile app for players, guardians, recruiters, academy representatives, and assigned platform staff; expose all business operations through a FastAPI modular monolith; use managed PostgreSQL; and keep the public marketing site as semantic HTML/CSS with minimal JavaScript.

This fits the founding developer's existing skills and preserves a path to Android and iOS without duplicating the product.

| Area | MVP choice |
|---|---|
| Product client | Flutter stable, pinned per project |
| Public marketing | Semantic HTML, CSS, minimal JavaScript |
| API | FastAPI, Python, Pydantic v2 |
| Data access | SQLAlchemy 2 async, Alembic, psycopg 3 |
| Database | Supabase managed PostgreSQL |
| Authentication | Supabase Auth; JWT verified by FastAPI |
| Photos/documents | Private Supabase Storage |
| Video | Mux Direct Uploads, webhooks, signed HLS playback |
| Search/feed | PostgreSQL indexes, full-text/trigram search, SQL ranking |
| Background work | PostgreSQL job/outbox tables plus a separate Python worker |
| Hosting | Static CDN for the marketing site; Dockerized managed API/worker |
| Monitoring | Structured logs, error tracking, uptime checks, audit log |

## 2. Product surfaces

### Flutter product

One codebase, with role-aware navigation and authorization:

- Player/guardian: mobile-first profile management, video upload, status, and meeting coordination.
- Recruiter: mobile discovery, filters, video review, shortlists, verified interest, and meeting requests.
- Platform staff: assigned mobile access to verification, moderation, safeguarding, meeting, and audit workflows.

Release order:

1. Android app for the pilot.
2. iOS from the same Flutter codebase after pilot hardening; building and signing requires macOS and Apple distribution work.

### Public website

Use hand-built HTML/CSS for the landing page, academy recruitment, recruiter application, trust/safety explanation, and contact pages. This keeps public content fast, searchable, accessible, and independent from the application bundle.

## 3. System shape

```text
Flutter Android / iOS app
            |
       HTTPS REST API
            |
     FastAPI modular monolith
       |       |          |
 PostgreSQL  Storage     Mux
       |                  |
   job/outbox <------ signed webhook
       |
 Python worker

Static HTML/CSS marketing site -> CDN
```

FastAPI is the only business-data gateway. Flutter must not query or mutate business tables through the Supabase Data API. This gives us one authorization layer, consistent audit events, and freedom to change clients later.

## 4. Repository structure

```text
apps/
  api/                 FastAPI application and tests
  worker/              background-job process
  product_flutter/     authenticated multi-role Flutter product
  marketing/           static public HTML/CSS site
packages/
  design_tokens/       optional shared/generated visual tokens
infra/                 containers, deployment, environment examples
docs/                  decisions, runbooks, API conventions
```

Keep this as one repository and one deployable API during the MVP. Do not introduce microservices.

## 5. Flutter implementation

### Core packages

- Riverpod for dependency injection and predictable application state.
- `go_router` for role-aware navigation and deep links.
- Dio for HTTP, upload progress, cancellation, and interceptors.
- `video_player` for HLS playback.
- Generated immutable JSON models where generation materially reduces mistakes.
- Secure local storage on mobile clients using the authentication provider's supported session flow.

Pin Flutter with FVM or a documented exact SDK version. Enable strict Dart analysis and prohibit secrets in client builds.

### Adaptive UI

Treat layout as adaptive rather than merely stretched:

| Width | Navigation and layout |
|---|---|
| Compact, under 600 px | Bottom navigation, single-column, touch-first |
| Medium, 600–1023 px | Navigation rail, flexible one/two-column layout |
| Expanded, 1024 px and above | Large-tablet/foldable navigation rail and optional split detail |

Deep links must open a specific player, highlight, shortlist, meeting, or staff case after authentication. Keyboard navigation, focus order, captions, contrast, and 44–48 px touch targets are acceptance criteria.

The visual system implements the “Scout's Notebook” direction in `DESIGN_AND_SCREENS_V1.md`. We will create custom tokens and components rather than ship the default Material appearance.

## 6. FastAPI implementation

Use a modular monolith organized by business capability:

```text
app/
  api/v1/
  core/                settings, security, errors, logging
  db/                  sessions, models, migrations support
  modules/
    auth/
    users/
    players/
    guardians/
    recruiters/
    media/
    discovery/
    shortlists/
    meetings/
    verification/
    moderation/
    audit/
  integrations/        Supabase, Mux, notifications
tests/
```

Rules:

- Route handlers validate transport data and call application services.
- Business and authorization rules live outside route handlers.
- Database models do not become API response models automatically.
- All timestamps are UTC; display uses the user's locale/time zone.
- Alembic owns every schema change.
- Use a transaction for each command that changes related records.
- Use idempotency keys for meeting requests, interest actions, upload creation, and webhook processing.

API conventions:

- Versioned JSON REST endpoints under `/api/v1`.
- Consistent error envelope with a stable machine code and safe human message.
- Cursor pagination for feeds, search results, and audit records.
- OpenAPI is the API contract; generate client models only after endpoints stabilize.
- Health endpoints distinguish process health from dependency readiness.

## 7. Identity and authorization

Supabase Auth issues the user session. Flutter sends the access token as a bearer token. FastAPI verifies its signature, issuer, audience, expiry, and key ID using the provider's supported JWKS/claims mechanism.

The database is the source of truth for product role, recruiter verification, guardian relationship, suspension, and staff permissions. Never trust a client-supplied role.

Authorization combines:

- role: player, guardian, recruiter, staff, administrator;
- verification state;
- resource relationship, such as guardian-to-player;
- player age/minor status;
- record state, such as draft, published, suspended, or deleted.

Minors cannot receive direct recruiter contact. A guardian and the platform team control meeting progression. Every meeting includes an assigned platform representative.

Use separate database credentials for migrations and runtime. Put business tables in a non-public application schema where practical. RLS and storage policies provide defense in depth; privileged service credentials exist only on the server.

## 8. Core data model

Initial aggregates:

- `users`, `user_roles`, `sessions_metadata`
- `player_profiles`, `player_guardians`, `player_positions`, `player_attributes`
- `academies`, `player_academies`
- `recruiter_profiles`, `recruiter_verifications`, `organizations`
- `media_assets`, `highlights`, `highlight_events`
- `applause`, `professional_interest`, `shortlists`, `shortlist_players`
- `meeting_requests`, `meetings`, `meeting_participants`, `meeting_events`
- `moderation_cases`, `reports`, `consents`
- `notifications`, `audit_events`, `outbox_events`, `background_jobs`

Constraints must enforce unique applause per user/highlight, valid guardian relationships, state transitions, and duplicate-request prevention. Soft deletion is used where safeguarding, audit, or deal history must remain recoverable.

## 9. Media flows

### Video

1. Flutter requests an upload session from FastAPI.
2. FastAPI checks permissions and creates a Mux Direct Upload URL.
3. Flutter uploads directly to Mux and reports progress.
4. Mux sends a signed webhook to FastAPI.
5. FastAPI processes the webhook idempotently and updates the media state.
6. Approved viewers receive short-lived signed playback authorization.

Large video bytes never pass through FastAPI. Enforce duration, size, format, upload-count, and moderation limits. Store the provider asset/playback IDs, not a permanent public video URL.

### Photos and documents

Store originals privately. FastAPI grants short-lived upload/download access after checking authorization. Validate MIME type, extension, size, and image dimensions; scan sensitive documents before staff access when the selected provider supports it.

## 10. Discovery and ranking

PostgreSQL is sufficient for the MVP. Index filters such as age band, position, dominant foot, governorate, academy, verification state, and profile completeness. Use full-text/trigram search for names and organizations.

The feed score is transparent and capped. It may combine recent approved highlights, profile completeness, video quality signals, applause, and verified professional interest. It must not use paid boosts in the MVP. Add diversity and freshness rules so early popularity does not permanently bury new players.

## 11. Security and safeguarding baseline

Use OWASP ASVS Level 2 as the engineering checklist, tailored to the product. Required controls include:

- TLS only, strict allowed origins, secure headers, and narrow CORS.
- MFA for staff and administrators; stronger checks for destructive actions.
- Rate limits for authentication, discovery, applause, interest, reporting, and meetings.
- Short-lived signed media access and backend-only provider secrets.
- Structured audit events for profile access, verification, moderation, meetings, consent, and permission changes.
- Redaction of tokens, documents, phone numbers, and sensitive minor data from logs.
- Dependency and secret scanning in CI.
- Encrypted managed services, backups, restoration tests, and documented retention.
- No production minor data in local development; use synthetic fixtures.

Formal legal approval can remain a launch gate, but guardian consent, age-aware authorization, privacy controls, and auditability are architectural requirements from day one because retrofitting them is unsafe.

## 12. Testing and quality gates

Backend:

- Pytest unit and service tests.
- Integration tests against PostgreSQL for queries, migrations, constraints, and transactions.
- Authorization-matrix tests for every protected resource.
- Contract tests for Mux and authentication integrations, plus signed-webhook fixtures.

Flutter:

- Unit tests for state and domain behavior.
- Widget tests for critical forms and role states.
- Integration tests for sign-in, profile publication, upload, discovery, shortlist, meeting, and moderation paths.
- A small set of golden tests for core design-system components and responsive layouts.

CI must run formatting, static analysis, tests, migration checks, secret scanning, dependency checks, Android build, and Docker image build. A pull request cannot merge with failing required checks.

## 13. Deployment and environments

Maintain local, staging, and production environments with separate databases, storage, authentication projects, video credentials, and secrets.

- Marketing site: static hosting behind a CDN.
- API and worker: separate processes from the same versioned Docker image on a managed container platform.
- Database/auth/storage: Supabase in a region selected after measuring Egypt and target-recruiter latency.
- Video: Mux.

Provider selection for static and container hosting is deliberately deferred until a small deployment spike compares Egypt latency, required headers, logs, cost, and operational simplicity. The application remains portable through containers and environment-based configuration.

## 14. Scaling path

Scale vertically first. Add API instances, worker instances, database indexes, connection pooling, and CDN caching before changing architecture. Introduce Redis, an external search engine, or service separation only when production measurements identify a specific bottleneck.

The initial architecture can support the 50-player pilot and growth far beyond it without pretending the MVP needs million-user infrastructure.

## 15. Developer workflow

- Python dependency and environment management: `uv` with a committed lockfile.
- Python quality: Ruff formatting/linting and strict type checking at application boundaries.
- Flutter: pinned SDK, `dart format`, `flutter analyze`, and deterministic package lockfile.
- Git: small feature branches, reviewed migrations, conventional commit style if useful.
- Documentation: architecture decisions and operational runbooks committed with code.

## 16. Delivery implication

The existing 12-week MVP plan remains realistic for one full-time developer because it uses familiar technologies. Android is the pilot target. iOS timing depends on access to macOS and Apple review.

## 17. Primary references

- [Flutter adaptive and responsive design](https://docs.flutter.dev/ui/adaptive-responsive)
- [Flutter supported platforms](https://docs.flutter.dev/reference/supported-platforms)
- [FastAPI Docker deployment](https://fastapi.tiangolo.com/deployment/docker/)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Supabase JWT guidance](https://supabase.com/docs/guides/auth/jwts)
- [Supabase Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Mux Direct Uploads](https://www.mux.com/docs/guides/upload-files-directly)
- [Mux video for Flutter](https://www.mux.com/video-for/flutter)
- [OWASP ASVS](https://asvs.owasp.org/)
