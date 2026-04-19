# /run — Chạy app

Chạy app trên device/emulator.

## Usage

```
/run
/run dev
/run staging
/run prod
```

## Commands

```bash
# Debug (no flavor)
flutter run

# Theo flavor
flutter run --flavor dev     --target lib/main_dev.dart
flutter run --flavor staging --target lib/main_staging.dart
flutter run --flavor prod    --target lib/main_prod.dart
```

Tương đương: `make run` / `make run-dev` / `make run-staging` / `make run-prod`

## Lưu ý

- `lib/main_dev.dart`, `lib/main_staging.dart`, `lib/main_prod.dart` cần được tạo nếu dùng flavor
- Flavor yêu cầu cấu hình trong `android/app/build.gradle` và `ios/Runner.xcodeproj`
