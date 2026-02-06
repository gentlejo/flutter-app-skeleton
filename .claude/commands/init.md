# Project Initialization

Initialize this skeleton template into a real Flutter project. This template contains only Dart source files — platform files (android/, ios/, pubspec.yaml, etc.) are generated fresh by `flutter create` to match the user's current Flutter SDK version.

Follow these steps exactly in order.

---

## Step 1: Gather Project Information

Use AskUserQuestion to collect ALL of the following at once (4 questions):

**Question 1: Dart Package Name**
- Header: "Package"
- Question: "What is the Dart package name? (snake_case, e.g., my_app)"
- Options: "my_app", "cool_project"

**Question 2: App Display Name**
- Header: "Display Name"
- Question: "What is the app display name? (shown to users, e.g., My App)"
- Options: "My App", "Cool Project"

**Question 3: Package Identifier**
- Header: "Bundle ID"
- Question: "What is the package identifier? (reverse domain, e.g., com.company.myapp)"
- Options: "com.company.myapp", "me.developer.app"

**Question 4: Optional Features**
- Header: "Features"
- Question: "Which optional features do you want to enable?"
- multiSelect: true
- Options:
  - "Push Notifications" — Firebase Messaging + local notifications (key: `push_notifications`)
  - "AdMob" — Google Mobile Ads, banner & interstitial (key: `admob`)
  - "In-App Purchases" — RevenueCat subscriptions & purchases (key: `in_app_purchases`)
  - "App Tracking" — iOS App Tracking Transparency (key: `app_tracking`)
  - "Deep Linking" — Universal links / App links (key: `deep_linking`)

Store all answers for use in subsequent steps.

---

## Step 2: Generate Flutter Project

Extract org and name from the user's bundle ID. For example, if bundle ID is `com.company.myapp`:
- org = `com.company`
- project-name = user's Dart package name from Question 1

Run:
```bash
flutter create --org {org} --project-name {dart_package_name} .
```

This generates all platform files (android/, ios/, pubspec.yaml, etc.) using the user's current Flutter SDK version. Our existing `lib/` files are preserved (flutter create skips existing files).

After flutter create:
- Delete `test/widget_test.dart` (references the generated counter app, not our template)
- Keep `test/` directory

---

## Step 3: Rename Dart Package References

Replace `skeleton_app` with the user's Dart package name in ALL `.dart` files under `lib/`:
- All `import 'package:skeleton_app/` → `import 'package:{new_package_name}/`
- All `export 'package:skeleton_app/` → `export 'package:{new_package_name}/` (if any)

Replace display name references:
- `'Skeleton App'` and `"Skeleton App"` → `'{display_name}'` in `lib/app.dart`
- `"Skeleton App Dev"` → `"{display_name} Dev"` in `lib/common/config.dart`
- `"Skeleton App"` → `"{display_name}"` in `lib/common/config.dart` (prodVariables)

Update `lib/config/firebase_options.dart`:
- Replace `com.example.skeletonApp` with the user's bundle ID in `iosBundleId`

---

## Step 4: Patch pubspec.yaml

The generated pubspec.yaml has basic Flutter dependencies. Add our additional dependencies.

Read the generated `pubspec.yaml`, then add the following dependencies after the `cupertino_icons` line:

```yaml
  # Firebase
  firebase_core: ^3.9.0
  firebase_analytics: ^11.4.0
  firebase_crashlytics: ^4.3.0

  # Splash screen
  flutter_native_splash: ^2.4.4

  # --- OPTIONAL: push_notifications ---
  firebase_messaging: ^15.1.6
  flutter_local_notifications: ^19.4.2
  # --- END: push_notifications ---

  # --- OPTIONAL: admob ---
  google_mobile_ads: ^5.2.0
  # --- END: admob ---

  # --- OPTIONAL: in_app_purchases ---
  purchases_flutter: ^9.6.2
  # --- END: in_app_purchases ---

  # --- OPTIONAL: app_tracking ---
  app_tracking_transparency: ^2.0.6+1
  # --- END: app_tracking ---

  # --- OPTIONAL: deep_linking ---
  app_links: ^6.3.3
  # --- END: deep_linking ---
```

Also add at the end of pubspec.yaml (after the `flutter:` section):

```yaml
flutter_native_splash:
  color: "#ffffff"
  image: assets/splash.png
  android: true
  ios: true
```

---

## Step 5: Patch Android Configuration

### 5.1 `android/settings.gradle.kts`

Add Firebase plugin declarations in the `plugins` block. Find the existing `plugins { ... }` section and add these lines before the closing `}`:

```kotlin
    id("com.google.gms.google-services") version "4.4.2" apply false
    id("com.google.firebase.crashlytics") version "3.0.3" apply false
```

### 5.2 `android/app/build.gradle.kts`

Add these plugin IDs inside the `plugins { ... }` block, after the existing plugins:

```kotlin
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
```

Add inside `defaultConfig { ... }` block:
```kotlin
        // --- OPTIONAL: admob ---
        manifestPlaceholders["ADMOB_APP_ID"] = "ca-app-pub-3940256099942544~3347511713"
        // --- END: admob ---
```

### 5.3 `android/app/src/main/AndroidManifest.xml`

Add BEFORE the `<application` tag:
```xml
    <!-- --- OPTIONAL: push_notifications --- -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <!-- --- END: push_notifications --- -->
```

Add INSIDE the `<application>` tag, before the `<activity>` tag:
```xml
        <!-- --- OPTIONAL: admob --- -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="${ADMOB_APP_ID}"/>
        <!-- --- END: admob --- -->
```

Add INSIDE the main `<activity>` tag, after the existing `<intent-filter>`:
```xml
            <!-- --- OPTIONAL: deep_linking --- -->
            <meta-data
                android:name="flutter_deeplinking_enabled"
                android:value="true" />
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https" android:host="example.com" />
            </intent-filter>
            <!-- --- END: deep_linking --- -->
```

---

## Step 6: Patch iOS Configuration

### 6.1 `ios/Runner/Info.plist`

Add the following entries BEFORE the closing `</dict>` tag:

```xml
	<!-- --- OPTIONAL: push_notifications --- -->
	<key>UIBackgroundModes</key>
	<array>
		<string>fetch</string>
		<string>remote-notification</string>
	</array>
	<!-- --- END: push_notifications --- -->
	<!-- --- OPTIONAL: app_tracking --- -->
	<key>NSUserTrackingUsageDescription</key>
	<string>This identifier will be used to deliver personalized ads to you.</string>
	<!-- --- END: app_tracking --- -->
	<!-- --- OPTIONAL: admob --- -->
	<key>GADApplicationIdentifier</key>
	<string>ca-app-pub-3940256099942544~1458002511</string>
	<key>SKAdNetworkItems</key>
	<array>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>cstr6suwn9.skadnetwork</string>
		</dict>
	</array>
	<!-- --- END: admob --- -->
	<!-- --- OPTIONAL: deep_linking --- -->
	<key>FlutterDeepLinkingEnabled</key>
	<true/>
	<!-- --- END: deep_linking --- -->
```

Also update the display name:
- Find `<key>CFBundleDisplayName</key>` and change the `<string>` value to the user's display name
- Find `<key>CFBundleName</key>` and change the `<string>` value to the user's Dart package name

---

## Step 7: Remove Unselected Features

For each feature the user did NOT select, remove its code blocks using the marker system.

### Marker formats

Dart files:
```
// --- OPTIONAL: feature_key ---
...code...
// --- END: feature_key ---
```

XML/plist files:
```
<!-- --- OPTIONAL: feature_key --- -->
...code...
<!-- --- END: feature_key --- -->
```

YAML files:
```
# --- OPTIONAL: feature_key ---
...code...
# --- END: feature_key ---
```

Kotlin/Gradle files:
```
// --- OPTIONAL: feature_key ---
...code...
// --- END: feature_key ---
```

### Feature keys and associated files:

| Feature | Key | Service File |
|---------|-----|-------------|
| Push Notifications | `push_notifications` | `lib/services/notification_service.dart` |
| AdMob | `admob` | `lib/services/admob_service.dart` |
| In-App Purchases | `in_app_purchases` | `lib/services/purchase_service.dart` |
| App Tracking | `app_tracking` | `lib/services/att_service.dart` |
| Deep Linking | `deep_linking` | `lib/features/deep_linking.dart` |

### For each UNSELECTED feature:
1. Delete the entire block from `OPTIONAL: {key}` to `END: {key}` (inclusive) in ALL files that contain it
2. Delete the service/feature file listed above
3. If the `lib/features/` or `lib/services/` directory becomes empty, remove it

### For each SELECTED feature:
1. Remove ONLY the marker comment lines (keep the code between them)
   - Delete lines containing `// --- OPTIONAL: {key} ---` and `// --- END: {key} ---`
   - Delete lines containing `<!-- --- OPTIONAL: {key} --- -->` and `<!-- --- END: {key} --- -->`
   - Delete lines containing `# --- OPTIONAL: {key} ---` and `# --- END: {key} ---`

### Files to process for markers:
- `lib/common/config.dart`
- `lib/initialize.dart`
- `lib/app.dart`
- `pubspec.yaml`
- `android/app/build.gradle.kts`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

---

## Step 8: Install Dependencies

```bash
flutter pub get
```

Fix any dependency resolution issues if they arise.

---

## Step 9: Firebase Configuration

Ask the user if they want to configure Firebase now:

Use AskUserQuestion:
- Header: "Firebase"
- Question: "Configure Firebase now? You need Firebase CLI and FlutterFire CLI installed."
- Options:
  - "Yes, configure now" — Will run flutterfire configure
  - "Skip for now" — Will remind user to run it later

If yes:
```bash
flutterfire configure
```

If skipped, remind the user:
> Remember to run `flutterfire configure` before building the app. The placeholder firebase_options.dart will throw at runtime until configured.

---

## Step 10: Validate

```bash
flutter analyze
```

Fix any issues found. Common issues:
- Import paths not fully renamed (skeleton_app references remaining)
- Missing dependency versions
- Unused imports from removed features

---

## Step 11: Update CLAUDE.md

Replace `.claude/CLAUDE.md` with project-specific content:

```markdown
# {App Display Name}

Package: `{dart_package_name}` | Bundle ID: `{bundle_id}`

## Architecture
- Environment config: `lib/common/config.dart` (dev/prod variables + static getters)
- Entry points: `lib/main_dev.dart` (dev), `lib/main_prod.dart` (prod)
- Service initialization: `lib/initialize.dart` (Firebase, error handling, services)
- Root widget: `lib/app.dart`

## Build & Run
```
flutter run -t lib/main_dev.dart          # Development
flutter run -t lib/main_prod.dart         # Production
flutter build apk -t lib/main_prod.dart   # Android release
flutter build ios -t lib/main_prod.dart   # iOS release
flutter analyze                           # Static analysis
```

## Active Features
{list each selected feature, or "Base only (Firebase + Crashlytics + Splash)" if none selected}

## Conventions
- Services use singleton pattern: `ClassName.instance`
- Environment config via `Config.xxx` static getters
- All service initialization in `initialize.dart`
- Firebase options generated by `flutterfire configure` — do NOT edit manually
- Add new config values to both `devVariables` and `prodVariables` maps in `config.dart`
- Add new services to `initialize.dart` in dependency order
```

---

## Step 12: Update .gitignore

Ensure `.gitignore` contains entries for:
```
# Firebase generated files
**/firebase_options.dart
**/google-services.json
**/GoogleService-Info.plist
firebase.json
.firebaserc

# Keystore
*.keystore
*.jks
android/key.properties

# Environment files
.env
.env.*
```

Add `**/firebase_options.dart` to .gitignore (the template tracks the placeholder, but after init the generated file should be ignored). The other entries should already be present from the template `.gitignore`. Verify and add any missing entries.

---

## Step 13: Clean Up

- Delete this init command file: `.claude/commands/init.md`
- If `.claude/commands/` is empty after deletion, remove the directory
- Delete `lib/config/firebase_options.dart` placeholder IF `flutterfire configure` was run (it generates the real one)

---

## Done!

Report to the user:
- Project name and bundle ID
- Which features were enabled
- Whether Firebase was configured
- Next steps (if Firebase was skipped, remind them)
- How to run: `flutter run -t lib/main_dev.dart`
