# skill: riverpod-migration

# Riverpod 2 → 3 migration guide

## Breaking changes

| v2                            | v3                                   |
| ----------------------------- | ------------------------------------ |
| `StateNotifier<T>`            | `Notifier<T>`                        |
| `StateNotifierProvider<N, T>` | `NotifierProvider<N, T>`             |
| Constructor injection         | `ref.read(provider)` trong `build()` |
| `AsyncNotifier`               | Vẫn giữ tên (không đổi)              |

## Migrate StateNotifier → Notifier

```dart
// v2
class TodoNotifier extends StateNotifier<TodoState> {
  final GetTodosUseCase _useCase;
  TodoNotifier(this._useCase) : super(const TodoState.initial());

  Future<void> load() async {
    state = const TodoState.loading();
    // ...
  }
}

final provider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier(ref.watch(getTodosUseCaseProvider));
});

// v3
class TodoNotifier extends Notifier<TodoState> {
  @override
  TodoState build() => const TodoState.initial();

  Future<void> load() async {
    state = const TodoState.loading();
    final result = await ref.read(getTodosUseCaseProvider)(const NoParams());
    // ...
  }
}

final provider = NotifierProvider<TodoNotifier, TodoState>(TodoNotifier.new);
```

## Notes

- Trong `Notifier`, `ref` luôn available (không cần truyền qua constructor)
- `build()` là nơi khởi tạo state ban đầu
- Dùng `ref.read()` (không phải `ref.watch()`) trong methods của Notifier
- `ref.watch()` CHỈ dùng trong `build()`
