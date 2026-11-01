# SL-001: Player profile basics and football identity draft

- Status: Ready
- Owner: Mustafa + Codex
- Branch: `codex/sl-001-player-profile-basics`
- Product milestone: Week 4 - player profile and visibility
- QA report: `docs/qa/SL-001-qa.md`

## Outcome and business value

Replace the fake Player profile-readiness experience with the first usable,
server-backed profile slice. An authenticated Player can view, edit, save, leave,
and resume the Basics and Football Identity sections. This creates the trusted
structured data that later profile history, evidence, recruiter discovery, and
meeting features depend on.

This ticket remains a private draft experience. It must not publish a player,
expose the profile to Scouts, or accept real minor data during development.

## Current state

- Supabase magic-link authentication, persistent sessions, and safe logout are merged.
- Player/Scout onboarding collects account name, username, email, birth date,
  main position, preferred foot, and an optional private profile photo.
- FastAPI can complete onboarding but has no dedicated Player profile read/update API.
- The Player dashboard shows a hard-coded `62%` readiness value and its Profile
  destination does not change the body.
- Verified builds use a temporary placeholder while `IDENTITY_API_ENABLED=false`.
- Product tables remain in the private `app` schema behind FastAPI.

## User flow

```text
Authenticated Player home
-> See real Basics readiness and exact missing items
-> Open Profile
-> Basics: legal/display identity, nationality, governorate, height
-> Save and continue
-> Football identity: dominant foot, primary/secondary positions, languages,
   playing-style biography
-> Save
-> Leave or close the app
-> Return to the same persisted server-backed draft
```

The screen always shows `Unsaved`, `Saving`, `Saved`, or a recoverable error.
Valid local edits are encrypted on-device until the API confirms them, then the
local copy is cleared.

## In scope

- Self-managed accounts with the `player` role.
- A role-protected FastAPI endpoint to read the current Player's private draft.
- A role-protected partial-update endpoint with stable validation error codes.
- Basics fields:
  - private legal name;
  - recruiter-facing display name;
  - nationality code, default `EG` for the pilot;
  - Egyptian governorate code;
  - height in centimetres.
- Football Identity fields:
  - dominant foot: `left`, `right`, or `both`;
  - one primary and up to two distinct secondary position codes;
  - at least one language code;
  - playing-style biography.
- Structured position and language persistence suitable for later filtering.
- Real Basics readiness percentage and exact blocking items on Player Home.
- A two-step adaptive Flutter editor using the existing theme and clean
  domain/data/application/presentation boundaries.
- Encrypted device recovery for edits not yet acknowledged by the API.
- Loading, empty, validation, offline, retry, and successful-save states.
- Backend, Riverpod/controller, widget, and account-isolation tests.

## Non-goals

- Guardian-managed minor onboarding or consent.
- Team/academy history, opportunity status, availability, videos, documents, or badges.
- Profile preview, submission, review, approval, publication, or expiration.
- Scout/recruiter access to any Player profile data.
- Profile-photo replacement or signed photo display.
- Public teaser pages, discovery, search, applause, interest, or meetings.
- Production API deployment or changing `IDENTITY_API_ENABLED` globally.
- Deep links beyond the existing authentication callback.
- Legal/consent copy or collection of real pilot/minor data.

## UI, API, and data changes

### Flutter

- Add `features/player_profile/{domain,data,application,presentation}`.
- Player Home derives readiness from profile data; remove the hard-coded `62%`.
- The Profile navigation destination opens the two-step editor. Scout and future
  roles retain their existing placeholder experience.
- Reuse the global theme; no feature-level brand colours or date/input themes.
- Keep the current simple root navigation. Do not reintroduce `go_router` until
  a non-auth external deep link or nested route makes it necessary.
- Enable this flow only when the identity API build flag is enabled. With the
  flag disabled, the current verified-user placeholder remains unchanged.

### FastAPI

- Add a dedicated Player profile module or clearly separated Player-profile
  service, schemas, and routes rather than expanding transport logic in identity routes.
- Add:
  - `GET /api/v1/players/me/profile`
  - `PATCH /api/v1/players/me/profile`
- Both endpoints require an active authenticated user with the `player` role and
  resolve the Player by `account_user_id`; a client cannot supply another Player ID.
- PATCH accepts only documented profile fields, trims strings, validates codes,
  and returns the complete private draft plus readiness data.
- Error envelopes use stable codes such as `player_role_required`,
  `player_profile_not_found`, `invalid_position`, `invalid_governorate`, and
  `invalid_profile_field`.

### PostgreSQL/Alembic

- Add private Player profile fields needed by this slice, keeping account-holder
  identity separate from Player legal/display identity.
- Add normalized Player position and language tables with uniqueness constraints.
- Migrate the existing onboarding position/foot values without losing data.
- Constrain height to `100..230` cm, position priority to primary plus at most two
  secondary entries, and language/position codes to supported values.
- Add `updated_at` for optimistic conflict awareness; the API returns it.
- The migration must upgrade from `0003_profile_images` and include a working downgrade.

### Initial controlled vocabularies

- Position codes map to the existing eight choices: `GK`, `CB`, `FB`, `DM`,
  `CM`, `AM`, `W`, and `ST`.
- Governorates use stable internal codes for Egypt's 27 governorates while UI
  copy remains human-readable.
- Languages initially support `ar` and `en`; the data model must allow more codes
  without a schema migration.

## Security, privacy, and safeguarding

- Flutter never reads or writes business tables through the Supabase Data API.
- Legal name, birth date, email, and unsaved drafts never appear in logs,
  analytics, error text, or a recruiter-facing model.
- API authorization derives account and role exclusively from the verified JWT
  and database relationships.
- Cross-account reads/updates and Scout-role calls return a non-disclosing error.
- Logout clears the user-scoped encrypted recovery draft.
- No endpoint introduced by this ticket lists Players or exposes a public profile.
- Use synthetic test identities only. Under-18 profiles remain private drafts;
  guardian consent and publication are separate release blockers.

## Edge cases and failure recovery

- Missing Player row after authentication: show a recoverable account-setup error,
  never an infinite spinner.
- API unavailable or timeout: preserve valid edits locally and provide retry.
- App killed during editing or saving: restore the user-scoped local draft.
- Logout/account switch: one account must never see another account's local draft.
- Duplicate positions, more than two secondary positions, unsupported codes,
  whitespace-only biography, and out-of-range height are rejected consistently.
- A late failed response must not overwrite a newer local edit.
- Repeated identical PATCH requests are safe and return the same effective state.
- Existing onboarding values map to the controlled vocabulary or produce an
  explicit blocking item without discarding the original value.
- Small-screen keyboard and system Back behavior preserve valid input.

## Acceptance criteria

- [ ] With `IDENTITY_API_ENABLED=true`, an authenticated Player reaches Player
      Home without the temporary placeholder; a Scout does not enter Player Profile.
- [ ] Player Home displays a readiness value calculated from persisted Basics and
      Football Identity fields, with an exact list of missing required items.
- [ ] Selecting Profile shows a two-step editor that remains usable at 320x568,
      with visible Back, save state, required labels, and keyboard-safe scrolling.
- [ ] The current Player can load only their own private profile through FastAPI.
- [ ] Saving valid fields persists them in PostgreSQL and a fresh app/provider
      load returns the same normalized values.
- [ ] Legal name is stored separately from display name and is never included in
      any recruiter/public response model introduced by this ticket.
- [ ] Primary position is required; up to two distinct secondary positions are
      accepted; duplicates and unsupported codes return a stable validation error.
- [ ] Height outside `100..230`, an empty/whitespace biography, unsupported foot,
      language, nationality, or governorate values cannot be saved.
- [ ] Valid unsaved edits survive an app restart in encrypted storage and are
      cleared after confirmed save or logout.
- [ ] Offline, timeout, and server-error states keep input, stop loading, explain
      the problem, and expose a working retry action.
- [ ] Scout, unauthenticated, and different-account requests cannot read or alter
      a Player profile; automated tests prove these boundaries.
- [ ] Existing onboarding position and foot data survives migration and is shown
      in the new profile draft when it maps to a supported code.
- [ ] No player profile becomes discoverable, published, or recruiter-visible.
- [ ] Flutter formatting, analysis, tests, and debug Android build pass.
- [ ] Python formatting, Ruff, backend tests, migration upgrade/downgrade checks,
      and Alembic single-head verification pass.
- [ ] Real-device testing covers save, restart/resume, offline retry, logout, and
      account switching with synthetic accounts.

## Test plan

### Backend

- Unit tests for readiness calculation, vocabulary mapping, normalization, and validation.
- API tests for get/update success, partial updates, repeated updates, missing
  profile, wrong role, missing JWT, and cross-account isolation.
- Migration test from onboarding data through upgrade and downgrade.
- Verify one Alembic head and database constraints independently of Pydantic.

### Flutter

- Controller tests for initial load, dirty state, saving, stale responses,
  retry, local recovery, confirmed-save cleanup, and logout/account isolation.
- Widget tests for both steps, validation, readiness/blocking items, 320x568,
  keyboard scrolling, Back behavior, and semantic labels.
- Repository tests for normalized API payloads and stable error mapping.

### Manual/real device

- Complete and edit a synthetic Player profile.
- Force-stop and reopen before and after a confirmed save.
- Disable connectivity during save, reconnect, and retry.
- Logout and sign into a second synthetic account; confirm no data leakage.

## Dependencies and open decisions

- Code implementation can start against local/test FastAPI and PostgreSQL.
- GitHub Actions is currently blocked by an account billing lock. Local checks
  are required during implementation, but this ticket cannot move to `Done`
  until CI runs and passes or the user explicitly changes the release gate.
- Production API hosting is not required for implementation, but a real-device
  end-to-end pass needs a reachable test API or an approved USB reverse setup.
- The authoritative specs describe guardian-controlled minors aged 12-17 and
  self-managed adults aged 18-19, while the current app accepts self-onboarding
  ages 6-23. SL-001 does not change eligibility; all profiles remain private
  drafts. Resolve age/guardian eligibility before pilot data is accepted.
- The technical specification names `go_router`, while the current code removed
  it for a single-root app. SL-001 keeps that simplification; revisit routing
  when a real nested/deep-link use case arrives.

## Rollout or migration notes

- Ship behind the existing `IDENTITY_API_ENABLED` compile-time flag.
- Apply the new migration before enabling the flag in any shared environment.
- Backfill current onboarding position/foot data transactionally.
- Do not delete the temporary placeholder until Player and Scout authenticated
  destinations both have an intentional result.
- No production or pilot data migration is authorized by this ticket.

## Definition of done

- [ ] Acceptance criteria demonstrated.
- [ ] Automated checks pass locally and in GitHub Actions.
- [ ] `$scoutlink-red-team-qa` report has no open P0/P1 defects.
- [ ] Documentation, API contract, and migrations are current.
- [ ] Focused commits are pushed to `codex/sl-001-player-profile-basics`.
- [ ] Ticket status is `Done` only after real-device evidence is recorded.

