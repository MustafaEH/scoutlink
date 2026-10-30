# 12-Week MVP Build Plan v1.0

Status: Authoritative delivery timeline  
Team: one full-time developer plus one football/business founder  
Outcome: private pilot-ready PWA with all v1.0 P0 features complete

## 1. Delivery strategy

The timeline is achievable only under these rules:

1. Scope in `MVP_PRODUCT_SPEC_V1.md` is frozen for the 12-week cycle.
2. One responsive PWA; no native apps.
3. Managed PostgreSQL/Auth/Storage and managed video.
4. Manual verification and operations before automation.
5. Structured meeting workflow; no general chat.
6. No payments, agent workflow, comments, AI, comparison, or PDF export.
7. Design system approved during week 1 and reused.
8. Business founder handles interviews, content, academies, recruiters, and operational playbooks in parallel.
9. Real minors are not onboarded until the final pilot release gate.
10. Weeks 11–12 are protected hardening time, not feature overflow.

## 2. Milestones

### End of week 2 — foundation demo

- Visual system and application shells.
- Authentication and role skeleton.
- Database/migrations/environments/CI.
- Clickable player/recruiter/admin navigation.

### End of week 5 — supply-side alpha

- Guardian/minor and adult onboarding.
- Player profile, history, privacy, and submission.
- Admin verification/profile review.
- Private photos/documents.

### End of week 7 — discovery alpha

- Direct video upload and private playback.
- Feed, search, filters, reactions, interest, shortlist.
- Recruiter preferences and brief foundation.

### End of week 9 — complete business loop

- Recruiter verification.
- Recruitment briefs.
- Meeting request, guardian/adult response, platform coordination, outcome.
- Reports and restrictions.

### End of week 10 — feature complete

- Notifications.
- Admin operations.
- Analytics funnel.
- Remaining states and responsive/RTL completion.

### End of week 12 — pilot ready

- Security, permission, accessibility, device, recovery, and operational tests pass.
- Minimum legal/safeguarding release documents complete.
- Synthetic-data rehearsal complete.
- Pilot users can be invited safely.

## 3. Weekly plan

### Week 1 — final UX and engineering foundation

Product/design:

- Confirm final screen map and flows.
- Approve colour, typography, shells, feed card, profile card, and forms.
- Create low-fidelity prototypes for guardian onboarding, recruiter feed, and meeting flow.

Engineering:

- Repository structure for Flutter, FastAPI, worker, marketing, and infrastructure.
- Flutter stable pinned for the project, strict Dart analysis, Riverpod, `go_router`, Dio, and custom design-system primitives.
- Arabic/English and RTL foundation.
- FastAPI/Pydantic v2 modular-monolith skeleton with versioned OpenAPI endpoints.
- SQLAlchemy 2, Alembic, PostgreSQL/Supabase staging setup, and migration pipeline.
- Dockerized API and worker foundations; static HTML/CSS marketing-site skeleton.
- CI: formatting, analysis, tests, migrations, Flutter web build, and Docker build.
- Environment validation and secrets rules.
- Architecture decision records.

Exit:

- Deployed empty application shells.
- Tokens/components approved.
- Database migration runs from empty.

### Week 2 — authentication, roles, organisations, authorization

- Sign-up/login/recovery/email verification.
- User, role, organisation, membership schemas.
- Guardian relationship and consent schema foundation.
- Session handling and protected routes.
- Central authorization functions.
- Initial RLS/grant policies and tests.
- Player/recruiter/admin navigation.
- MFA setup for admin accounts.

Exit:

- Test accounts enter correct role experience.
- Forbidden cross-role access tests pass.

### Week 3 — guardian/minor and adult onboarding

- Player/guardian entry choice.
- Birth-date gate and minor/adult branching.
- Guardian/player relationship workflow.
- Consent records and privacy choices.
- Adult player verification foundation.
- Autosave draft infrastructure.
- Admin view of onboarding status.

Exit:

- Guardian can create a minor draft.
- Adult can create own draft.
- Age-boundary tests pass.

### Week 4 — player profile and visibility

- Profile stepper and required fields.
- Football identity, history, affiliation, opportunity/availability.
- Profile completeness.
- Recruiter-view preview.
- Visibility projection/public-versus-private separation.
- Submission/version/review state machine.
- Admin profile review and changes requested.

Exit:

- Complete profile submission and review loop works without video.

### Week 5 — documents, photos, verification, academy validation

- Private photo/document upload.
- File validation and signed access.
- Player/guardian verification queue.
- Claim-level verification and source/date.
- Academy invited organisation and affiliation validation.
- Admin audit events.
- Data/document retention status fields.

Exit:

- Approved profile can publish to synthetic verified marketplace.

### Week 6 — video pipeline

- Mux direct-upload session.
- Resumable upload UI.
- Video metadata/context.
- Signed and verified webhook processing.
- Signed playback.
- Media library states.
- Admin media review.
- Failure, retry, replace, and delete.
- Usage/cost instrumentation.

Exit:

- Mobile browser uploads, processes, reviews, and privately plays video.

### Week 7 — feed, search, reactions, shortlists

- Feed candidate/visibility query.
- Transparent scoring and exploration allocation.
- Mobile vertical feed and desktop layout.
- Applause, professional interest, pass, report.
- Search and filters.
- Player full profile.
- Shortlist creation, entries, notes, status.
- Impression and video-view analytics.

Exit:

- Verified recruiter can discover and shortlist published players.

### Week 8 — recruiter verification and briefs

- Recruiter onboarding and types.
- Identity/professional evidence.
- Organisation/role/reference fields.
- Conduct and introduction acknowledgement.
- Recruiter admin queue and case.
- Verification expiry/scope.
- Preferences and recruitment brief CRUD/state.
- Matching Briefs feed/reason labels.

Exit:

- Unverified recruiter cannot access players.
- Approved recruiter can activate a brief and see matches.

### Week 9 — meeting and opportunity workflow

- Meeting request form.
- Platform review and changes.
- Guardian/adult response.
- Scheduling, attendees, representative, reminders foundation.
- Meeting event timeline.
- Completed/outcome/follow-up/unsafe states.
- Platform operations board.
- Introduction acknowledgement and audit.

Exit:

- Recruiter-to-meeting-to-outcome loop works end to end.

### Week 10 — reports, notifications, operations, completeness

- Reports and blocking/restriction.
- Safeguarding case routing.
- In-app notifications.
- Transactional email templates/events.
- Background outbox/jobs and retries.
- Availability/reverification reminders.
- Operations overview.
- Users/organisations search.
- Pilot funnel analytics.
- All empty/error/loading/expired states.
- Final responsive and RTL coverage.

Exit:

- Feature complete. No new features accepted after this point.

### Week 11 — security and correctness

- Full role/relationship/age permission matrix.
- RLS/grant tests.
- API/file/upload rate limits.
- Secure headers/CSP/CSRF/session review.
- Webhook replay/idempotency tests.
- Sensitive log/error scrub.
- Dependency and secret scanning.
- Admin step-up access and audit review.
- Threat-model review and fixes.
- Backup restoration and credential-rotation drill.

Business/legal parallel work:

- privacy/consent review;
- pilot agreements;
- safeguarding and incident procedure;
- vendor/data-processing review.

Exit:

- No known critical/high access-control or data-exposure issue.

### Week 12 — usability, accessibility, devices, pilot rehearsal

- Playwright critical journey suite.
- Five guardian/player and five recruiter usability sessions with test data.
- Arabic/English/RTL review.
- Android Chrome, iPhone Safari, desktop Chrome/Edge.
- WCAG critical review.
- Performance and slow-network checks.
- Operational rehearsal: verification, report, unsafe meeting, user removal, video failure.
- Fix pilot-blocking bugs.
- Support/runbook/operator training.
- Release checklist and first cohort invitation procedure.

Exit:

- Pilot-ready release tagged and deployed.

## 4. Parallel nontechnical work

The business founder must prevent engineering from waiting for market inputs.

### Weeks 1–2

- Three real recruiter briefs.
- Academy and recruiter terminology review.
- First visual/content feedback.
- Safeguarding lead identified.

### Weeks 3–5

- Three founding academy commitments.
- First 50-player pipeline.
- Recruiter verification evidence standard tested.
- Guardian/player interviews.

### Weeks 6–8

- Recruiter design partners verified manually.
- Video/evidence collection process rehearsed off-platform.
- Meeting procedure drafted.
- Arabic/English field content reviewed.

### Weeks 9–10

- Pilot users selected.
- Legal/safeguarding review inputs assembled.
- Operator responsibilities assigned.
- Test meeting rehearsal.

### Weeks 11–12

- Minimum release documentation completed.
- Guardians/academies/recruiters briefed.
- Initial profiles staged only after approval.
- Support schedule ready.

## 5. Work method

### Weekly rhythm

- Monday: confirm week's acceptance criteria.
- Daily: small vertical feature increments, tests included.
- Wednesday: internal demo and unblock decisions.
- Friday: production-like demo, retrospective, scope/risk update.

### Development rule

Build vertical slices:

`database → authorization → API/service → UI states → tests → audit/analytics`

Do not build all database tables, then all APIs, then all screens. Each weekly feature should work end to end.

### Pull-request rule for a solo developer

- Short-lived feature branch.
- Small PR with checklist and screenshots.
- Automated checks.
- Self-review after a short context break.
- Merge only when acceptance criteria pass.

### Decision rule

- Reversible decisions: decide quickly and document.
- Permission, privacy, data model, or provider decisions: short written ADR.
- New feature request during build: add to post-MVP list, not current sprint.

## 6. Scope protection

If delivery risk appears, cut in this exact order:

1. Academy self-service screens; operator handles validation.
2. Advanced analytics charts; retain raw funnel events and simple counts.
3. Feed tabs beyond For You, Matching Briefs, and Shortlisted.
4. Adult public teaser pages; keep marketplace-only.
5. In-product structured questions on meetings; operator coordinates changes.
6. PWA installation polish; responsive web still works.

Never cut:

- guardian control and consent;
- recruiter verification;
- exact authorization and tests;
- private media/documents;
- profile/video review;
- feed/search/shortlist core;
- meeting review and platform attendance workflow;
- reporting/safeguarding;
- admin operations;
- audit, backup, and recovery.

## 7. Timeline assumptions and risk

Twelve weeks assumes:

- full-time development;
- timely design/product decisions;
- no custom video infrastructure;
- no major vendor/legal blocker;
- business founder owns nontechnical work;
- no scope expansion.

If development is part-time, convert the plan by available focused hours. At approximately 20 hours/week, expect roughly 20–24 calendar weeks even with the same scope.

## 8. Progress reporting

Track weekly:

- planned versus accepted stories;
- critical-flow completion;
- open blocker count and age;
- permission/security test coverage;
- pilot-blocking bug count;
- mobile/RTL screens completed;
- vendor usage/cost;
- academy/recruiter/player readiness dependencies.

Do not report percentage complete based on code or screen count. Report completed user journeys.

