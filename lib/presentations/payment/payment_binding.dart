import 'package:get/get.dart';
import 'package:padel_mobile/presentations/payment/payment_controller.dart';

class PaymentBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(PaymentController());
  }

}