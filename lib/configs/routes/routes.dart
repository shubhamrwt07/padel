import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_binding.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_screen.dart';
import 'package:padel_mobile/presentations/auth/otp/otp_binding.dart';
import 'package:padel_mobile/presentations/auth/otp/otp_screen.dart';
import 'package:padel_mobile/presentations/auth/sign_up/sign_up_binding.dart';
import 'package:padel_mobile/presentations/auth/sign_up/sign_up_screen.dart';
import 'package:padel_mobile/presentations/bookinghistory/booking_history_binding.dart';
import 'package:padel_mobile/presentations/bookinghistory/booking_history_screen.dart';
import 'package:padel_mobile/presentations/booking/booking_binding.dart';
import 'package:padel_mobile/presentations/booking/booking_confirmation/booking_confirmAndCancel_binding.dart';
import 'package:padel_mobile/presentations/booking/booking_confirmation/booking_confirmAndCancel_screen.dart';
import 'package:padel_mobile/presentations/booking/booking_screen.dart';
import 'package:padel_mobile/presentations/bottomnav/bottom_nav.dart';
import 'package:padel_mobile/presentations/home/home_binding.dart';
import 'package:padel_mobile/presentations/home/home_screen.dart';
import 'package:padel_mobile/presentations/payment_filter/payment_filter.dart';
import 'package:padel_mobile/presentations/payment_filter/payment_filter_binding.dart';
import 'package:padel_mobile/presentations/paymentwallet/payment_wallet_binding.dart';
import 'package:padel_mobile/presentations/paymentwallet/payment_wallet_screen.dart';
import 'package:padel_mobile/presentations/profile/profile_binding.dart';
import 'package:padel_mobile/presentations/cart/cart_binding.dart';
import 'package:padel_mobile/presentations/cart/cart_screen.dart';
import 'package:padel_mobile/presentations/payment/payment_method_binding.dart';
import 'package:padel_mobile/presentations/payment/payment_method_screen.dart';
import 'package:padel_mobile/presentations/splash/splash_screen.dart';
import 'package:padel_mobile/presentations/support/support_binding.dart';
import 'package:padel_mobile/presentations/support/support_screen.dart';
import '../../presentations/auth/login/login_binding.dart';
import '../../presentations/auth/login/login_screen.dart';
import '../../presentations/bottomnav/bottom_nav_binding.dart';
import '../../presentations/profile/profile_screen.dart';
import '../../presentations/splash/splash_binding.dart';
import 'routes_name.dart';
class Routes {
  static const String initialRoute = RoutesName.bottomNav;

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
      page: () =>   LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.otp,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.forgotPassword,
      curve: Curves.easeIn,
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
      name: RoutesName.bottomNav,
      page: () => BottomNavUi(),
      binding: BottomNavigationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.profile,
      page: () => ProfileUi(),
      binding: ProfileBinding(),
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
    GetPage(
      name: RoutesName.cart,
      page: () => CartScreen(buttonType: '',),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.paymentMethod,
      page: () => PaymentMethodScreen(),
      binding: PaymentMethodBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.bookingHistory,
      page: () => BookingHistoryUi(),
      binding: BookingHistoryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),    GetPage(
      name: RoutesName.paymentWallet,
      page: () => PaymentWalletScreen(),
      binding: PaymentWalletBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),
    GetPage(
      name: RoutesName.bookingConfirmAndCancel,
      page: () => BookingConfirmAndCancelScreen(),
      binding: BookingConfirmAndCancelBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),  GetPage(
      name: RoutesName.paymentFilter,
      page: () => PaymentFilterUi(),
      binding: PaymentFilterBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    ),GetPage(
      name: RoutesName.support,
      page: () => SupportScreen(),
      binding: SupportBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: defaultDuration,
    )
  ];
}
