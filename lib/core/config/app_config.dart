import 'package:flutter/foundation.dart';

class AppConfig with Diagnosticable {
  final String appName;
  final String companyName;
  final String baseUrl;

  AppConfig({
    required this.appName,
    required this.companyName,
    required this.baseUrl,
  });
}
