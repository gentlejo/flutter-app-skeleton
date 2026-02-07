# Project Initialization

Initialize this skeleton template into a real Flutter project. This template contains only Dart source files — platform files (android/, ios/, pubspec.yaml, etc.) are generated fresh by `flutter create` to match the user's current Flutter SDK version.

The Flutter client lives under `app/`. All flutter commands run from within `app/`.

Follow these steps exactly in order.

---

## Step 1: Gather Project Information

Use AskUserQuestion to collect ALL of the following at once (3 questions):

**Question 1: Bundle ID**
- Header: "Bundle ID"
- Question: "What is the full bundle identifier? (e.g., com.gentlejo.myapp)"
- Options: "com.gentlejo.myapp", "com.company.coolapp"

**Question 2: App Display Name**
- Header: "App Name"
- Question: "What is the app display name shown to users? (e.g., My App)"
- Options: "My App", "Cool App"

**Question 3: Optional Features**
- Header: "Features"
- Question: "Which optional features do you want to enable?"
- multiSelect: true
- Options:
  - "Push Notifications" — Firebase Messaging + local notifications (key: `push_notifications`)
  - "AdMob" — Google Mobile Ads, banner & interstitial (key: `admob`)
  - "In-App Purchases" — RevenueCat subscriptions & purchases (key: `in_app_purchases`)
  - "App Tracking" — iOS App Tracking Transparency (key: `app_tracking`)
  - "Deep Linking" — Universal links / App links (key: `deep_linking`)

### Derived values (do NOT ask the user):
From the bundle ID, automatically derive:
- **org**: everything before the last dot (e.g., `com.gentlejo.myapp` → `com.gentlejo`)
- **dart_package_name**: the last segment (e.g., `com.gentlejo.myapp` → `myapp`)

Store all answers and derived values for use in subsequent steps.

---

## Step 2: Generate Flutter Project

Use the derived values from Step 1:

Run from within `app/`:
```bash
cd app && flutter create --org {org} --project-name {dart_package_name} .
```

This generates all platform files (android/, ios/, pubspec.yaml, etc.) using the user's current Flutter SDK version. Our existing `lib/` files are preserved (flutter create skips existing files).

After flutter create:
- Delete `app/test/widget_test.dart` (references the generated counter app, not our template)
- Keep `app/test/` directory
- Patch `app/ios/Podfile`: find the line `# platform :ios, ...` (commented out) or `platform :ios, ...` and replace it with `platform :ios, '15.0'` (Firebase plugins require iOS 15.0+)

---

## Step 3: Rename Dart Package References

Replace `skeleton_app` with the user's Dart package name in ALL `.dart` files under `app/lib/`:
- All `import 'package:skeleton_app/` → `import 'package:{new_package_name}/`
- All `export 'package:skeleton_app/` → `export 'package:{new_package_name}/` (if any)

Replace display name references:
- `'Skeleton App'` and `"Skeleton App"` → `'{display_name}'` in `app/lib/app.dart`
- `"Skeleton App Dev"` → `"{display_name} Dev"` in `app/lib/common/config.dart`
- `"Skeleton App"` → `"{display_name}"` in `app/lib/common/config.dart` (prodVariables)

Update `app/lib/config/firebase_options.dart`:
- Replace `com.example.skeletonApp` with the user's bundle ID in `iosBundleId`

---

## Step 4: Patch pubspec.yaml

The generated `app/pubspec.yaml` has basic Flutter dependencies. Add our additional dependencies.

Read the generated `app/pubspec.yaml`, then add the following dependencies after the `cupertino_icons` line:

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

Also add at the end of `app/pubspec.yaml` (after the `flutter:` section):

```yaml
flutter_native_splash:
  color: "#ffffff"
  image: assets/splash.png
  android: true
  ios: true
```

---

## Step 5: Patch Android Configuration

### 5.1 `app/android/settings.gradle.kts`

Add Firebase plugin declarations in the `plugins` block. Find the existing `plugins { ... }` section and add these lines before the closing `}`:

```kotlin
    id("com.google.gms.google-services") version "4.4.2" apply false
    id("com.google.firebase.crashlytics") version "3.0.3" apply false
```

### 5.2 `app/android/app/build.gradle.kts`

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

### 5.3 `app/android/app/src/main/AndroidManifest.xml`

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

### 6.1 `app/ios/Runner/Info.plist`

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
| Push Notifications | `push_notifications` | `app/lib/services/notification_service.dart` |
| AdMob | `admob` | `app/lib/services/admob_service.dart` |
| In-App Purchases | `in_app_purchases` | `app/lib/services/purchase_service.dart` |
| App Tracking | `app_tracking` | `app/lib/services/att_service.dart` |
| Deep Linking | `deep_linking` | `app/lib/features/deep_linking.dart` |

### For each UNSELECTED feature:
1. Delete the entire block from `OPTIONAL: {key}` to `END: {key}` (inclusive) in ALL files that contain it
2. Delete the service/feature file listed above
3. If the `app/lib/features/` or `app/lib/services/` directory becomes empty, remove it

### For each SELECTED feature:
1. Remove ONLY the marker comment lines (keep the code between them)
   - Delete lines containing `// --- OPTIONAL: {key} ---` and `// --- END: {key} ---`
   - Delete lines containing `<!-- --- OPTIONAL: {key} --- -->` and `<!-- --- END: {key} --- -->`
   - Delete lines containing `# --- OPTIONAL: {key} ---` and `# --- END: {key} ---`

### Files to process for markers:
- `app/lib/common/config.dart`
- `app/lib/initialize.dart`
- `app/lib/app.dart`
- `app/pubspec.yaml`
- `app/android/app/build.gradle.kts`
- `app/android/app/src/main/AndroidManifest.xml`
- `app/ios/Runner/Info.plist`

---

## Step 8: Install Dependencies

```bash
cd app && flutter pub get
```

Fix any dependency resolution issues if they arise.

---

## Step 9: Firebase Configuration

`flutterfire configure` is an interactive CLI that requires option selection (arrow keys, spacebar), which does NOT work inside Claude CLI. The user must run it in a separate terminal.

Guide the user with this message:

> **Firebase 설정이 필요합니다.**
>
> `flutterfire configure`는 인터랙티브 CLI라서 Claude Code 안에서 실행할 수 없습니다.
> 별도 터미널을 열어서 아래 명령어를 실행해 주세요:
>
> ```bash
> cd {absolute_path_to_project}/app && flutterfire configure --out=lib/config/firebase_options.dart
> ```
>
> (`--out` 옵션으로 기존 placeholder 위치에 파일이 생성됩니다. import 경로 변경이 필요 없습니다.)
>
> 완료되면 여기서 "done"이라고 입력해 주세요. 건너뛰려면 "skip"이라고 입력해 주세요.

Wait for the user to respond before proceeding. Do NOT attempt to run `flutterfire configure` via Bash.

If the user says "done" or equivalent, continue to Step 10.

If the user says "skip" or equivalent, remind the user:
> Remember to run `flutterfire configure` inside `app/` before building the app. The placeholder firebase_options.dart will throw at runtime until configured.

---

## Step 10: Validate

```bash
cd app && flutter analyze
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

## Structure
```
app/          # Flutter client
backend/      # Backend server
```

## App Architecture
- Environment config: `app/lib/common/config.dart` (dev/prod variables + static getters)
- Entry points: `app/lib/main_dev.dart` (dev), `app/lib/main_prod.dart` (prod)
- Service initialization: `app/lib/initialize.dart` (Firebase, error handling, services)
- Root widget: `app/lib/app.dart`

## Build & Run
```
cd app
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

Ensure `app/.gitignore` contains entries for:
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

Add `**/firebase_options.dart` to `app/.gitignore` (the template tracks the placeholder, but after init the generated file should be ignored). The other entries should already be present from the template `.gitignore`. Verify and add any missing entries.

---

## Step 13: Clean Up

- Delete this init command file: `.claude/commands/init.md`
- If `.claude/commands/` is empty after deletion, remove the directory
- (firebase_options.dart placeholder는 `--out` 옵션으로 같은 경로에 덮어쓰기되므로 별도 삭제 불필요)

---

## Done!

Report to the user:
- Project name and bundle ID
- Which features were enabled
- Whether Firebase was configured
- Next steps (if Firebase was skipped, remind them)
- How to run: `cd app && flutter run -t lib/main_dev.dart`
