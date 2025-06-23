import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/booking/booking_binding.dart';
import 'package:padel_mobile/presentations/auth/booking/booking_screen.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_binding.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_screen.dart';
import 'package:padel_mobile/presentations/auth/sign_up/sign_up_binding.dart';
import 'package:padel_mobile/presentations/auth/sign_up/sign_up_screen.dart';
import 'package:padel_mobile/presentations/home/home_binding.dart';
import 'package:padel_mobile/presentations/home/home_screen.dart';
import 'package:padel_mobile/presentations/splash/splash_screen.dart';
import '../../presentations/auth/login/login_binding.dart';
import '../../presentations/auth/login/login_screen.dart';
import '../../presentations/splash/splash_binding.dart';
import 'routes_name.dart';

class Routes {
  static const String initialRoute = RoutesName.splash;

   static const Duration defaultDuration = Duration(milliseconds: 200);

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
    GetPage(
      name: RoutesName.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
      transition: Transition.fadeIn,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.booking,
      page: () => BookingScreen(),
      binding: BookingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
  ];
}