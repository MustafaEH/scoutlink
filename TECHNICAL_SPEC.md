# Technical Architecture and Delivery Plan — Superseded

> This React/Next.js proposal has been superseded by [`TECHNICAL_SPEC_V2.md`](./TECHNICAL_SPEC_V2.md), which uses Flutter and FastAPI to match the founding developer's skills. Keep this file only as historical context.

Date: 30 October 2026  
Target: free private MVP for 50 Egyptian players and 10–15 verified recruiters  
Team assumption: one full-time developer, with the nontechnical founder handling research, partnerships, content, and field operations

## 1. Decision summary

| Area | MVP decision |
|---|---|
| Product surface | Responsive web application and installable PWA |
| Native apps | Not in MVP |
| Architecture | TypeScript modular monolith |
| Web/application framework | Next.js 16 stable, App Router |
| API | Versioned REST route handlers inside the monolith |
| Database | Managed PostgreSQL through Supabase |
| Authentication | Supabase Auth with server-controlled role/verification records |
| Database access | Drizzle plus SQL migrations; PostgreSQL RLS as defense in depth |
| Photos/documents | Supabase private Storage with short-lived signed access |
| Video | Mux Direct Uploads, webhooks, adaptive streaming, signed playback |
| Search/feed | PostgreSQL indexes, full-text/trigram search, and transparent SQL ranking |
| Background jobs | PostgreSQL outbox/job table and scheduled worker initially |
| Styling/components | Tailwind CSS and shadcn/ui primitives |
| Languages | Arabic RTL and English from the first release |
| Testing | Vitest, Testing Library, Playwright, database/RLS tests |
| Hosting | Vercel application plus explicitly selected Supabase region |
| Security standard | OWASP ASVS 5.0 Level 2-informed baseline |
| Expected private MVP | 12 full-time development weeks under frozen v1 scope |

## 2. Why web/PWA first

The players will mainly use phones, but that does not require native applications initially. Recruiters and administrators will also use laptops, making responsive web the best common surface.

### Benefits

- One codebase for mobile, tablet, and desktop.
- No App Store/Play Store review delay.
- Links from social media open directly into the product.
- Faster iteration during the pilot.
- Camera/file uploads work from modern mobile browsers.
- Can be installed on the home screen as a PWA.
- Better desktop workflow for scout comparison and administration.
- Lower development and testing burden for a solo developer.

### Limitations accepted for MVP

- Push notifications and background upload behaviour vary by mobile browser.
- Native camera/media editing is more limited.
- Offline functionality will be minimal.
- App-store discovery is postponed.

### Native-app trigger

Consider Expo/React Native only after the pilot shows:

- strong weekly mobile retention;
- repeated requests for push notifications, camera workflows, or offline upload;
- enough operational value to justify maintaining additional clients;
- a stable REST API and product workflow.

The REST API and shared TypeScript domain types keep a future mobile client possible without building it now.

## 3. Architecture

### High-level flow

```text
Mobile/Desktop Browser
        |
        v
Next.js PWA on Vercel
  - pages and layouts
  - REST API / server actions
  - authentication/session boundary
  - domain services and authorization
        |
        +----------> Supabase Auth
        +----------> PostgreSQL
        +----------> Private document/photo storage
        +----------> Mux signed upload/playback
        +----------> Transactional email
        |
Scheduled worker / webhooks
  - video status
  - notifications
  - reminders
  - availability expiry
  - audit/outbox processing
```

### Modular monolith

Use one deployable application with strict internal modules:

1. Identity and sessions
2. Users, roles, and organisations
3. Guardians, minors, and consent
4. Player profiles and football history
5. Media/video
6. Recruiter verification
7. Discovery feed and search
8. Reactions, professional interest, and shortlists
9. Meeting requests and outcomes
10. Notifications
11. Moderation and safeguarding
12. Audit and analytics
13. Administration

Each module owns its schemas, validation, service functions, policies, and tests. Modules communicate through functions and domain events rather than importing random database queries from each other.

Do not use microservices. The expected load does not justify distributed deployment, service discovery, multiple databases, cross-service tracing, or eventual-consistency complexity.

## 4. Suggested repository structure

Use a small pnpm workspace so a background worker or future mobile client can be added without reorganising everything.

```text
apps/
  web/
    src/
      app/
      modules/
      server/
      components/
      styles/
    tests/
  worker/                 # add when scheduled processing exceeds web cron
packages/
  db/
    schema/
    migrations/
    policies/
  domain/
  ui/
  validation/
  config/
docs/
  architecture/
  decisions/
  runbooks/
supabase/
  migrations/
  tests/
```

If the workspace slows the solo developer down initially, begin with `apps/web` and the same internal boundaries. Do not introduce Turborepo, Nx, or a complex build graph until there are multiple independently built applications.

## 5. Application stack

### Next.js and TypeScript

- Use the latest stable Next.js 16.x release, not canary.
- Use the current Node.js Active LTS version and pin it in the repository/tooling.
- Enable strict TypeScript settings.
- Prefer Server Components for read-heavy pages and client components only for interactive areas.
- Keep sensitive mutations behind authenticated server endpoints.
- Do not expose secrets or privileged database clients in client bundles.
- Use REST endpoints under `/api/v1` for operations a future mobile app may need.

### UI system

- Tailwind CSS for tokens and layout.
- shadcn/ui as accessible primitives, not as an unmodified visual identity.
- Radix-based behaviour where used by those primitives.
- Lucide icons or one consistent icon set.
- Design tokens for colour, spacing, radius, typography, elevation, and motion.
- Storybook is optional; use it only if the component surface becomes difficult to review inside the app.

### Forms and validation

- React Hook Form for complex forms.
- Zod schemas shared between server and client for input shape.
- Server-side validation is authoritative.
- Never trust hidden fields, client role values, file metadata, or age/guardian flags.
- Use progressive autosave for long player-profile forms.

## 6. Database decision

### Why PostgreSQL

The product is strongly relational:

- users have multiple roles;
- guardians have relationships to players;
- players belong to academies over time;
- recruiters belong to organisations;
- visibility depends on role, verification, age, consent, and relationship;
- meetings have participants and event history;
- audit and verification records must remain consistent.

PostgreSQL gives transactions, foreign keys, constraints, JSONB for limited flexible fields, full-text search, trigram matching, and mature indexing. NoSQL would make the permission and relationship model harder without providing an MVP benefit.

### Why Supabase

- Managed PostgreSQL.
- Authentication and session infrastructure.
- Private object storage.
- Row Level Security support.
- Backups and region selection on paid plans.
- Local development and migrations through its CLI.
- Avoids operating a database/auth/storage stack alone.

Supabase states that the selected project region determines where the main database, Auth, Storage objects, and backups are hosted, while noting that some processing may still occur outside that region. Region choice is therefore a control, not proof of Egyptian legal compliance.

### Region

Use a specifically selected region rather than an ambiguous general region. Frankfurt is a practical latency candidate for Egypt, but legal counsel must approve child-data and cross-border processing arrangements before real pilot data is uploaded.

Do not choose a region solely from latency. Review:

- Egyptian personal-data rules;
- child-data classification;
- vendor DPAs and subprocessors;
- video processing locations;
- contractual safeguards and guardian notices;
- backup and support-access locations.

## 7. Data-access and authorization model

This is the highest-risk technical area.

### Rules

- Authentication answers “who is the user?”
- Authorization answers “may this user perform this action on this exact record?”
- Roles alone are insufficient; permissions also depend on player age, guardian relationship, verification status, organisation, meeting participation, and record visibility.

Use RBAC plus relationship/attribute checks:

- role-based: player, guardian, recruiter, academy, agent, admin;
- relationship-based: guardian of this player, member of this organisation, participant in this meeting;
- attribute-based: recruiter verified, player under 18, consent active, profile published.

### Defense in depth

1. UI hides unavailable actions.
2. API/domain service checks authorization.
3. PostgreSQL grants and RLS restrict exposed data paths.
4. Private storage validates access before issuing a short-lived URL.
5. Audit log records sensitive reads/actions where appropriate.

Supabase advises enabling RLS and reviewing grants on every exposed table. RLS policies need automated allow-and-deny tests; an untested policy is not a security boundary.

### Service-role key

- Server only.
- Isolated in a dedicated module.
- Never included in browser code, logs, screenshots, or client environment variables.
- Used only for explicit administrative/system operations.
- Every service-role mutation writes an audit record.

## 8. Core data model

Initial tables/entities:

### Identity and organisations

- `users`
- `user_roles`
- `organisations`
- `organisation_members`
- `sessions_metadata`

### Players and guardians

- `player_profiles`
- `guardian_relationships`
- `consent_records`
- `career_entries`
- `player_affiliations`
- `player_positions`
- `player_languages`
- `availability_records`

### Media

- `media_assets`
- `video_assets`
- `video_clips`
- `video_context`
- `media_permissions`

### Trust

- `verification_cases`
- `verification_claims`
- `verification_documents`
- `agent_licence_checks`
- `reports`
- `moderation_actions`
- `safeguarding_cases`

### Discovery

- `recruitment_briefs`
- `feed_impressions`
- `reactions`
- `professional_interests`
- `shortlists`
- `shortlist_entries`
- `private_scout_notes`
- `pass_signals`

### Meetings

- `meeting_requests`
- `meeting_participants`
- `meeting_events`
- `meeting_outcomes`

### Platform

- `notifications`
- `outbox_events`
- `background_jobs`
- `audit_events`
- `feature_flags`

### Data rules

- UUID primary keys.
- UTC timestamps in the database; render in user timezone.
- Explicit `created_by`, `updated_by`, and organisation context where relevant.
- Foreign keys and check constraints for business invariants.
- Append-only event/history tables for verification, consent, and meeting changes.
- Soft deletion only when recovery/audit is required; do not use it as a substitute for defined retention.
- Public display data separated from restricted identity/contact data.
- Verification documents stored outside normal profile records.

## 9. Feed and search implementation

### Search

Start with PostgreSQL:

- B-tree indexes for position, age/birth year, governorate, status, and verification.
- GIN indexes for full-text search.
- `pg_trgm` for typo-tolerant names/academy search.
- Keyset/cursor pagination rather than large offsets.
- Precomputed/profile-search projection when joins become expensive.

Do not add Elasticsearch/OpenSearch until query metrics show PostgreSQL cannot meet the target.

### Feed ranking

Use a transparent SQL score, not machine learning.

Example conceptual inputs:

```text
score = brief_match
      + verified_professional_interest
      + shortlist_signal
      + evidence_completeness
      + freshness
      + new_player_exploration
      + limited_applause_signal
      - trust_penalty
      - overexposure_penalty
```

Maintain separate candidate generation and ranking:

1. Exclude records the recruiter may not access.
2. Generate candidates matching broad preferences/briefs.
3. Add an exploration quota for new/unseen players.
4. Calculate the explainable score.
5. Apply diversity/exposure controls.
6. Record impression and reason codes.

This supports future tuning without pretending to predict absolute talent.

### Feed performance

- Return metadata and thumbnail first.
- Preload only the next one or two videos.
- Use adaptive video streaming.
- Do not autoplay sound.
- Respect data-saver and reduced-motion preferences.
- Record a view only after a defined watch threshold, not when a card flashes on screen.

## 10. Video pipeline

Do not upload large videos through the Next.js/Vercel server.

### Flow

1. Authenticated client requests an upload session.
2. Server verifies player/guardian permission, quotas, allowed type, and purpose.
3. Server creates a short-lived Mux Direct Upload URL.
4. Browser uploads directly to Mux with resumable/chunked upload support.
5. Mux processes the asset and sends signed webhooks.
6. Server verifies webhook signature and updates `video_assets` idempotently.
7. Moderation/metadata checks run before publication.
8. Authorized viewer requests a short-lived signed playback token.

Mux documents Direct Uploads for browser-to-provider uploads and signed playback tokens for restricted assets. Use signed—not public—playback for minor and marketplace-only videos.

### Video rules

- Limit duration, file size, resolution, and concurrent uploads.
- Store provider IDs, not permanent public playback URLs.
- Validate webhook signatures and defend against replay.
- Treat webhook delivery as at-least-once; handlers must be idempotent.
- Delete rejected/abandoned media according to retention policy.
- Keep public teaser playback separate from private full evidence.
- No download button for recruiter-facing video.
- Watermarking is optional and not a substitute for access control.

### Cost controls

- Per-player upload/storage limits.
- Basic encoding tier during pilot.
- Delete abandoned drafts.
- Track uploaded minutes, stored minutes, and delivered minutes per user/organisation.
- Disable arbitrary duplicate re-uploads.
- Set usage alerts before the pilot opens.

## 11. Photos, documents, and identity evidence

- Private storage buckets only.
- Random object paths; never use legal names in paths.
- Signed URLs with short TTL.
- File allowlist and size limits.
- Inspect MIME type and file signature, not extension alone.
- Strip unsafe metadata from public images where possible.
- Malware scan non-image documents before review/download.
- Identity documents accessible only to specifically authorised verification staff.
- Do not show raw identity documents in routine support/admin screens.
- Define deletion after verification/legal retention review; retain verification result and audit data rather than documents indefinitely where lawful.

## 12. Authentication and account security

### MVP login

- Email/password or email OTP/magic link.
- Verified phone number as a separate trust attribute; phone OTP can be added after provider reliability/cost testing.
- Google sign-in may reduce friction for adults but does not replace role or recruiter verification.
- No social login for a child's standalone account; minors are under guardian-controlled accounts.

### Requirements

- MFA mandatory for administrators and safeguarding staff.
- MFA strongly encouraged for verified recruiters; make it mandatory before accessing particularly sensitive functions if practical.
- Secure, HTTP-only, SameSite cookies.
- Session rotation and revocation.
- Recent-authentication requirement for password, email, MFA, role, and sensitive consent changes.
- Rate limits by IP, user, account identifier, and action.
- Generic login/recovery errors to reduce account enumeration.
- No security questions.
- Recovery changes and suspicious logins produce notifications.

## 13. Security engineering baseline

Use OWASP ASVS 5.0 Level 2 as the requirements checklist because the product processes child and identity data. This does not mean claiming formal certification.

### Before private pilot

- Threat model the guardian, recruiter, media, admin, and meeting flows.
- Inventory all personal/sensitive data and vendors.
- Central authorization helpers with deny-by-default behaviour.
- RLS/grant allow-and-deny tests.
- MFA for privileged accounts.
- Content Security Policy and secure headers.
- CSRF protection appropriate to the session/API pattern.
- Output encoding and XSS protections.
- Server-side input validation.
- Rate limits and bot controls on auth, waitlist, uploads, reactions, and meeting requests.
- Signed media access.
- File validation/malware handling.
- Encrypted transport and provider encryption at rest.
- Secrets manager/environment separation.
- Audit log for admin, verification, consent, and meeting activity.
- Dependency, secret, and static-code scanning in CI.
- Backup restoration test.
- Incident-response and access-revocation runbooks.
- Privacy-scrubbed logs and error reports.
- Manual security review or external penetration test before broad public launch.

### Administrative access

- Separate admin route/app area.
- No shared admin accounts.
- Least-privilege admin roles: verification, moderation, safeguarding, super-admin.
- Step-up authentication for sensitive actions.
- Reason required for suspension, document access, consent override, or data export.
- Audit administrator reads of identity documents where feasible.

## 14. Privacy and data protection by design

- Default minor profiles to verified-recruiter-only.
- Separate guardian contact and player sporting data.
- Collect only what the current workflow needs.
- Record consent purpose, version, guardian, player, timestamp, and withdrawal.
- Make profile preview show exactly what each audience sees.
- Do not send message, identity, or meeting content to analytics tools.
- Disable advertising trackers and cross-site behavioural advertising.
- No session replay on authenticated player/guardian experiences.
- Use aggregate reporting for children where possible.
- Data export/deletion workflows are admin-supported in MVP but fully audited.
- Document retention per table/file category.
- Review every vendor DPA and subprocessor list.
- Do not use player media to train AI without separate legal approval and explicit consent.

## 15. UI/UX standards

### Audience-specific design

- Player/guardian: mobile-first, guided, encouraging, low reading burden.
- Recruiter: fast feed plus dense desktop profile/shortlist views.
- Admin: desktop-first queues, filters, clear risk/status indicators.

### Arabic and English

- Internationalisation architecture from the first commit.
- Logical CSS properties so RTL is not an afterthought.
- Arabic fonts tested on low-end Android devices.
- Football terms reviewed by native Arabic and English football users.
- User-entered Arabic and English profile variants stored separately where required, not overwritten by machine translation.

### Accessibility

Target WCAG 2.2 AA:

- keyboard navigation;
- visible focus;
- semantic HTML and labelled controls;
- sufficient contrast;
- captions/transcripts for important platform content;
- alternatives to drag/swipe-only actions;
- reduced motion;
- clear errors and recovery;
- large touch targets;
- avoid colour as the only status signal.

### Mobile and network resilience

- Test at 360px width and common Android browsers.
- Optimise images and thumbnails.
- Resumable video uploads.
- Autosave drafts.
- Clear processing/retry states.
- Skeletons for short waits and explicit progress for long work.
- Preserve form input after network failure.
- Keep initial JavaScript and feed preloading controlled.

### Design process

1. Low-fidelity flow.
2. Clickable prototype.
3. Five-player/guardian usability sessions.
4. Five-recruiter usability sessions.
5. Build reusable primitives.
6. Accessibility and mobile review.
7. Instrument completion/drop-off.

Do not build polished screens before testing the flow.

## 16. API and engineering conventions

### REST conventions

- `/api/v1/...` namespace.
- Resource-oriented paths.
- Zod-validated request/response boundaries.
- Consistent error envelope with non-sensitive public messages and trace IDs.
- Cursor pagination.
- Idempotency keys for upload-session, meeting-request, and critical admin mutations.
- Optimistic concurrency/version column for records that may be edited by multiple actors.
- Request IDs propagated into logs and audit records.
- OpenAPI generation/documentation when the API stabilises.

### Coding standards

- Strict TypeScript; avoid `any` outside isolated migration/integration boundaries.
- ESLint and Prettier with checked-in configuration.
- Consistent import boundaries enforced by lint rules.
- Small functions and domain-named services.
- No database queries directly in UI components.
- No authorization logic duplicated across pages.
- Architecture Decision Records for significant choices.
- Comments explain why, not obvious syntax.
- No premature generic abstraction.

## 17. Testing strategy

### Unit tests

Use Vitest for:

- feed score and exposure rules;
- eligibility/age calculations;
- state transitions;
- consent/visibility decisions;
- validation and formatting;
- notification decisions.

### Component tests

Use Testing Library for:

- accessible forms;
- role-specific controls;
- upload state;
- feed actions;
- RTL rendering;
- errors and empty states.

### Integration/database tests

- migrations from empty database;
- constraints and transactions;
- RLS/grants for every role and operation;
- guardian/minor access combinations;
- recruiter verification expiry;
- webhook idempotency;
- meeting permissions and audit events.

### End-to-end tests

Use Playwright for critical paths:

1. Guardian creates and submits minor profile.
2. Admin reviews and publishes profile.
3. Verified recruiter discovers, shortlists, and requests a meeting.
4. Guardian responds to meeting request.
5. Admin coordinates and records outcome.
6. User reports content/account.
7. Privilege tests confirm forbidden access.
8. Arabic RTL flows.

Do not chase 100% line coverage. Require high-confidence coverage of permissions, child-data boundaries, payments when introduced, and irreversible actions.

## 18. CI/CD and environments

### Environments

- Local development with local Supabase where practical.
- Preview per pull request with synthetic data only.
- Staging with test accounts and no production child data.
- Production with separate database, storage, secrets, and vendor environment.

### GitHub Actions checks

- dependency install with lockfile;
- formatting/lint;
- TypeScript build/typecheck;
- unit/component tests;
- database migration/RLS tests;
- Playwright smoke tests;
- dependency and secret scanning;
- production build.

### Deployment

- Protected main branch.
- Pull request required even for solo development; self-review using checklist.
- Migration plan and rollback/forward-fix documented.
- Feature flags for risky workflows.
- Production deployments tagged and associated with changelog.
- No automatic production database destructive migration.

## 19. Observability and operations

- Structured JSON logs with request/user pseudonymous IDs.
- Never log tokens, identity numbers, document URLs, message bodies, or complete profiles.
- Error tracking with PII scrubbing.
- Uptime monitor for web, API health, database reachability, and worker freshness.
- Metrics for request latency, errors, video upload failures, webhook backlog, job failures, and email delivery.
- Alert when background jobs are stuck or video cost/usage exceeds thresholds.
- First-party product event table or privacy-reviewed analytics provider.
- No authenticated session replay involving minors.

Runbooks:

- account compromise;
- exposed media URL/key;
- missing/unsafe child interaction;
- video provider outage;
- failed migration;
- database restore;
- vendor/API key rotation;
- user data request/deletion.

## 20. Performance and scale targets

The system does not need million-user architecture. Design for a comfortable first stage:

- 5,000 registered users;
- 1,000 published player profiles;
- 200 verified professional users;
- tens of concurrent users, with burst tolerance around campaigns;
- video traffic delivered by Mux CDN rather than the application;
- typical API reads below 500 ms p95;
- feed/search below 1 second p95;
- 99.5% availability during the pilot.

This architecture can scale much further vertically through managed PostgreSQL, indexes, connection pooling, CDN delivery, and application replicas. Add complexity only when metrics identify a bottleneck.

Likely scaling order:

1. Improve queries and indexes.
2. Add connection pooling/read optimisation.
3. Materialise feed/search projections.
4. Add durable managed job queue.
5. Add cache for expensive shared reads.
6. Add dedicated search engine only if measured.
7. Split services only when independent scaling/team ownership is real.

## 21. Delivery schedule

The authoritative delivery schedule is `BUILD_PLAN_V1.md`.

Summary:

- Weeks 1–2: design system, repository, authentication, roles, organisations, and authorization.
- Weeks 3–5: guardian/adult onboarding, profiles, documents, verification, and academy validation.
- Weeks 6–7: video, feed, search, interest, and shortlists.
- Week 8: recruiter verification and recruitment briefs.
- Week 9: meeting and opportunity workflow.
- Week 10: reports, notifications, administration, and feature completeness.
- Week 11: security, permission, recovery, and operational correctness.
- Week 12: usability, accessibility, devices, performance, legal/safeguarding release gate, and pilot rehearsal.

This assumes one experienced full-time developer, a frozen v1 scope, timely decisions, managed services, and parallel nontechnical work. At approximately half-time capacity, expect 20–24 calendar weeks.

## 22. Scope cuts if schedule slips

Cut in this order:

1. Saved-search alerts.
2. Player comparison.
3. Installable PWA polish/offline shell.
4. In-app general messaging; retain structured meeting communication.
5. Advanced feed personalisation; keep briefs, filters, and fair exploration.
6. Automated PDF CV generation.
7. Nonessential analytics dashboards.

Do not cut:

- guardian control;
- recruiter verification;
- authorization/RLS tests;
- private/signed media access;
- reporting/safeguarding workflow;
- platform-controlled meeting process;
- audit records;
- backups and recovery.

## 23. Definition of done for private MVP

- Critical flows work on current Android Chrome, iPhone Safari, and desktop Chrome/Edge.
- Arabic RTL and English flows are usable.
- Authorization tests cover every restricted entity/action.
- A recruiter cannot access minor/contact/document data without exact permission.
- Video upload handles interruption, processing, failure, and private playback.
- Feed gives recruiter-ready players measurable initial distribution.
- Admins can review users, profiles, videos, recruiters, reports, and meetings.
- Every sensitive admin/meeting action is audited.
- Notifications retry safely.
- Logs and error tracking do not contain prohibited sensitive data.
- Backup restoration and credential-revocation drills pass.
- Accessibility review finds no critical blocker.
- Product has a privacy notice, terms, consent records, retention decisions, and named safeguarding operator.
- Pilot support and incident ownership are clear.

## 24. Decisions and release inputs still required

1. Final project/brand name and domain.
2. First governorates and academy partners.
3. Exact public visibility allowed for 18–19-year-old profiles and teaser clips.
4. Whether adult users can self-register or also require invitation during the pilot.
5. Email provider and sender domain.
6. Provisional development regions now; approved database/storage/video regions before real pilot data.
7. Identity/guardian verification documents and retention period.
8. Who holds admin, safeguarding, and verification permissions.
9. Exact first-pilot video limits.
10. Which functionality is required for the week-10 alpha versus week-16 MVP.

## 25. Official technical references

- [Next.js App Router documentation](https://nextjs.org/docs/app)
- [Next.js stable upgrade/version guidance](https://nextjs.org/docs/app/getting-started/upgrading)
- [Supabase Row Level Security guidance](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Supabase regions and data residency](https://supabase.com/docs/guides/platform/regions)
- [Mux Direct Uploads](https://www.mux.com/docs/guides/upload-files-directly)
- [Mux secure signed playback](https://www.mux.com/docs/guides/secure-video-playback)
- [OWASP ASVS 5.0](https://asvs.owasp.org/)
- [OWASP cheat sheets mapped to ASVS](https://cheatsheetseries.owasp.org/IndexASVS)

