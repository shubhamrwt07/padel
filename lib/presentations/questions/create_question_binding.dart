import 'package:get/get.dart';

import 'create_questions_controller.dart';

class CreateQuestionsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(CreateQuestionsController());
  }
}