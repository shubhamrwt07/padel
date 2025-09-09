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
  // Cart Urls -----------------------------------------------------------------
  static const String getCartItems = "${BASE_URL}court/cart/getCartForUser";
  static const String addCartItems = "${BASE_URL}court/cart/createCarts";
  static const String removeCartItems = "${BASE_URL}court/cart/removeUserCart";
  static const String cancelBooking = "${BASE_URL}court/booking/updateBookingStatus";
  static const String carteBooking = "${BASE_URL}court/booking/createBooking";
  static const String bookingHistory = "${BASE_URL}court/booking/getUserBookings";
  static const String bookingConfirmation = "${BASE_URL}court/booking/findById";
  ///Review---------------------------------------------------------------------
  static const String getReview = "${BASE_URL}court/review/getReviews";
  static const String createReview = "${BASE_URL}court/review/saveCustomerReview";
  static const String createMatches = "${BASE_URL}court/openmatch/createOpenMatch";
  static const String getAllMatches = "${BASE_URL}court/openmatch/getAllOpenMatches";
  static const String getParticularMatch = "${BASE_URL}court/openmatch/findByOpenMatchId?_id=68be7b412a1d4c80ee2cc02f";
}
