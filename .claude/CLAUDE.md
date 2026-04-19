# Flutter Clean Architecture — Claude Project Rules

## Architecture

Dự án theo **Clean Architecture** với 4 layer:

```
lib/
├── core/                    # Shared: errors, network, router, services, utils
├── features/<feature>/
│   ├── domain/              # Entities (Freezed sealed), Repository interfaces, UseCases
│   ├── data/                # Models (Freezed + json_serializable), DataSources (Dio), Repository impl
│   └── presentation/        # State (Freezed sealed), Notifier (Riverpod 3), Pages, Widgets
└── main.dart
```

## Stack

- **State management**: `flutter_riverpod ^3` — dùng `Notifier` / `NotifierProvider`, KHÔNG dùng `StateNotifier` / `StateNotifierProvider` (đã bị xóa)
- **Models/Entities**: `freezed ^3` — sealed class cho union types, abstract class cho single-variant với custom methods
- **Serialization**: `json_serializable` — chỉ cho Data layer models
- **Networking**: `dio` — qua `DioClient.createDio()`
- **Error handling**: `fpdart` — `Either<Failure, T>` từ Repository trở lên. KHÔNG throw exception ra ngoài data layer
- **Routing**: `auto_route ^11` — annotate pages với `@RoutePage()`, navigate bằng `context.pushRoute()` / `context.maybePop()`
- **Local storage**: `shared_preferences` — inject qua `ProviderScope` override ở `main()`
- **Secure storage**: `flutter_secure_storage` — qua `SecureStorageService`

## Firebase Services (`lib/core/services/`)

| Service                                              | File                         | Khởi tạo                                                           |
| ---------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------ |
| Firebase core + Crashlytics + AppCheck + Performance | `firebase_service.dart`      | `FirebaseService.init()` trong `main()`                            |
| Auth (email, anonymous)                              | `auth_service.dart`          | `authServiceProvider`, `authStateProvider`                         |
| FCM push notifications                               | `messaging_service.dart`     | `MessagingService.init()` + `messagingServiceProvider`             |
| Remote Config                                        | `remote_config_service.dart` | `RemoteConfigService.init()` → inject qua `ProviderScope` override |
| Storage + ImagePicker + ImageCropper                 | `storage_service.dart`       | `storageServiceProvider`                                           |

## Other Services (`lib/core/services/`)

| Service           | Package             | Mô tả                                                 |
| ----------------- | ------------------- | ----------------------------------------------------- |
| `DeepLinkService` | `app_links`         | Xử lý deep link, khởi tạo trong `initState()`         |
| `VersionService`  | `version`           | So sánh semantic version với `AppInfoService.version` |
| `AppInfoService`  | `package_info_plus` | App name, version, build number                       |

## UI Packages đang dùng

| Package                          | Dùng ở đâu                                                      |
| -------------------------------- | --------------------------------------------------------------- |
| `badges`                         | FAB badge số todo pending trong `todo_list_page.dart`           |
| `app_badge_plus`                 | App icon badge cập nhật khi load todos                          |
| `extended_text_field`            | Title field trong `add_todo_page.dart` (hỗ trợ @mention, emoji) |
| `ogp_data_extract`               | Preview card khi nhập URL trong `add_todo_page.dart`            |
| `share_plus`                     | Nút share trong `todo_item_widget.dart`                         |
| `cached_network_image`           | Avatar bot trong `todo_item_widget.dart` + Drawer               |
| `carousel_slider`                | Banner tips trong `todo_list_page.dart`                         |
| `url_launcher`                   | Mở link todo trên browser                                       |
| `image_picker` + `image_cropper` | Qua `StorageService.pickAndUploadImage()`                       |

## Coding conventions

### Freezed v3

- Union types (Failure, State) dùng `sealed class`:
  ```dart
  @freezed
  sealed class TodoState with _$TodoState {
    const factory TodoState.loaded(List<TodoEntity> todos) = TodoLoaded; // tên PUBLIC
  }
  ```
- Variant names phải PUBLIC (không dùng `_Initial`, phải dùng `TodoInitial`)
- Single-variant với custom methods dùng `abstract class`:
  ```dart
  @freezed
  abstract class TodoModel with _$TodoModel { ... }
  ```

### Riverpod 3

- Notifier: `class XNotifier extends Notifier<XState>`
- Provider: `NotifierProvider<XNotifier, XState>(XNotifier.new)`
- Trong `Notifier.build()` dùng `ref.read(provider)` để lấy dependency
- KHÔNG dùng `StateNotifier`, `StateNotifierProvider`, `maybeWhen`, `when` trên sealed class — dùng `switch`

### Pattern matching (Dart 3)

```dart
// Đúng
switch (failure) {
  NetworkFailure(:final message) => ...,
  ServerFailure(:final message) => ...,
}

// Sai — Freezed v3 không generate .when() trên sealed class
failure.when(network: ..., server: ...)
```

### Either / Error handling

- DataSource: throw `NetworkException` / `ServerException` / `CacheException`
- Repository: catch exception → trả `Left(Failure.xxx(...))`, thành công → `Right(data)`
- UseCase: forward `Either` từ repository, không xử lý error
- Presentation: `result.fold((failure) => ..., (data) => ...)`

### Imports

- Dùng relative import trong cùng package (lib/)
- Dùng package import (`package:flutter_clean_architecture/...`) trong test/

### Double underscore

- KHÔNG dùng `__` làm tên parameter — dùng `_`
- Ví dụ: `separatorBuilder: (_, _) => ...`

## Code generation

Sau khi thêm/sửa bất kỳ file có `@freezed`, `@JsonSerializable`, `@riverpod`, `@RoutePage`:

```bash
make build-runner
# hoặc
dart run build_runner build --delete-conflicting-outputs
```

## File naming

- `*_entity.dart` — Domain entity
- `*_model.dart` — Data model (có fromJson/toJson)
- `*_repository.dart` — Repository interface (domain)
- `*_repository_impl.dart` — Repository implementation (data)
- `*_remote_data_source.dart` / `*_local_data_source.dart`
- `*_usecase.dart` — UseCase
- `*_state.dart` — Freezed state
- `*_notifier.dart` — Riverpod Notifier
- `*_providers.dart` — Tập hợp Providers của feature
- `*_page.dart` — Page widget (`@RoutePage()`)
- `*_widget.dart` — Reusable widget

## Test conventions

- Mock với `mocktail`
- File test mirror cấu trúc `lib/` trong `test/`
- Fixtures để trong `test/helpers/` hoặc `test/features/<feature>/helpers/`
- Package import trong test: `package:flutter_clean_architecture/...`
- Dùng `isA<Right>()` / `isA<Left>()` để assert Either
- Dùng `isA<NetworkFailure>()` thay vì pattern matching trong test

## Thêm feature mới

1. Tạo folder `lib/features/<feature>/domain/`, `data/`, `presentation/`
2. Viết entity → repository interface → usecases (domain)
3. Viết model → datasource → repository impl (data)
4. Viết state → notifier → providers → pages/widgets (presentation)
5. Thêm route vào `lib/core/router/app_router.dart`
6. Chạy `make build-runner`
7. Viết unit test cho usecase và repository impl

## Không được làm

- KHÔNG throw exception ra ngoài data layer
- KHÔNG dùng `BuildContext` trong Notifier
- KHÔNG dùng `StateNotifier` / `StateNotifierProvider`
- KHÔNG đặt tên variant Freezed bắt đầu bằng `_`
- KHÔNG gọi `failure.when(...)` hay `failure.maybeWhen(...)` trên sealed class Freezed v3
- KHÔNG dùng `context.popRoute()` — dùng `context.maybePop()`
- KHÔNG commit generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`)
