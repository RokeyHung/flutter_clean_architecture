import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceId() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    const androidId = AndroidId();
    return androidId.getId();
  } else if (Platform.isIOS) {
    final info = await deviceInfoPlugin.iosInfo;
    return info.identifierForVendor;
  } else {
    return null;
  }
}
