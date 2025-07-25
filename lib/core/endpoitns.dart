class AppEndpoints {
  AppEndpoints._();
   static const String BASE_URL = "http://103.185.212.117:5070/api/customer/";
  static const String login = "${BASE_URL}customerLogin";
  static const String signUp = "${BASE_URL}customerSignup";
  static const String fetchUserProfile = "${BASE_URL}getCustomer";
  static const String updateUserProfile = "${BASE_URL}updateCustomer";
  static const String sendOTP = "${BASE_URL}sentOtp";
  static const String verifyOTP = "${BASE_URL}verifyOtp";
  static const String resetPassword = "${BASE_URL}forgotPassword";
  static const String getClub =
      "${BASE_URL}court/registerCourt/getAllRegisteredCourts?limit=";
  static const String getActiveCourt =
      "${BASE_URL}court/saveCourt/getAllActiveCourts?register_club_id=";
  // Cart Urls
  static const String getCartItems = "${BASE_URL}court/cart/getCartForUser";
  static const String addCartItems = "${BASE_URL}court/cart/createCarts";
  static const String removeCartItems = "${BASE_URL}court/cart/removeUserCart";
  static const String carteBooking = "${BASE_URL}court/booking/createBooking";
}
