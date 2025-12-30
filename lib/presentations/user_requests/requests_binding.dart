import 'package:get/get.dart';
import 'package:padel_mobile/presentations/user_requests/requests_controller.dart';

class RequestsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(RequestsController());
  }

}