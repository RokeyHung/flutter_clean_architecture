# /test — Chạy tests

Chạy unit tests cho project.

## Usage

```
/test
/test <path>
/test coverage
```

## Ví dụ

```
/test
/test test/features/todo/
/test coverage
```

## Commands

```bash
# Tất cả tests
flutter test

# Một folder cụ thể
flutter test test/features/todo/

# Verbose
flutter test --reporter expanded

# Coverage
flutter test --coverage
```

Tương đương: `make test` hoặc `make test-coverage`

## Test conventions

- Mock với `mocktail`
- Import: `package:flutter_clean_architecture/...`
- Assert Either: `expect(result, isA<Right>())` / `expect(result, isA<Left>())`
- Assert Failure type: `expect(failure, isA<NetworkFailure>())`
- KHÔNG dùng `failure.maybeWhen(...)` trong test — dùng cast trực tiếp
