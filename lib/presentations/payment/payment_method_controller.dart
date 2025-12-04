import 'dart:developer';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../services/payment_services/razorpay.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import '../booking/successful_screens/booking_successful_screen.dart';
import '../cart/cart_controller.dart'; // Import CartController

class PaymentMethodController extends GetxController {
  var option = ''.obs;

  late RazorpayPaymentService _paymentService;
  // Get CartController instance
  final CartController cartController = Get.find<CartController>();
  RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _paymentService = RazorpayPaymentService();
    // Set up payment event handlers
    _paymentService.onPaymentSuccess = _handlePaymentSuccess;
    _paymentService.onPaymentFailure = _handlePaymentFailure;
    _paymentService.onExternalWallet = _handleExternalWallet;
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isProcessing.value = false;

    Get.generalDialog(
      barrierDismissible: false,
      barrierColor: Colors.white, // full white background
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Colors.white, // again ensure full white
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingWidget(color: AppColors.primaryColor, size: 30),
                const SizedBox(height: 20),
                const Text(
                  "Booking in progress...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please wait while we confirm your booking.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );


    await _processBookingAfterPayment();
  }


  void _handlePaymentFailure(PaymentFailureResponse response) {
    isProcessing.value = false;
    Get.back();
    SnackBarUtils.showErrorSnackBar("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    isProcessing.value = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('External Wallet: ${response.walletName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Process booking after successful payment
// Process booking after successful payment
//   Future<void> _processBookingAfterPayment() async {
//     try {
//       final cartItems = cartController.cartItems;
//
//       if (cartItems.isEmpty) {
//         Get.snackbar("Empty Cart", "Please add items to cart.");
//         return;
//       }
//
//       final bookSessionController = Get.find<BookSessionController>();
//
//       final List<Map<String, dynamic>> slotData = [];
//
//       for (var cart in cartItems) {
//         for (var slot in cart.slot ?? []) {
//           for (var slotTime in slot.slotTimes ?? []) {
//             // ✅ Parse bookingDate to weekday
//             DateTime? bookingDate;
//             if (slotTime.bookingDate != null && slotTime.bookingDate!.isNotEmpty) {
//               bookingDate = DateTime.tryParse(slotTime.bookingDate!);
//             }
//
//             String bookingDay = "";
//             if (bookingDate != null) {
//               switch (bookingDate.weekday) {
//                 case 1:
//                   bookingDay = "Monday";
//                   break;
//                 case 2:
//                   bookingDay = "Tuesday";
//                   break;
//                 case 3:
//                   bookingDay = "Wednesday";
//                   break;
//                 case 4:
//                   bookingDay = "Thursday";
//                   break;
//                 case 5:
//                   bookingDay = "Friday";
//                   break;
//                 case 6:
//                   bookingDay = "Saturday";
//                   break;
//                 case 7:
//                   bookingDay = "Sunday";
//                   break;
//               }
//             }
//
//             // ✅ Filter only that day's business hour
//             final selectedBusinessHour = cart.registerClubId?.businessHours
//                 ?.where((bh) => bh.day == bookingDay)
//                 .map((bh) => {
//               "time": bh.time ?? "",
//               "day": bh.day ?? "",
//             })
//                 .toList() ??
//                 [];
//
//             slotData.add({
//               "slotId": slotTime.slotId ?? "",
//               "businessHours": selectedBusinessHour,
//               "slotTimes": [
//                 {
//                   "time": slotTime.time ?? "",
//                   "amount": slotTime.amount ?? 0,
//                 }
//               ],
//               // ✅ Use BookSessionController values
//               "courtId": bookSessionController.courtId.value,
//               "courtName": bookSessionController.courtName.value,
//               "bookingDate": slotTime.bookingDate ?? "",
//             });
//           }
//         }
//       }
//
//       final registerClubId = cartItems.first.registerClubId?.sId;
//       final ownerId = cartItems.first.registerClubId?.ownerId;
//
//       if (registerClubId == null || registerClubId.isEmpty || slotData.isEmpty) {
//         Get.snackbar("Error", "Invalid cart data - missing required fields");
//         return;
//       }
//
//       final String confirmedAt = DateTime.now().toIso8601String();
//
//       final Map<String, dynamic> bookingPayload = {
//         "slot": slotData,
//         "register_club_id": registerClubId,
//         "confirmedAt": confirmedAt,
//       };
//
//       if (ownerId != null && ownerId.isNotEmpty) {
//         bookingPayload["ownerId"] = ownerId;
//       }
//
//       log("Booking payload after payment: ${bookingPayload.toString()}");
//
//       await cartController.bookCart(data: bookingPayload);
//
//       Get.to(() => BookingSuccessfulScreen());
//     } catch (e) {
//       log("Error processing booking after payment: $e");
//       Get.snackbar(
//         "Booking Error",
//         "Payment successful but booking failed: ${e.toString()}",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 5),
//       );
//     }
//   }
  Future<void> _processBookingAfterPayment() async {
    try {
      final bookingPayload = cartController.buildBookingPayload();

      if (bookingPayload == null) {
        Get.back();
        Get.snackbar("Error", "No selected items available for booking");
        return;
      }

      log("Booking payload after payment: $bookingPayload");

      // ⬅️ Get true/false from bookCart()
      bool success = await cartController.bookCart(data: bookingPayload);

      if (success) {
        // 👍 Booking success
        SnackBarUtils.showSuccessSnackBar("Booking completed successfully");
        Get.to(() => BookingSuccessfulScreen());
      } else {
        // ❌ API returned error
        Get.close(2);  // close "booking in progress"
        showBookingErrorDialog();

      }
    } catch (e) {
      log("Error processing booking after payment: $e");

      Get.close(2); // ⬅️ close dialog
      showBookingErrorDialog();

      // Get.snackbar(
      //   "Booking Error",
      //   "Payment successful but booking failed: ${e.toString()}",
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  void showBookingErrorDialog() {
    Get.generalDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 80,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Booking Failed",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Your booking could not be completed right now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Your payment has been received successfully, "
                        "but we couldn't confirm your booking at this moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Please contact support for assistance or a refund.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Go Home button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.offAllNamed(RoutesName.bottomNav);
                      },
                      child: const Text(
                        "Go to Home",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Help & Support button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(RoutesName.support);
                      },
                      child: Text(
                        "Help & Support",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> verifyPayment(
      String paymentId,
      String orderId,
      String signature,
      ) async {
    // TODO: Implement server-side payment verification
    // Send paymentId, orderId, and signature to your backend for verification
    debugPrint('Verifying payment: $paymentId, $orderId, $signature');
  }

  Future<void> startPayment() async {
    if (option.value.isEmpty) {
      Get.snackbar("Payment Method", "Please select a payment method");
      return;
    }

    isProcessing.value = true;

    try {
      await _paymentService.initiatePayment(
        keyId: 'rzp_test_1DP5mmOlF5G5ag',
        amount: cartController.totalPrice.value.toDouble(), // Use dynamic amount from cart
        currency: 'INR',
        name: 'Matchacha Padel',
        description: 'Paying for court booking',
        orderId: '',
        userEmail: 'test@example.com',
        userContact: '9999999999',
        notes: {'user_id': '123', 'product_id': 'abc'},
        theme: '#1F41BB',
      );
    } catch (e) {
      isProcessing.value = false;
      CustomLogger.logMessage(msg: "Error: $e",level: LogLevel.error);
    }finally{
      isProcessing.value = false;
    }
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  final List<Map<String, String>> paymentList = [
    {
      "name": "Google Pay",
      "icon": Assets.imagesIcGooglePayment,
      "value": "google_pay",
    },
    {"name": "PayPal", "icon": Assets.imagesIcPaypal, "value": "paypal"},
    {"name": "ApplePay", "icon": Assets.imagesIcApple, "value": "apple_pay"},
    {
      "name": ".... .... .... 4698",
      "icon": Assets.imagesIcMasterCardPayment,
      "value": "mastercard",
    },
  ];
}
