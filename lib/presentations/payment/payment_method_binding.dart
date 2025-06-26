import 'package:get/get.dart';
import 'package:padel_mobile/presentations/payment/payment_method_controller.dart';

class PaymentMethodBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(PaymentMethodController());
  }

}