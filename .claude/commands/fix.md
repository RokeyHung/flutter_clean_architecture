# /fix — Fix errors và warnings

Đọc tất cả diagnostics từ IDE, phân tích và fix toàn bộ errors + warnings trong project.

## Usage

```
/fix
/fix <file_path>
```

## Quy trình

1. Dùng `mcp__ide__getDiagnostics` để lấy danh sách lỗi
2. Đọc các file liên quan
3. Fix theo thứ tự: Error → Warning → Info
4. Chạy `flutter test` để đảm bảo không break tests

## Common errors trong project này

| Error                                   | Fix                                                                   |
| --------------------------------------- | --------------------------------------------------------------------- |
| `StateNotifier` not found               | Dùng `Notifier<T>` + `NotifierProvider`                               |
| `_Initial` / `_Loaded` undefined        | Freezed v3: variant phải PUBLIC (`TodoInitial`, `TodoLoaded`)         |
| `failure.when(...)` not defined         | Dùng `switch (failure) { NetworkFailure(:final msg) => ... }`         |
| `failure.maybeWhen(...)` not defined    | Dùng `switch` hoặc cast `(failure as NetworkFailure).message`         |
| Dead code sau `_handleDioError`         | Đổi sang `_mapDioError` trả `Exception`, dùng `throw _mapDioError(e)` |
| `context.popRoute()` not found          | Dùng `context.maybePop()`                                             |
| Double underscore `__` warning          | Đổi thành `_`                                                         |
| Unused import                           | Xóa import                                                            |
| `encryptedSharedPreferences` deprecated | Xóa param khỏi `AndroidOptions()`                                     |
| Unnecessary braces `${x}`               | Đổi thành `$x`                                                        |
| Type param `Type` matches visible type  | Đổi thành `T`                                                         |
