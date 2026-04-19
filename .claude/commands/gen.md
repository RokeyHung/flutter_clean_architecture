# /gen — Chạy code generation

Chạy `build_runner` để regenerate các file `*.g.dart`, `*.freezed.dart`, `*.gr.dart`.

## Usage

```
/gen
/gen watch
```

## Khi nào cần chạy

- Sau khi thêm/sửa `@freezed` class
- Sau khi thêm/sửa `@JsonSerializable` / `fromJson`
- Sau khi thêm/sửa `@RoutePage()`
- Sau khi thêm/sửa `@riverpod` annotation
- Sau khi `flutter pub get` thay đổi version package

## Commands

```bash
# Chạy một lần
dart run build_runner build --delete-conflicting-outputs

# Watch mode (tự động khi file thay đổi)
dart run build_runner watch --delete-conflicting-outputs
```

Tương đương: `make build-runner` hoặc `make watch`
