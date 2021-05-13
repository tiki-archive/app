import 'package:amplitude_flutter/amplitude.dart';
import 'package:app/src/config/config_environment.dart';

/// The anonymous analytics wrapper.
///
/// The analaytics wrapper is used to track in-app events anonymously. All events
/// tracking should be handled through this class to make it decoupled from remote
/// platforms. It now uses [Amplitude] as analytics provider.
class TikiAnalytics {

  /// The analytics logger.
  static var _logger;
  /// The analytics logger for testing.
  static var _loggerTest;

  static const String environment = ConfigEnvironment.appEnv;

  /// Initializes the analytics environment.
  ///
  /// Initializes the analytics environment depending on the [environment] parameter and
  /// loads the instance into [_logger] or [_loggerTest].
  static Future<void> _init({test = false}) async {
    const bool test = environment == ConfigEnvironment.envLocal;
    const prodApiKey = "1899ef0929b6700fffbb438c1df4fe2f";
    const testApiKey = "6f52993a138d9209786c76a03c4e25cf";
    var project = test ? "App-test" : "App";
    String apiKey = test ? testApiKey : prodApiKey;
    final Amplitude _logger = Amplitude.getInstance(instanceName: project);
    _logger.init(apiKey);
    _logger.logEvent('Amplitude startup');
  }

  /// Gets the logger instance.
  static dynamic getLogger() async{
    const bool test = environment == ConfigEnvironment.envLocal;
    var logger = test ? _loggerTest : _logger;
    if(logger == null){
      _init(test: test);
    }
  }
}
