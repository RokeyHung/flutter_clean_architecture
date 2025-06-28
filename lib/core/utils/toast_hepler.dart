import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static bool _isShowing = false;

  static Future<void> showDebouncedToast(
    String message, {
    int durationMs = 2000,
    BuildContext? context,
  }) async {
    if (_isShowing) return;

    _isShowing = true;

    final bool isKeyboardOpen = context != null &&
        MediaQuery.of(context).viewInsets.bottom > 0 &&
        Platform.isIOS;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: isKeyboardOpen ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    await Future.delayed(Duration(milliseconds: durationMs));
    _isShowing = false;
  }
}
