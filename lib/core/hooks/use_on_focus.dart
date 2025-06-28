import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useOnFocus(VoidCallback? onFocus) {
  final context = useContext();

  useEffect(() {
    if (onFocus == null) {
      return null;
    }
    context.router.addListener(onFocus);
    return () => context.router.removeListener(onFocus);
  }, [onFocus]);
}
