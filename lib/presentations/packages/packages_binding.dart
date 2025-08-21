import 'package:get/get.dart';
import 'package:padel_mobile/presentations/packages/packages_controller.dart';

class PackagesBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(PackagesController());
  }
}