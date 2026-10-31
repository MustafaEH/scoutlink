# ScoutLink mobile app

The shared Flutter application for players, guardians, recruiters, academy
representatives, and ScoutLink staff. Android is the initial pilot target.

## Run locally

Start the FastAPI service from the repository root, then run an Android emulator:

```powershell
flutter run `
  --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1 `
  --dart-define=SUPABASE_URL=https://hcdbpescehokdvendcxs.supabase.co `
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY
```

The public mobile callback is `com.scoutlink.app://login-callback/`. Never add a
Supabase secret or service-role key to this app.
