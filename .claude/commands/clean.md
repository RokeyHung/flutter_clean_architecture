# /clean — Clean và rebuild project

Clean toàn bộ build artifacts và generated files, sau đó rebuild.

## Usage

```
/clean
```

## Quy trình

```bash
# 1. Flutter clean
flutter clean

# 2. Xóa generated files
find lib test -name "*.g.dart" -delete
find lib test -name "*.freezed.dart" -delete
find lib test -name "*.gr.dart" -delete
find lib test -name "*.config.dart" -delete

# 3. Pub get
flutter pub get

# 4. Regenerate
dart run build_runner build --delete-conflicting-outputs
```

Tương đương: `make clean-build`

## Khi nào cần dùng

- Sau khi upgrade Flutter/Dart version
- Sau khi upgrade package version lớn (Riverpod 2→3, Freezed 2→3)
- Khi có lỗi generated code không đồng bộ
- Sau khi merge conflict trên generated files
