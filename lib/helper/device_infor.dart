import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfoHelper {
  static Future<String> getDivceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    late String token;
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      token = build.androidId;
    } else if (Platform.isIOS) {
      try {
        var build = await deviceInfoPlugin.iosInfo;
        token = build.identifierForVendor;
      } catch (e) {
        return '';
      }
    }

    return token;
  }
}
