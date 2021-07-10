import 'package:app/src/slices/data_screen/data_screen_service.dart';
import 'package:app/src/slices/intro_screen/intro_screen_service.dart';
import 'package:app/src/slices/login_screen/login_screen_service.dart';

class AppModelRoutes {
  static var home = DataScreenService();
  static var login = LoginScreenService();
  static var intro = IntroScreenService();
}
