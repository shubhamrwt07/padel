import 'package:get/get.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';
import 'package:padel_mobile/presentations/payment_filter/payment_filter_controller.dart';

class  PaymentFilterBinding implements Bindings{
  @override
  void dependencies() {
    Get.put( PaymentFilterController());
  }
}