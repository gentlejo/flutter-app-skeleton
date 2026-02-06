# Service Skeleton Template

Monorepo template for building services with a Flutter client and a backend.

## Structure
```
app/          # Flutter client (skeleton with optional features)
backend/      # Backend server (empty — initialized per project)
.claude/      # Claude Code project config
```

## App (Flutter Client)

The `app/` directory contains a Flutter skeleton template. It includes only Dart source files — platform files are generated fresh by `flutter create` during initialization.

### How to Initialize

1. Copy this template to a new directory
2. Open Claude Code in the directory
3. Run `/project:init`
4. Follow the interactive prompts (package name, display name, bundle ID, optional features)

The init command will:
- Run `flutter create` in `app/` to generate platform files for your Flutter version
- Patch configs (pubspec.yaml, build.gradle, Info.plist, etc.)
- Add Firebase, optional feature dependencies
- Remove unselected features
- Optionally run `flutterfire configure`

### Template Structure (pre-init)
```
app/
├── lib/
│   ├── main.dart              # Default entry (→ main_dev)
│   ├── main_dev.dart          # Dev environment entry
│   ├── main_prod.dart         # Prod environment entry
│   ├── initialize.dart        # Service initialization
│   ├── app.dart               # Root MaterialApp widget
│   ├── common/
│   │   └── config.dart        # Environment config (dev/prod)
│   ├── config/
│   │   └── firebase_options.dart  # Placeholder (replaced by flutterfire)
│   ├── screens/
│   │   └── home_screen.dart   # Home screen placeholder
│   ├── services/              # Optional service singletons
│   │   ├── notification_service.dart
│   │   ├── admob_service.dart
│   │   ├── purchase_service.dart
│   │   └── att_service.dart
│   └── features/
│       └── deep_linking.dart  # Optional deep linking
├── .gitignore                 # Flutter-specific ignores
└── .vscode/
    └── launch.json            # Flutter launch configurations
```

No `android/`, `ios/`, `pubspec.yaml` in `app/` — these are generated fresh by `/project:init`.

### Optional Features
Features are wrapped in `// --- OPTIONAL: key ---` markers. During init, unselected features are cleanly removed (code blocks + service files + dependencies).

| Feature | Key | File |
|---------|-----|------|
| Push Notifications | `push_notifications` | `app/lib/services/notification_service.dart` |
| AdMob | `admob` | `app/lib/services/admob_service.dart` |
| In-App Purchases | `in_app_purchases` | `app/lib/services/purchase_service.dart` |
| App Tracking (ATT) | `app_tracking` | `app/lib/services/att_service.dart` |
| Deep Linking | `deep_linking` | `app/lib/features/deep_linking.dart` |

### Conventions
- Services: singleton pattern with `ClassName.instance`
- Config: `Config.xxx` static getters (set environment in main_*.dart)
- Firebase: configured via `flutterfire configure` CLI — do NOT edit manually

## Backend

The `backend/` directory is intentionally empty. It will be initialized separately based on the backend technology chosen for each project (e.g., Node.js, Python, Go, etc.).
