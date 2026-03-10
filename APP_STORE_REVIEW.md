# Livingston Parish SADD – App Store Review & Checklist

This document summarizes the review done for App Store submission and lists all permissions, packages, and manual steps.

---

## Changes applied in this review

### 1. **App name and branding**
- **iOS `Info.plist`**: `CFBundleDisplayName` and `CFBundleName` set to **"Livingston Parish SADD"** (was "Dp Sad" / "dp_sad").
- **Android `AndroidManifest.xml`**: `android:label` set to **"Livingston Parish SADD"** (was "LPSADD").
- **pubspec.yaml**: `description` set to **"Livingston Parish SADD - Students Against Destructive Decisions."**

### 2. **iOS bundle identifier**
- **Xcode project**: `PRODUCT_BUNDLE_IDENTIFIER` set to **`com.livingston.sadd`** in all configurations (Debug, Release, Profile, RunnerTests).
- This matches **`GoogleService-Info.plist`** (`BUNDLE_ID`: `com.livingston.sadd`) so Firebase (including Cloud Messaging) works correctly on iOS.

### 3. **iOS `Info.plist` – permissions and capabilities**
Added/verified the following:

| Key | Purpose | Used by |
|-----|---------|--------|
| **NSCameraUsageDescription** | Take photos (e.g. profile picture) | `image_picker` |
| **NSPhotoLibraryUsageDescription** | Choose photos from library | `image_picker` |
| **UIBackgroundModes** | Background fetch + remote notifications | `firebase_messaging` |
| **ITSAppUsesNonExemptEncryption** | Export compliance (only HTTPS) | App Store |

- **UIBackgroundModes** includes: `fetch`, `remote-notification`.
- **ITSAppUsesNonExemptEncryption** set to `false` (standard HTTPS only). If you add custom encryption, set to `true` and complete export compliance in App Store Connect.

### 4. **pubspec.yaml**
- Removed duplicate/misplaced `flutter_lints` entry under `flutter_icons`.

---

## Package review and permissions

| Package | iOS permission / config | Android permission / config | Notes |
|---------|--------------------------|-----------------------------|--------|
| **image_picker** | `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` | Camera/storage handled by plugin | Added in `Info.plist`. |
| **firebase_core** | None | None | Configured via `GoogleService-Info.plist` / `google-services`. |
| **firebase_messaging** | `UIBackgroundModes`: `remote-notification`, `fetch`; Push Notifications capability in Xcode | `INTERNET`, FCM metadata in manifest | Background modes added in `Info.plist`. You must add **Push Notifications** (and optionally **Background Modes**) in Xcode → Signing & Capabilities. |
| **flutter_local_notifications** | No extra `Info.plist` keys; permissions requested in code | `POST_NOTIFICATIONS` (Android 13+) | Already in Android manifest. |
| **app_settings** | None | None | Opens system settings. |
| **open_file** | None | None | Opens files with system handlers. |
| **intl_phone_field** | None | None | UI only; no dial/SMS. |
| **cached_network_image** | None | `INTERNET` (via Flutter) | No extra config. |
| **path_provider** | None | None | No extra config. |
| **shared_preferences** | None | None | No extra config. |
| **http** | None | `INTERNET` | No extra config. |
| **pdf** | None | None | No extra config. |
| **google_fonts** | None | None | Downloads fonts; no special permissions. |
| **flutter_image_compress** | None | None | No extra config. |

No other packages in your `pubspec.yaml` require additional `Info.plist` or Android permission entries beyond what is already set or added above.

---

## iOS App Store – manual steps (Xcode)

1. **Open** `ios/Runner.xcworkspace` in Xcode (not `.xcodeproj`).
2. **Signing & Capabilities**
   - Select the **Runner** target → **Signing & Capabilities**.
   - Set your **Team** and ensure **Automatically manage signing** is enabled (or configure manual signing).
   - Click **+ Capability** and add:
     - **Push Notifications** (required for FCM on iOS).
     - **Background Modes** and enable **Remote notifications** (and **Background fetch** if you use it).
3. **App Store Connect**
   - Create the app in App Store Connect with bundle ID **`com.livingston.sadd`**.
   - Upload with Xcode or **Transporter**, or use `flutter build ipa` then upload the `.ipa`.
4. **APNs for Firebase**
   - In Apple Developer: Certificates, Identifiers & Profiles → Keys → create an **APNs key** (.p8).
   - In Firebase Console → Project Settings → Cloud Messaging → **Apple app configuration** → upload the APNs key so FCM can deliver push to iOS.

---

## Android

- **Package name**: `com.lpsadd.apps` (in `build.gradle.kts` and manifest).
- **Permissions**: `INTERNET`, `POST_NOTIFICATIONS` are present in `AndroidManifest.xml`.
- **Firebase**: Uses `com.lpsadd.apps`; ensure the same package name is registered in Firebase Console for Android.
- **Signing**: Release signing is configured via `key.properties`; ensure the file exists and is not committed (it should be in `.gitignore`).

---

## Optional: dependency updates

`flutter pub outdated` reported some packages with newer versions. Upgrading is optional but can improve security and compatibility:

- `app_settings`: 6.1.1 → 7.0.0  
- `flutter_local_notifications`: 19.5.0 → 21.0.0  
- `fluttertoast`: 8.2.14 → 9.0.0  
- `google_fonts`: 6.3.3 → 8.0.2  
- `flutter_lints` (dev): 5.0.0 → 6.0.0  

To upgrade (may require code changes):

```bash
flutter pub upgrade --major-versions
```

Then run the app and fix any breaking changes.

---

## Pre-submission checklist

- [ ] Build iOS release: `flutter build ios` or `flutter build ipa`.
- [ ] In Xcode: add **Push Notifications** and **Background Modes → Remote notifications** for Runner.
- [ ] APNs key uploaded to Firebase for bundle ID `com.livingston.sadd`.
- [ ] App created in App Store Connect with bundle ID `com.livingston.sadd`.
- [ ] Privacy policy URL (if you collect user data) set in App Store Connect.
- [ ] Screenshots, description, keywords, and category set in App Store Connect.
- [ ] Export compliance: if you use only HTTPS, answer “No” to using non-exempt encryption (matches `ITSAppUsesNonExemptEncryption` = false).
- [ ] Test on a real device: push notifications do not work on the iOS Simulator.

---

## Summary

- **App name**: Set to **Livingston Parish SADD** on iOS and Android.
- **iOS bundle ID**: Set to **`com.livingston.sadd`** to match Firebase.
- **Info.plist**: Camera and Photo Library usage descriptions, Background Modes for push, and export compliance flag added.
- **Packages**: No missing permissions; only `image_picker` and `firebase_messaging` needed extra iOS configuration, which is in place.
- **Next**: Configure Push Notifications and Background Modes in Xcode, upload APNs key to Firebase, then build and submit to the App Store.
