import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'battery_indicator_method_channel.dart';

abstract class BatteryIndicatorPlatform extends PlatformInterface {
  /// Constructs a BatteryIndicatorPlatform.
  BatteryIndicatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static BatteryIndicatorPlatform _instance = MethodChannelBatteryIndicator();

  /// The default instance of [BatteryIndicatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelBatteryIndicator].
  static BatteryIndicatorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BatteryIndicatorPlatform] when
  /// they register themselves.
  static set instance(BatteryIndicatorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<int> getBatteryLevelStream() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<int?> getBatteryLevel() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
