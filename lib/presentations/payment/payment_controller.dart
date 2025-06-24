import 'package:get/get.dart';
import 'package:padel_mobile/presentations/payment/payment_screen.dart';

import '../../generated/assets.dart';

class PaymentController extends GetxController{
  var option = ''.obs;
  final List<Map<String, String>> paymentList = [
    {
      "name": "Google Pay",
      "icon": Assets.imagesIcGooglePayment,
      "value": "google_pay",
    },
    {
      "name": "PayPal",
      "icon": Assets.imagesIcApple,
      "value": "paypal",
    },
    {
      "name": "Apple Pay",
      "icon": Assets.imagesIcApple,
      "value": "apple_pay",
    },
    {
      "name": "MasterCard",
      "icon": Assets.imagesIcMasterCardPayment,
      "value": "mastercard",
    },
  ];

}