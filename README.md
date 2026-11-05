# CareTrack mobile

Flutter app for Android and iOS on top of the CareTrack Spring Boot API. It uses the same stack as the e-Clinic mobile app: Riverpod 3, go_router, Dio, flutter_secure_storage and shared_preferences. Sign-in uses `flutter_appauth` (OIDC authorization code + PKCE in the system browser).

Patients get:

- overview (counts, next visit, its cancellation window and journey)
- a four-step booking wizard
- booking requests (withdraw)
- appointments (cancel with a reason while the window is open)

Staff (every account type except patient) get the screens their selected hospital grants:

- **Booking queue** (`BOOKING:READ_ALL`): waiting requests, oldest first; confirm or decline with a reason when `BOOKING:CONFIRM` is granted. Confirm sends a retry-safe `Idempotency-Key`.
- **Appointments desk** (`APPOINTMENT:READ_ALL`): check in with the identity check used, record "did not arrive", close as "not seen". Each button shows only inside the server's time window.
- **Shifts** (`SHIFT:WRITE`): add a doctor's or nurse's shift (date picker, Morning / Day / Evening / Night quick starts or the time picker, length, live preview), filter by person, remove before it starts.

Everywhere: hospital switcher, light and dark theme, pull to refresh and load more.

## Layout (layer-first, one class per file)

```text
lib/
├── config/        app_config (--dart-define), auth_config, endpoints, routes/, theme/
├── constants/     texts/, scheduling, motion, brand colours, status styles, route paths
├── enums/         care, identity, ui
├── models/        common, care, identity, workforce, ui
├── dtos/          auth, care, common, workforce
├── interfaces/    auth/token_source
├── services/      api (ApiClient), auth (AuthService, TokenStorage), identity, care, workforce
├── middlewares/   auth_interceptor (bearer token, 401 → signed out)
├── controllers/   Riverpod: auth, identity (staff context), care (patient context, care team, paged lists, queue, desk, booking draft, home summary), workforce (shifts), ui
├── utilities/     time, http, text, care, workforce, ui
├── validations/   care
├── widgets/       common (UI kit), care, workforce, layout (patient and staff shells)
└── screens/       auth, patient, staff
```

## UI kit (`widgets/common`)

| Widget | Purpose |
| --- | --- |
| `HeartbeatLoader` | The brand mark over an animated ECG line, shown at start-up. |
| `SkeletonList`, `ShimmerBox` | Shimmering placeholder cards while lists load. |
| `CountdownMeter` | Animated bar that drains as the free-cancellation window runs out; it turns amber in the last quarter. |
| `StepProgress` | Wizard header whose track fills between steps; the current step grows. |
| `StatTile` | Metric card whose number counts up. |
| `Timeline` | Visit journey with staggered entrance. |
| `StatusChip`, `PulseDot` | Tone-coloured status, with a pulsing dot while waiting. |
| `AppButton` | Button that ignores repeat taps, shows a spinner, then briefly a tick. On error it shows a snack and unlocks. |
| `ChoiceCard` | Animated selectable card. |
| `FadeSlideIn` | Staggered list entrance. |
| `EmptyState`, `ErrorState`, `AsyncBody` | Loading, empty and error handling. |
| `PagedList` | Every state of a paged list (skeleton, error, empty, staggered rows, load more) in one widget. |
| `Avatar` | Initials or icon tile at the start of every row and card, in five tones. |
| `showConfirmSheet`, `showReasonSheet`, `AppSnack` | Bottom sheets and floating snacks. |

Every animation is skipped when the system asks for reduced motion.

## Run locally

1. Start the server on port 8080 and the identity provider realm on 8081 (see the web client README).
2. In the realm, create a **public** client `caretrack-mobile`:
   - Standard flow and PKCE (S256)
   - Redirect URIs `com.caretrack.mobile:/oauthredirect` and `com.caretrack.mobile:/signed-out`
   - Each person's token `sub` must match their `app_user.identity_subject`.
3. Android emulator or device: run `adb reverse tcp:8080 tcp:8080` and `adb reverse tcp:8081 tcp:8081`. The app's `localhost` then reaches both, and the token issuer still matches the server's `JWT_ISSUER_URI`.
4. Run `flutter run`. You can override the defaults with `--dart-define=API_URL=…`, `AUTH_ISSUER=…`, `AUTH_CLIENT_ID=…`, `AUTH_ALLOW_HTTP=false`.

Plain `http` is allowed only in **debug** Android builds (`src/debug/AndroidManifest.xml`). Release builds need https.

On Windows, building plugins for Android or desktop needs Developer Mode, which allows symlinks.

## Verification

- `flutter analyze`: no issues.
- `flutter test`: unit tests for utilities (including the desk time windows), validation and model parsing; widget tests for the UI kit; and widget tests that render the queue, desk and shifts screens through the real controllers and services against a fake HTTP server (requests, headers and bodies checked).
- `flutter build web`: compiles. The web build can only show the sign-in screen, because `flutter_appauth` supports Android, iOS and macOS only.
