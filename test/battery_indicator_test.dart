import 'package:flutter_test/flutter_test.dart';
import 'package:battery_indicator/battery_indicator.dart';
import 'package:battery_indicator/battery_indicator_platform_interface.dart';
import 'package:battery_indicator/battery_indicator_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBatteryIndicatorPlatform
    with MockPlatformInterfaceMixin
    implements BatteryIndicatorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> getBatteryLevel() {
    // TODO: implement getBatteryLevel
    throw UnimplementedError();
  }

  @override
  Stream<int> getBatteryLevelStream() {
    // TODO: implement getBatteryLevelStream
    throw UnimplementedError();
  }
}

void main() {
  final BatteryIndicatorPlatform initialPlatform = BatteryIndicatorPlatform.instance;

  test('$MethodChannelBatteryIndicator is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBatteryIndicator>());
  });

  test('getPlatformVersion', () async {
    BatteryIndicator batteryIndicatorPlugin = BatteryIndicator();
    MockBatteryIndicatorPlatform fakePlatform = MockBatteryIndicatorPlatform();
    BatteryIndicatorPlatform.instance = fakePlatform;

    expect(await batteryIndicatorPlugin.getPlatformVersion(), '42');
  });
}
