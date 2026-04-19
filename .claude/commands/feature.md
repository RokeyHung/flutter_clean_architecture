# /feature — Tạo feature mới theo Clean Architecture

Tạo toàn bộ boilerplate cho một feature mới: entity, repository, usecase, model, datasource, state, notifier, providers, page.

## Usage

```
/feature <tên_feature>
```

## Ví dụ

```
/feature user
/feature product
/feature auth
```

## Những gì sẽ được tạo

```
lib/features/<feature>/
├── domain/
│   ├── entities/<feature>_entity.dart         ← Freezed sealed entity
│   ├── repositories/<feature>_repository.dart ← abstract interface
│   └── usecases/
│       ├── get_<feature>s_usecase.dart
│       └── create_<feature>_usecase.dart
├── data/
│   ├── models/<feature>_model.dart             ← Freezed + json_serializable
│   ├── datasources/
│   │   ├── <feature>_remote_data_source.dart   ← Dio
│   │   └── <feature>_local_data_source.dart    ← SharedPreferences cache
│   └── repositories/<feature>_repository_impl.dart
└── presentation/
    ├── state/<feature>_state.dart              ← Freezed sealed state
    ├── providers/
    │   ├── <feature>_notifier.dart             ← Riverpod 3 Notifier
    │   └── <feature>_providers.dart
    ├── pages/<feature>_list_page.dart
    └── widgets/<feature>_item_widget.dart

test/features/<feature>/
├── domain/usecases/get_<feature>s_usecase_test.dart
└── data/repositories/<feature>_repository_impl_test.dart
```

## Rules khi implement

- Dùng `sealed class` cho entity và state (Freezed v3)
- Dùng `abstract class` cho model có custom methods
- Variant names phải PUBLIC: `FeatureLoaded`, KHÔNG phải `_Loaded`
- Dùng `Notifier<XState>` + `NotifierProvider`, KHÔNG dùng `StateNotifier`
- Dùng `switch (failure) { NetworkFailure(:final message) => ... }`
- Sau khi tạo xong, chạy `make build-runner`
- Thêm route vào `lib/core/router/app_router.dart` và `app_router.gr.dart`
