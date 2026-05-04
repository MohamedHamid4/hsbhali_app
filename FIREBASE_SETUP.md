# Firebase Setup Instructions

The Firebase code is integrated in this app, but it requires platform-specific
configuration files in order to actually report crashes / log analytics events
in production. **The app works fine without these** — every Firebase call is
wrapped in `try`/`catch`, and the in-process `AnalyticsService` /
`CrashlyticsService` simply become no-ops when Firebase is not initialized.

## Setup Steps

### 1. Create the Firebase project
1. Go to <https://console.firebase.google.com/>
2. Create a new project named **Hsbhali** (or any name you prefer).
3. Enable Google Analytics for the project (recommended).

### 2. Add the Android app
1. In the Firebase Console, click **Add app → Android**.
2. Use the package name from `android/app/build.gradle` (e.g. `com.hsbhali.app`).
3. Download `google-services.json`.
4. Place the file at `android/app/google-services.json`.

### 3. Add the iOS app
1. In the Firebase Console, click **Add app → iOS**.
2. Use the bundle identifier from `ios/Runner.xcodeproj` (e.g. `com.hsbhali.app`).
3. Download `GoogleService-Info.plist`.
4. Place the file at `ios/Runner/GoogleService-Info.plist`
   (and add it to the Runner target in Xcode if it isn't already).

### 4. Wire Gradle plugins for Android

In `android/build.gradle` (project-level), inside `buildscript { dependencies { ... } }`:

```gradle
classpath 'com.google.gms:google-services:4.4.2'
classpath 'com.google.firebase:firebase-crashlytics-gradle:3.0.2'
```

In `android/app/build.gradle`, at the bottom:

```gradle
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'
```

### 5. Verify
Run the app, then:
- Trigger a non-fatal error (e.g. throw inside a button handler) → check
  the Firebase Console **Crashlytics** dashboard within ~5 minutes.
- Save a bill → check the Firebase Console **Analytics → Realtime → Events**
  for the `bill_created` event.

## Notes

- Without `google-services.json` / `GoogleService-Info.plist`, Firebase calls
  are silently skipped. The app will not crash.
- In **debug** builds, Crashlytics collection is disabled and Analytics events
  log to the console (`debugPrint`) instead of being sent.
- Custom keys you set via `CrashlyticsService.logError(extras: ...)` show up
  in the Crashlytics dashboard alongside each non-fatal report.
- User properties set via `AnalyticsService.setUserLanguage / setUserTheme /
  setHasPremium` are visible under the Audiences view.
