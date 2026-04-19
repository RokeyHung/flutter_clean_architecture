// CORE - deep_link_service.dart (app_links)
import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final StackRouter router;

  DeepLinkService(this.router);

  Future<void> init() async {
    // Handle app opened from cold start via deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    // Handle links while app is running
    _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (e) => debugPrint('DeepLink error: $e'),
    );
  }

  void _handleUri(Uri uri) {
    debugPrint('DeepLink received: $uri');
    // Example: myapp://todos/123 → navigate to todo detail
    // Extend this switch as you add more routes
    switch (uri.host) {
      case 'todos':
        final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        if (id != null) {
          debugPrint('Navigate to todo: $id');
          // router.push(TodoDetailRoute(id: id));
        }
      default:
        debugPrint('Unhandled deep link: $uri');
    }
  }
}
