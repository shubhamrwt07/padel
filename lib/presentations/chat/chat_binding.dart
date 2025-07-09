import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}
