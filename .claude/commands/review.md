# /review — Code review

Review code của file hoặc feature, kiểm tra theo Clean Architecture + coding conventions của project.

## Usage

```
/review <file_path>
/review <feature_name>
```

## Checklist

### Architecture

- [ ] Dependency rule: outer layer chỉ depend vào inner layer (presentation → domain ← data)
- [ ] Domain không import từ data hoặc presentation
- [ ] UseCase chỉ chứa business logic, không có UI/network code

### Domain

- [ ] Entity dùng `sealed class` với Freezed v3
- [ ] Variant names PUBLIC (không bắt đầu `_`)
- [ ] Repository là `abstract interface class`
- [ ] UseCase implement `UseCase<T, Params>`

### Data

- [ ] Model dùng `abstract class` khi có custom methods
- [ ] `toEntity()` và `fromEntity()` đúng
- [ ] DataSource chỉ throw `NetworkException` / `ServerException` / `CacheException`
- [ ] Repository impl bọc exceptions thành `Left(Failure.xxx(...))`
- [ ] Cache fallback khi network fail

### Presentation

- [ ] Dùng `Notifier<T>` (Riverpod 3), KHÔNG `StateNotifier`
- [ ] Dùng `NotifierProvider`, KHÔNG `StateNotifierProvider`
- [ ] State là `sealed class` với Freezed v3
- [ ] Dùng `switch (state)` pattern matching
- [ ] KHÔNG dùng `BuildContext` trong Notifier
- [ ] Page annotate `@RoutePage()`
- [ ] Navigate dùng `context.pushRoute()` / `context.maybePop()`

### Error handling

- [ ] KHÔNG throw exception ra ngoài data layer
- [ ] Dùng `Either<Failure, T>` từ repository
- [ ] KHÔNG gọi `failure.when(...)` — dùng `switch (failure)`

### Code style

- [ ] KHÔNG dùng `__` — dùng `_`
- [ ] Import: relative trong lib/, package trong test/
- [ ] Không có unused imports
- [ ] Không có `print()` trong production code
