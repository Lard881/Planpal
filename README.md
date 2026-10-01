# PlanPal Flutter App

Comprehensive task and team productivity application for Android and Windows (iOS/macOS support coming later).

## Tech Stack

- **Flutter** 3.24+
- **Riverpod** - State management
- **go_router** - Navigation
- **Drift** - Local database (offline-first)
- **Supabase** - Backend, auth, realtime
- **Firebase** - Push notifications

## Features

- ✅ **Offline-first** - Full offline capability with automatic sync
- ✅ **Multi-language** - English, Spanish, French, Chinese, Korean
- ✅ **Multi-theme** - Light, Dark, System
- ✅ **Multi-platform** - Android, Windows (iOS/macOS later)
- ✅ **Real-time** - Live updates via Supabase Realtime
- ✅ **Secure** - End-to-end encryption for sensitive data

## Project Structure

```
lib/
├── core/
│   ├── config/       # Environment & configuration
│   ├── theme/        # Colors, themes, design tokens
│   ├── l10n/         # Localization (ARB files)
│   ├── router/       # Navigation & routing
│   ├── network/      # API client, connectivity
│   ├── errors/       # Error handling & failures
│   ├── db/           # Drift local database
│   ├── sync/         # Offline sync engine
│   ├── layout/       # Responsive layout utilities
│   ├── widgets/      # Shared components
│   └── utils/        # Utilities & helpers
└── features/
    ├── auth/         # Authentication
    ├── workspace/    # Workspaces & teams
    ├── home/         # Home dashboard
    ├── tasks/        # Task management
    ├── calendar/     # Calendar & events
    ├── chat/         # Real-time messaging
    ├── documents/    # Documents & files
    ├── analytics/    # Productivity analytics
    ├── team/         # Team directory
    ├── search/       # Global search
    ├── notifications/# Notifications & push
    └── settings/     # Settings & preferences
```

## Getting Started

### Prerequisites

- Flutter SDK 3.24 or higher
- Android Studio / VS Code
- For Windows: Visual Studio 2022 with Desktop development workload

### Installation

```bash
# Get dependencies
flutter pub get

# Generate code (localization, freezed, riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# Run on Android
flutter run -d android

# Run on Windows
flutter run -d windows
```

### Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Windows
flutter build windows --release
```

## Configuration

Environment variables are passed via `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=API_BASE_URL=https://your-api.com
```

Or use `.vscode/launch.json` for development.

## Development Stages

See `docs/04-task-stages.md` for the complete development roadmap.

**Current Status:** Stage 3 - Flutter Foundation

## Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widgets

# Run integration tests
flutter test integration_test
```

## Code Generation

This project uses code generation for:
- **Localization** (ARB → Dart)
- **Riverpod** (providers)
- **Freezed** (data classes)
- **JSON Serialization**
- **Drift** (database)

Run whenever you modify these:
```bash
flutter pub run build_runner watch
```

## Contributing

Follow the style guide in `docs/` and run:
```bash
flutter analyze
flutter format lib/
```

## License

MIT
