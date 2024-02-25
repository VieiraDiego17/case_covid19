import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceData() async {
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceData['brand'] = androidInfo.brand;
        deviceData['model'] = androidInfo.model;
        deviceData['deviceName'] = androidInfo.device;
        //deviceData['deviceType'] = 'Celular';
        if (androidInfo.model.toLowerCase().contains('tablet')) {
          deviceData['deviceType'] = 'Tablet';
        } else {
          deviceData['deviceType'] = 'Celular';
        }
        deviceData['os'] = 'Android';
        deviceData['osVersion'] = androidInfo.version.sdkInt.toString();
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceData['brand'] = 'Apple';
        deviceData['model'] = iosInfo.model;
        deviceData['deviceName'] = iosInfo.name;
        deviceData['deviceType'] = iosInfo.model.contains('iPad') ? 'Tablet' : 'Celular';
        deviceData['os'] = 'iOS';
        deviceData['osVersion'] = iosInfo.systemVersion;
      }
    } catch (e) {
      print('Erro ao obter informações do dispositivo: $e');
    }

    return deviceData;
  }
}
