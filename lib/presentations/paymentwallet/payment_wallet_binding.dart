import 'package:get/get.dart';
import 'package:padel_mobile/presentations/paymentwallet/payment_wallet_controller.dart';

class PaymentWalletBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(PaymentWalletController());
  }
}