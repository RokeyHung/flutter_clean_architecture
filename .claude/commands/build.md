# /build — Build APK / AAB / iOS

Build app cho các platform.

## Usage

```
/build apk
/build apk dev
/build apk staging
/build apk prod
/build aab
/build aab prod
/build ios
```

## Commands

```bash
# APK debug
flutter build apk --debug

# APK release theo flavor
flutter build apk --flavor dev     --target lib/main_dev.dart     --release
flutter build apk --flavor staging --target lib/main_staging.dart --release
flutter build apk --flavor prod    --target lib/main_prod.dart    --release

# AAB (Play Store)
flutter build appbundle --flavor prod --target lib/main_prod.dart --release

# iOS
flutter build ios --flavor prod --target lib/main_prod.dart --release
```

Tương đương: `make build-apk-prod`, `make build-aab-prod`

## Output paths

| Build    | Path                                                        |
| -------- | ----------------------------------------------------------- |
| APK prod | `build/app/outputs/flutter-apk/app-prod-release.apk`        |
| AAB prod | `build/app/outputs/bundle/prodRelease/app-prod-release.aab` |
