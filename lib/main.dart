import 'package:app/src/slices/api_blockchain/api_blockchain_service.dart';
import 'package:app/src/slices/api_bouncer/api_bouncer_service.dart';
import 'package:app/src/slices/api_google/api_google_service.dart';
import 'package:app/src/slices/api_signup/api_signup_service.dart';
import 'package:app/src/slices/api_user/api_user_service.dart';
import 'package:app/src/slices/login_flow/login_flow_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'src/config/config_sentry.dart';
import 'src/utils/api/helper_api_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  ApiUserService apiUserService = ApiUserService(FlutterSecureStorage());
  LoginFlowService loginFlowService = LoginFlowService();
  ApiBouncerService apiBouncerService = ApiBouncerService();
  HelperApiAuth helperApiAuth =
      HelperApiAuth(loginFlowService, apiBouncerService);
  ApiBlockchainService apiBlockchainService =
      ApiBlockchainService(helperApiAuth);
  ApiGoogleService apiGoogleService = ApiGoogleService();

  await loginFlowService.initialize(
      apiUserService: apiUserService,
      apiBouncerService: apiBouncerService,
      apiBlockchainService: apiBlockchainService,
      logoutCallbacks: [() async => await apiGoogleService.signOut()]);

  SentryFlutter.init(
      (options) async => options
        ..dsn = ConfigSentry.dsn
        ..environment = ConfigSentry.environment
        ..release = (await PackageInfo.fromPlatform()).version
        ..sendDefaultPii = false,
      appRunner: () => runApp(MultiProvider(
            providers: [
              Provider<ApiUserService>.value(value: apiUserService),
              Provider<ApiBouncerService>.value(value: apiBouncerService),
              Provider<ApiBlockchainService>.value(value: apiBlockchainService),
              Provider<ApiSignupService>(create: (_) => ApiSignupService()),
              Provider<ApiGoogleService>.value(value: apiGoogleService)
            ],
            child: App(loginFlowService),
          )));
}
