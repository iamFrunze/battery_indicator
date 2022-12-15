import 'battery_indicator_platform_interface.dart';

class BatteryIndicator {
  Future<String?> getPlatformVersion() {
    return BatteryIndicatorPlatform.instance.getPlatformVersion();
  }

  Future<int?> getBatteryLevel() {
    return BatteryIndicatorPlatform.instance.getBatteryLevel();
  }
  Stream<int> getBatteryLevelStream() {
    return BatteryIndicatorPlatform.instance.getBatteryLevelStream();
  }
}
