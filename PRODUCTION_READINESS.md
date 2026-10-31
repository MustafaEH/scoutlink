# Authentication and onboarding release gates

The code-level onboarding feature is designed as four layers:

- `domain` owns immutable onboarding models and steps.
- `data` owns encrypted drafts and private profile-image uploads.
- `application` owns the Riverpod state machine and completion workflow.
- `presentation` owns replaceable themed pages and no business rules.

Feature widgets consume `ThemeData.colorScheme` and component themes. A rebrand
should be implemented in `core/theme/scoutlink_theme.dart`, without editing the
onboarding or home screens.

## Implemented and automatically checked

- New-user Player and Scout onboarding.
- Separate returning-user sign-in.
- Multi-page product promises, role selection, account, profile, and review.
- System Back and visible Back navigation.
- Interrupted-flow restoration using encrypted device storage.
- Exact frontend/backend player age range of 6–23.
- Themed date picker and small-screen scrolling.
- Email resend cooldown and change-email recovery.
- Session restoration, logout, timeout, retry, and username-conflict recovery.
- Private avatar upload with type/size constraints and owner-only policies.
- Idempotent profile completion and database uniqueness-race handling.
- Production configuration validation and disabled API documentation in production.
- Release Internet permission and no Android cloud backup of encrypted drafts.
- Python formatting/linting/tests and Flutter formatting/analysis/widget tests.

## Owner/external gates before public registration

These cannot safely be generated or selected by the repository:

1. Deploy `infra/backend.Dockerfile` to a named HTTPS host and set its secrets.
2. Run `alembic upgrade head` against production before starting the API.
3. Set the Flutter `API_BASE_URL` to that HTTPS API; never ship a LAN address.
4. Configure a custom SMTP provider in Supabase and verify SPF, DKIM, and DMARC.
5. Test signup and returning-user links using controlled Player and Scout inboxes.
6. Create and securely retain the Android upload keystore and `key.properties`.
7. Configure the iOS signing team and associated domains before an iOS release.
8. Add store privacy disclosures, support contact, deletion process, and the
   safeguarding/guardian flow before accepting real minors.
9. Add production error monitoring and an incident-contact destination.
10. Approve final product copy, legal documents, and consent versions.

## Required production environment

The API refuses to start in `production` when required values are missing:

- `SCOUTLINK_ENVIRONMENT=production`
- `SCOUTLINK_DATABASE_URL`
- `SCOUTLINK_SUPABASE_URL`
- `SCOUTLINK_SUPABASE_JWT_ISSUER`
- `SCOUTLINK_SUPABASE_JWKS_URL`

The Flutter release requires compile-time public configuration:

- `API_BASE_URL=https://<api-host>/api/v1`
- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`
- `AUTH_REDIRECT_URL=com.scoutlink.app://login-callback/`
- `IDENTITY_API_ENABLED=true` once the production API is deployed and verified

Until `IDENTITY_API_ENABLED` is enabled, verified users are intentionally routed
to the temporary post-verification placeholder without calling the identity API.

Service-role, database, SMTP, signing, and monitoring secrets must never be
passed to Flutter or committed to Git.

## Release verification

Before each release:

1. Run backend format, lint, and tests.
2. Run Flutter format, analysis, and tests.
3. Build a signed Android App Bundle in release mode.
4. Install the release candidate on a low/mid-range physical Android phone.
5. Complete one new Player signup with photo and one new Scout signup.
6. Sign out and sign back into both accounts.
7. Interrupt onboarding, restart, and verify secure restoration.
8. Exercise expired link, offline API, duplicate username, resend, and image
   failure paths.
9. Confirm the Storage bucket remains private and the four owner policies exist.
10. Confirm `/health/ready` succeeds and production API docs are unavailable.
