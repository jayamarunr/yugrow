# Android Development Setup

> **Purpose:** Document the Android SDK configuration so any machine can build Yugrow for Android in minutes.
> **Last Updated:** 2026-07-30

---

## Prerequisites

- Flutter SDK (≥3.0.0)
- Java JDK (≥17)
- Android Studio (latest stable)
- Physical Android device or emulator for testing

---

## Environment Variables

Add these to your shell profile (`$PROFILE` for PowerShell, `~/.bashrc` for WSL/bash):

```powershell
# PowerShell ($PROFILE)
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
# Add to PATH
$env:Path += ";$env:ANDROID_HOME\platform-tools"
$env:Path += ";$env:ANDROID_HOME\cmdline-tools\latest\bin"
$env:Path += ";$env:ANDROID_HOME\emulator"
```

Verify:

```powershell
echo $env:ANDROID_HOME
flutter doctor
```

`flutter doctor` should show:

```
[√] Android toolchain - develop for Android devices
    (Android SDK version 34.0.0)
```

---

## Android SDK Components

Install via Android Studio:

1. Open Android Studio → SDK Manager
2. SDK Platforms tab:
   - Android 14.0 (API 34)
   - Android 13.0 (API 33)
3. SDK Tools tab:
   - Android SDK Build-Tools 34.0.0
   - Android SDK Command-line Tools (latest)
   - Android Emulator
   - Android SDK Platform-Tools

Or via command line:

```powershell
# List installed packages
sdkmanager --list

# Install required packages
sdkmanager "platforms;android-34"
sdkmanager "build-tools;34.0.0"
sdkmanager "platform-tools"
sdkmanager "emulator"
```

---

## Build Commands

### Debug APK (for testing)

```powershell
cd apps/mobile
flutter build apk --debug
```

Output: `build\app\outputs\flutter-apk\app-debug.apk`

### Profile APK (for performance testing)

```powershell
flutter build apk --profile
```

Output: `build\app\outputs\flutter-apk\app-profile.apk`

### Release APK

```powershell
flutter build apk --release
```

Output: `build\app\outputs\flutter-apk\app-release.apk`

### App Bundle (for Play Store)

```powershell
flutter build appbundle --release
```

Output: `build\app\outputs\bundle\release\app-release.aab`

---

## Signing Configuration

For Play Store releases, configure signing in `apps/mobile/android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            storeFile file("yugrow-release.jks")
            storePassword System.getenv("ANDROID_STORE_PASSWORD")
            keyAlias System.getenv("ANDROID_KEY_ALIAS")
            keyPassword System.getenv("ANDROID_KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

Create the keystore:

```powershell
keytool -genkey -v -keystore yugrow-release.jks `
  -alias yugrow -keyalg RSA -keysize 2048 -validity 10000
```

---

## Testing on Physical Device

1. Enable Developer Options on your Android device:
   - Settings → About Phone → Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options → USB Debugging
3. Connect device via USB
4. Verify:

```powershell
flutter devices
```

Should show your device.

5. Install and run:

```powershell
flutter run --debug
```

---

## Emulator

Create and start an emulator:

```powershell
# List available avd
emulator -list-avds

# Create new emulator (if none exist)
flutter emulators --create

# Start emulator
emulator -avd Pixel_6_API_34
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `No Android SDK found` | Set `ANDROID_HOME` environment variable |
| `Android license not accepted` | Run `flutter doctor --android-licenses` |
| `gradle build failed` | Check Java version: `java --version` (need ≥17) |
| `INSTALL_FAILED_UPDATE_INCOMPATIBLE` | Uninstall previous version first |
| `App not installed` | Enable "Install via USB" in Developer Options |

---

## CI/CD Notes

For automated builds (GitHub Actions, etc.):

```yaml
- name: Setup Android SDK
  uses: android-actions/setup-android@v3
  with:
    api-level: 34
    build-tools: 34.0.0

- name: Build APK
  run: flutter build apk --release
  working-directory: apps/mobile
```
