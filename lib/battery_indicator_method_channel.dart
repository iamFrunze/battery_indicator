import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'battery_indicator_platform_interface.dart';

/// An implementation of [BatteryIndicatorPlatform] that uses method channels.
class MethodChannelBatteryIndicator extends BatteryIndicatorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('battery_indicator');

  @visibleForTesting
  final streamChannel = const EventChannel('battery_indicator/stream');

  final batteryRequest = 'getBatteryLevel';
  final batteryState = 'getBatteryState';


  @override
  Future<String?> getPlatformVersion() async {
    final version =
    await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<int> getBatteryLevelStream() {
    return streamChannel.receiveBroadcastStream().map((event) => event
    );
  }

  @override
  Future<int?> getBatteryLevel() =>
      methodChannel
          .invokeMethod<int>('getBatteryLevel')
          .then((value) => value);

}
