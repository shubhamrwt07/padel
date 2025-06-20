import 'package:get/get.dart';
import 'package:padel_mobile/presentations/login/login_binding.dart';
import 'package:padel_mobile/presentations/login/login_screen.dart';
import 'package:padel_mobile/presentations/splash/splash_screen.dart';
import '../../presentations/splash/splash_binding.dart';
import 'routes_name.dart';

class Routes {
  static const String initialRoute = RoutesName.splash;

   static const Duration defaultDuration = Duration(milliseconds: 300);

  static final route = [
    GetPage(
      name: RoutesName.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: defaultDuration,
    ),
  ];
}