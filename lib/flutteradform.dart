import 'dart:async';

import 'package:flutter/services.dart';

class Flutteradform {
  static const MethodChannel _channel =
      const MethodChannel('flutter_adform');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
