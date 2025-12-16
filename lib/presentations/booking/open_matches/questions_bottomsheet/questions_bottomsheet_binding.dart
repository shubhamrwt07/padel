import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/open_matches/questions_bottomsheet/questions_bottomsheet_controller.dart';

class QuestionsBottomsheetBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(QuestionsBottomsheetController());
  }

}