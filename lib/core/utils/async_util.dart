import 'dart:async';

/// マイクロタスクとして関数をメインスレッド上でタイムスライシングして非同期に実行します。
void dispatchMicroTask(FutureOr<void> Function() task) =>
    unawaited(Future.microtask(task));

@Deprecated('Replace with dispatchMicroTask')
const detachMicroTask = dispatchMicroTask;
