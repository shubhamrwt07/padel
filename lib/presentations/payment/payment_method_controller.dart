import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../generated/assets.dart';
import '../../services/payment_services/razorpay.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
class PaymentMethodController extends GetxController {
  var option = ''.obs;

  late RazorpayPaymentService _paymentService;

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    isProcessing.value = false;

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('Payment Successful! ID: ${response.paymentId}'),
        backgroundColor: Colors.green,
      ),
    );
    Get.toNamed(RoutesName.bookingConfirmAndCancel);

    // Here you can verify payment on your backend
    // _verifyPayment(response.paymentId!, response.orderId!, response.signature!);
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
    isProcessing.value = true;

    try {
      await _paymentService.initiatePayment(
        keyId: 'rzp_test_1DP5mmOlF5G5ag',
        amount: 100.0,
        currency: 'INR',
        name: 'Matchacha Padel',
        description: 'Paying for court 1 | Time - 8:00Am - 9:00Am',
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
