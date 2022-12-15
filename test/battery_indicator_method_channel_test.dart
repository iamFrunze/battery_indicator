import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:battery_indicator/battery_indicator_method_channel.dart';

void main() {
  MethodChannelBatteryIndicator platform = MethodChannelBatteryIndicator();
  const MethodChannel channel = MethodChannel('battery_indicator');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
