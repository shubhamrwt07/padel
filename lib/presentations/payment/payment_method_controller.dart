import 'dart:developer';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../generated/assets.dart';
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

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('Payment Successful! Processing booking...'),
        backgroundColor: Colors.green,
      ),
    );

    // Call booking API after successful payment
    await _processBookingAfterPayment();
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    isProcessing.value = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
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
  Future<void> _processBookingAfterPayment() async {
    try {
      final cartItems = cartController.cartItems;

      if (cartItems.isEmpty) {
        Get.snackbar("Empty Cart", "Please add items to cart.");
        return;
      }

      final List<Map<String, dynamic>> slotData = [];

      for (var cart in cartItems) {
        for (var slot in cart.slot ?? []) {
          for (var slotTime in slot.slotTimes ?? []) {
            // ✅ Parse bookingDate to weekday
            DateTime? bookingDate;
            if (slotTime.bookingDate != null && slotTime.bookingDate!.isNotEmpty) {
              bookingDate = DateTime.tryParse(slotTime.bookingDate!);
            }

            String bookingDay = "";
            if (bookingDate != null) {
              switch (bookingDate.weekday) {
                case 1:
                  bookingDay = "Monday";
                  break;
                case 2:
                  bookingDay = "Tuesday";
                  break;
                case 3:
                  bookingDay = "Wednesday";
                  break;
                case 4:
                  bookingDay = "Thursday";
                  break;
                case 5:
                  bookingDay = "Friday";
                  break;
                case 6:
                  bookingDay = "Saturday";
                  break;
                case 7:
                  bookingDay = "Sunday";
                  break;
              }
            }

            // ✅ Filter only that day's business hour
            final selectedBusinessHour = cart.registerClubId?.businessHours
                ?.where((bh) => bh.day == bookingDay)
                .map((bh) => {
              "time": bh.time ?? "",
              "day": bh.day ?? "",
            })
                .toList() ??
                [];

            slotData.add({
              "slotId": slotTime.slotId ?? "",
              "businessHours": selectedBusinessHour, // ✅ only selected day
              "slotTimes": [
                {
                  "time": slotTime.time ?? "",
                  "amount": slotTime.amount ?? 0,
                }
              ],
              "courtId": cart.sId ?? "",
              "bookingDate": slotTime.bookingDate ?? "",
              "courtName": cart.courtName ?? "",
            });
          }
        }
      }

      final registerClubId = cartItems.first.registerClubId?.sId;
      final ownerId = cartItems.first.registerClubId?.ownerId;

      if (registerClubId == null || registerClubId.isEmpty || slotData.isEmpty) {
        Get.snackbar("Error", "Invalid cart data - missing required fields");
        return;
      }

      // ✅ Add current timestamp
      final String confirmedAt = DateTime.now().toIso8601String();

      // ✅ Booking payload with current time
      final Map<String, dynamic> bookingPayload = {
        "slot": slotData,
        "register_club_id": registerClubId,
        "confirmedAt": confirmedAt, // ⏰ Add current booking confirmation time
      };

      if (ownerId != null && ownerId.isNotEmpty) {
        bookingPayload["ownerId"] = ownerId;
      }

      log("Booking payload after payment: ${bookingPayload.toString()}");

      await cartController.bookCart(data: bookingPayload);

      Get.to(() => BookingSuccessfulScreen());
    } catch (e) {
      log("Error processing booking after payment: $e");
      Get.snackbar(
        "Booking Error",
        "Payment successful but booking failed: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
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

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<String> generateOrderId() async {
    return '';
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
