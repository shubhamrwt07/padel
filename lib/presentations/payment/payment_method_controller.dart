import 'package:get/get.dart';

import '../../generated/assets.dart';

class PaymentMethodController extends GetxController{
  var option = ''.obs;
  final List<Map<String, String>> paymentList = [
    {
      "name": "Google Pay",
      "icon": Assets.imagesIcGooglePayment,
      "value": "google_pay",
    },
    {
      "name": "PayPal",
      "icon": Assets.imagesIcPaypal,
      "value": "paypal",
    },
    {
      "name": "ApplePay",
      "icon": Assets.imagesIcApple,
      "value": "apple_pay",
    },
    {
      "name": ".... .... .... 4698",
      "icon": Assets.imagesIcMasterCardPayment,
      "value": "mastercard",
    },
  ];

}