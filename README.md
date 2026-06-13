# RemoteRecruit — iOS

A job-browser app for iOS. Browse remote-first engineering roles, search by title or
company, and view full job details. Built with SwiftUI and a Clean-Architecture / MVVM
setup, talking to the companion [RemoteRecruit backend](https://github.com/workshubham/RemoteRecruit-Backend).

| | |
|---|---|
| Language | Swift 5 |
| UI | SwiftUI |
| Concurrency | async/await + Observation (`@Observable`) |
| Min iOS | 26.4 |
| Tests | Swift Testing |

## Screens

- **Job list** — branded header, a sticky "Latest jobs" bar with a sort menu, and job
  cards (company logo tile, title, location, type chips, salary, level). Infinite scroll.
- **Search** — full-screen, debounced search by title or company, with suggestion chips
  and a no-results state.
- **Job details** — hero, salary card, "About the role", "What you'll do", a company card
  (size / industry / founded), Share, and an Apply button that becomes "Applied".
- **States** — every screen handles loading (shimmer skeletons), empty, and error (retry),
  plus light and dark mode and a short branded splash on launch.

## Getting started

You'll need Xcode 26+.

1. **Start the backend** (the app reads from it on `http://localhost:4000`):
   ```bash
   cd ../RemoteRecruit-Backend
   npm install
   npm run dev
   ```
2. **Open and run the app:**
   ```bash
   open RemoteRecruit.xcodeproj
   ```
   Pick an iPhone simulator and hit Run. The simulator reaches the Mac's `localhost`
   directly, so no extra setup is needed.

The base URL isn't hardcoded — it comes from the build configuration (see below). The
Debug config points at `http://localhost:4000`.

## Architecture

Clean Architecture with three layers and a thin shared core, mirroring how a larger app
would be organised so it stays maintainable as it grows.

```
Domain        models (Job, JobSummary…) + the JobRepository protocol
Data          networking, DTOs + mapping, the repository implementation
Presentation  SwiftUI screens, each with an @Observable ViewModel (MVVM)
Core          design system (theme/components) + small extensions
```

The flow for a screen is: **View → ViewModel → JobRepository → HTTPClient → API**, with
DTOs mapped to domain models in the Data layer.

A few decisions worth calling out:

- **The ViewModels depend on the `JobRepository` *protocol*, not the concrete class.** The
  real implementation calls the API; tests inject a `MockJobRepository`. That's what makes
  the business logic easy to test in isolation.
- **Dependency injection is constructor-based.** ViewModels take their repository via
  `init` (defaulted to the live one). The networking client is a shared instance built
  from the active environment. There's no big DI container — for an app this size it would
  be over-engineering.
- **Networking is protocol-based** (`HTTPClient` + `URLSessionHTTPClient`), with requests
  described by a small `APIRequest` value and endpoints built in one place
  (`JobEndpoint`). Status codes map to a typed `RRNetworkError`.
- **The design system is centralised** (`Theme`, `RRChip`, `CompanyLogoView`, shimmer,
  status views) so the look stays consistent and light/dark is handled in one place.

### Folder layout

```
RemoteRecruit/
  App/                 entry point + RootView (splash → list)
  Core/
    DesignSystem/      Theme, Spacing, components (RRChip, CompanyLogoView, Shimmer…)
    Extensions/        Color+Hex, Date+TimeAgo, SalaryRange+Formatting
  Domain/
    Models/            Job, JobSummary, JobPage, enums
    Repositories/      JobRepository (protocol)
  Data/
    Services/Network/  HTTPClient, URLSessionHTTPClient, APIRequest, errors, env
    Jobs/              JobEndpoint, JobDTOs (+ mapping), JobRepositoryImpl
    Applications/      AppliedJobsStore (UserDefaults)
  Presentation/
    Modules/JobList | Search | JobDetail | Splash   (View + ViewModel each)
  SupportingFiles/     Info.plist, Launch Screen, BuildConfiguration (xcconfig)
```

## Environment configuration

The base URL is driven by xcconfig files, not hardcoded:

- `SupportingFiles/BuildConfiguration/Local.xcconfig` (Debug) → `http://localhost:4000`
- `SupportingFiles/BuildConfiguration/Common.xcconfig` (Release) → production placeholder

Each xcconfig sets `API_URL`, which flows into `Info.plist` and is read at runtime by
`APIConstants`. To point the app at a different backend, just change `API_URL` in the
relevant xcconfig — no code changes. (A localhost ATS exception is set in `Info.plist` so
the Debug build can talk to the local HTTP server.)

## Testing

```bash
xcodebuild test -scheme RemoteRecruit \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

Tests use **Swift Testing** with a `MockJobRepository`, covering the business logic:

- `JobListViewModelTests` — load → loaded/empty/error, pagination, sort forwarding
- `SearchViewModelTests` — search results, no-match, empty query, errors
- `JobDetailViewModelTests` — load success/error, apply marks applied
- `JobMappingTests` — DTO → domain mapping, including unknown-enum fallbacks
- `AppliedJobsStoreTests` — persistence across instances
- `SalaryFormattingTests` — salary/currency formatting

Coverage on the ViewModels / mapping / services is ~90% (well above the 70% target).

## Assumptions

- The app talks to the companion mock backend (a real `/api/jobs` API), not a hardcoded
  JSON file — so list, search, sort and pagination all go over the network.
- Company "logos" are coloured initials tiles using a brand colour from the API, matching
  the design (no remote image hosting needed).
- **Apply** is a local, self-contained feature — there's no real apply endpoint, so the
  applied state is stored on-device (UserDefaults) and persists across launches.
- Salaries are formatted client-side from structured `{ min, max, currency, period }`
  values, so currency/locale presentation lives in the app.
- The list shows a slim summary; the full description, responsibilities and company info
  are fetched only when you open a job.
```
