# skill: freezed-migration

# Freezed v2 → v3 migration guide

## Breaking changes

| v2                                        | v3                                                                                              |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `class Foo with _$Foo`                    | `sealed class Foo with _$Foo` (cho union) hoặc `abstract class Foo with _$Foo` (single variant) |
| Variant `= _Loaded` (private)             | Variant phải PUBLIC: `= Loaded` hoặc `= FooLoaded`                                              |
| `foo.when(loaded: (x) => ...)`            | `switch (foo) { Loaded(:final x) => ... }`                                                      |
| `foo.maybeWhen(loaded: ..., orElse: ...)` | `switch (foo) { Loaded(:final x) => ..., _ => orElse }`                                         |
| `foo.map(loaded: (v) => ...)`             | `switch (foo) { Loaded() => ... }`                                                              |

## Checklist khi migrate

1. Thêm `sealed` hoặc `abstract` vào class declaration
2. Đổi tên tất cả variant từ `_Foo` → `Foo` (public)
3. Update tất cả `switch` / `is` check để dùng tên mới
4. Chạy `build_runner` để regenerate
5. Fix compile errors từ pattern matching

## Ví dụ

```dart
// v2
@freezed
class State with _$State {
  const factory State.loaded(List items) = _Loaded;
}
// dùng: state.when(loaded: (items) => ...)

// v3
@freezed
sealed class State with _$State {
  const factory State.loaded(List items) = Loaded; // PUBLIC
}
// dùng: switch (state) { Loaded(:final items) => ... }
```
