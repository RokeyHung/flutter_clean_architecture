import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/core/utils/async_util.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> tryLaunchUrl(
  String url,
  BuildContext context, {
  LaunchMode mode = LaunchMode.platformDefault,
}) {
  try {
    final uri = Uri.parse(url);
    final analytics = _getAnalytics(context);
    return tryLaunchUriWithAnalytics(uri, analytics, mode: mode);
  } on Exception catch (_) {
    return Future.value(false);
  }
}

Future<bool> tryLaunchUri(
  Uri uri,
  BuildContext context, {
  LaunchMode mode = LaunchMode.platformDefault,
}) {
  final analytics = _getAnalytics(context);
  return tryLaunchUriWithAnalytics(uri, analytics, mode: mode);
}

void launchUrlUnawaited(
  String url,
  BuildContext context, {
  LaunchMode mode = LaunchMode.platformDefault,
}) {
  final analytics = _getAnalytics(context);
  dispatchMicroTask(
    () async => await tryLaunchUriWithAnalytics(
      Uri.parse(url),
      analytics,
      mode: mode,
    ),
  );
}

void launchUrlWithBrowserViewUnawaited(
  String url,
  BuildContext context,
) {
  launchUrlUnawaited(url, context, mode: LaunchMode.inAppBrowserView);
}

Future<bool> tryLaunchUriWithAnalytics(
  Uri uri,
  AppAnalytics? analytics, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  try {
    if (uri.scheme == '') {
      uri = uri.replace(scheme: 'https');
    }
    if (await canLaunchUrl(uri)) {
      final encodedUrl = Uri.encodeQueryComponent(uri.toString());
      analytics?.logScreen('/web_external/$encodedUrl');
      return await launchUrl(uri, mode: mode);
    }
    return false;
  } on Exception catch (_) {
    return false;
  }
}

AppAnalytics? _getAnalytics(BuildContext context) {
  final ref = UnsafeProviderRef.maybeOf(context);
  if (ref == null) {
    debugPrint('Failed to get ProviderRef from unmounted context.');
    return null;
  }
  return ref.read(oemAnalyticsProvider);
}
