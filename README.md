# ScoutLink

ScoutLink is an Egypt-first football talent discovery and facilitated recruitment platform. It helps ambitious young players present credible football profiles and focused match footage, while recruiters discover talent and request safe, platform-facilitated meetings.

> **Status:** MVP development. Authentication and Player/Scout onboarding are
> implemented and hardened, but public registration remains disabled until the
> production API, SMTP delivery, store signing, and safeguarding approval are in place.

## Product direction

- Players and guardians use the mobile app for profiles, highlights, consent, and opportunities.
- Recruiters use the same mobile app for discovery, filters, shortlists, professional interest, and meeting requests.
- Platform staff verify participants, moderate content, protect minors, and attend every arranged meeting.
- The pilot targets 50 boys aged 12–19 in Egypt, while verified recruiters may participate globally.
- The initial pilot is free for both players and recruiters.

Comments, direct messaging, follower counts, paid boosts, payments, and automated deal execution are deliberately outside the MVP.

## Safeguarding principles

- Recruiters cannot directly contact minors.
- Guardian relationships and consent are first-class product data.
- Meetings remain inside a platform-managed workflow and include a ScoutLink representative.
- Sensitive photos, documents, and videos are private and served through short-lived access.
- Development and testing use synthetic data only.

## Architecture

```text
Flutter Android / iOS app
            |
       FastAPI REST API
       /       |       \
PostgreSQL  Storage    Mux video
       |
Python background worker

Static public marketing site -> CDN
```

The MVP ships as one Flutter mobile app. Initial onboarding exposes Player and
Scout roles; other role types remain backend foundations for later milestones.
Android is the pilot target and iOS follows from the same codebase. FastAPI is
the only gateway to business data and authorization.

## Applications

- `apps/product_flutter` — responsive product for players, guardians, recruiters, and staff.
- `apps/api` — FastAPI modular-monolith backend.
- `apps/worker` — background processing entry point.
- `apps/marketing` — public semantic HTML/CSS website.
- `infra` — local containers and deployment foundations.

The authoritative documents are listed in [`SPEC_INDEX.md`](./SPEC_INDEX.md).

Key documents:

- [`MVP_PRODUCT_SPEC_V1.md`](./MVP_PRODUCT_SPEC_V1.md) — authoritative MVP scope.
- [`USER_FLOWS_V1.md`](./USER_FLOWS_V1.md) — player, guardian, recruiter, and operations flows.
- [`DESIGN_AND_SCREENS_V1.md`](./DESIGN_AND_SCREENS_V1.md) — visual system and screen inventory.
- [`TECHNICAL_SPEC_V2.md`](./TECHNICAL_SPEC_V2.md) — Flutter/FastAPI technical architecture.
- [`BUILD_PLAN_V1.md`](./BUILD_PLAN_V1.md) — 12-week implementation plan.

## Current foundation

- Responsive role-aware Flutter shell with custom ScoutLink theme.
- FastAPI application with versioned routing and health endpoints.
- Async SQLAlchemy/PostgreSQL configuration and Alembic foundation.
- Background worker entry point.
- Docker Compose local environment.
- Static marketing-site foundation.
- Automated Python and Flutter checks through GitHub Actions.

## First run

```powershell
Copy-Item .env.example .env
uv sync --all-packages
docker compose up -d db
uv run --package scoutlink-api alembic -c apps/api/alembic.ini upgrade head
uv run --package scoutlink-api uvicorn scoutlink_api.main:app --reload --port 8000
```

Then run Flutter:

```powershell
Set-Location apps/product_flutter
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1
```

Authentication also requires the public Supabase client configuration. On the
Android emulator, use `10.0.2.2` to reach the API running on the host machine:

```powershell
flutter run `
  --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1 `
  --dart-define=SUPABASE_URL=https://hcdbpescehokdvendcxs.supabase.co `
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY
```

Magic links return to `com.scoutlink.app://login-callback/`. Configure
`SCOUTLINK_SUPABASE_JWT_ISSUER` and `SCOUTLINK_SUPABASE_JWKS_URL` for the API.
Secret/service-role keys must never be included in Flutter builds.

Product tables live in the private `app` PostgreSQL schema. In the Supabase
Table Editor, change the schema selector from `public` to `app` to inspect
`users`, `players`, `recruiter_profiles`, and the supporting identity tables.
Keeping these tables outside `public` prevents the mobile client from bypassing
the FastAPI authorization layer.

Unfinished onboarding data is encrypted in device secure storage. Player profile
photos use the private `profile-images` bucket, a 5 MB limit, and owner-only
Storage policies. No profile-image bucket should be made public.

For Android release builds, create a private upload keystore and an ignored
`apps/product_flutter/android/key.properties`. The project deliberately produces
an unsigned release when that owner-controlled file is absent; it never falls
back to a debug signing key.

See [`PRODUCTION_READINESS.md`](./PRODUCTION_READINESS.md) before enabling public
registration or installing a release build outside the development team.

API docs: `http://localhost:8000/docs`. Liveness: `http://localhost:8000/api/v1/health/live`.

## Quality checks

```powershell
uv run ruff check .
uv run ruff format --check .
uv run pytest
Set-Location apps/product_flutter
flutter analyze
flutter test
flutter build apk --debug
```

Never put credentials or real player/minor data in this repository. Use synthetic local data only.

## Roadmap

The next milestone begins only after the external production-readiness gates are
complete. Player profiles, discovery, highlights, and meetings build on this
identity and authorization layer.

## Contributing and licensing

This is an early-stage product repository. Contribution guidelines and an explicit software license have not yet been selected. Public visibility does not grant permission to reuse the code beyond rights provided by applicable law.
