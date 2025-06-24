import 'package:get/get.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';

class CartBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(CartController());
  }
}