import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

void useOnInitialize(
    FutureOr<void> Function() init, {
      List<Object>? keys,
    }) {
  final callback = useCallback(init, keys ?? const []);
  useEffect(
        () {
      final subscription = Future.microtask(callback).asStream().listen(null);
      return subscription.cancel;
    },
    [callback],
  );
}

void useOnDispose(
    void Function() dispose, {
      List<Object>? keys,
    }) {
  final callback = useCallback(dispose, keys ?? const []);
  useEffect(
        () => callback,
    [callback],
  );
}

void useOnReceive<Event>(
    Stream<Event> actions,
    void Function(Event event) handle, {
      List<Object>? keys,
    }) {
  final callback = useCallback(handle, keys ?? const []);
  useEffect(
        () {
      final subscription = actions.listen(callback);
      return subscription.cancel;
    },
    [actions, callback],
  );
}

@Deprecated('Replace with useOnInitialize')
const onInitialize = useOnInitialize;

@Deprecated('Replace with useOnDispose')
const onDispose = useOnDispose;

@Deprecated('Replace with useOnReceive')
const onReceive = useOnReceive;
