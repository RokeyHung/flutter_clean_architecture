// CORE - deep_link_service.dart (app_links)
import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import '../utils/app_logger.dart';

class DeepLinkService {
  static const _tag = 'DeepLink';

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
      onError: (e, st) =>
          AppLogger.e('Stream error', tag: _tag, error: e, stackTrace: st),
    );
  }

  void _handleUri(Uri uri) {
    AppLogger.i('Received: $uri', tag: _tag);
    // Example: myapp://todos/123 → navigate to todo detail
    // Extend this switch as you add more routes
    switch (uri.host) {
      case 'todos':
        final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        if (id != null) {
          AppLogger.d('Navigate to todo: $id', tag: _tag);
          // router.push(TodoDetailRoute(id: id));
        }
      default:
        AppLogger.w('Unhandled deep link: $uri', tag: _tag);
    }
  }
}
