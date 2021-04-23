import 'package:app_stash/src/app.dart';
import 'package:app_stash/src/config/config_sentry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SentryFlutter.init(
      (options) async => options
        ..dsn = ConfigSentry.dsn
        ..environment = ConfigSentry.environment
        ..release = (await PackageInfo.fromPlatform()).version
        ..sendDefaultPii = false,
      appRunner: () => runApp(App()));
}
