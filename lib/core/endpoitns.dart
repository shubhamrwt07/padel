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
  static const String getClub ="${BASE_URL}court/registerCourt/getAllRegisteredCourts?limit=";
  static const String getAllActiveCourtsForSlotWise = "${BASE_URL}court/saveCourt/getAllActiveCourtsForSlotWise?";
  static const String getLocations = "${BASE_URL}court/state/getStates";
  // Cart Urls -----------------------------------------------------------------
  ///Cart Urls------------------------------------------------------------------
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
  ///Open Matches---------------------------------------------------------------
  static const String createMatches = "${BASE_URL}court/openmatch/createOpenMatch";
  static const String getAllMatches = "${BASE_URL}court/openmatch/getAllOpenMatches";
  static const String getParticularMatch = "${BASE_URL}court/openmatch/findByOpenMatchId?_id=68d2300a723257df65e574ab";
  static const String getOpenMatches = "${BASE_URL}court/openmatch/getOpenMatches";
  static const String createUserForOpenMatch = "${BASE_URL}customerSignupWithOutPassword";
  static const String addUserForOpenMatch = "${BASE_URL}court/openmatch/addPlayerToMatch";
  static const String openMatchBooking = "${BASE_URL}court/openmatch/getAllOpenMatches";
}
