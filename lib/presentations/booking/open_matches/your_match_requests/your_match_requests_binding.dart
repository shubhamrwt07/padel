import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/open_matches/your_match_requests/your_match_requests_controller.dart';

class YourMatchRequestsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(YourMatchRequestsController());
  }

}