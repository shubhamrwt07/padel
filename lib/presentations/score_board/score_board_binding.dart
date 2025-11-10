import 'package:get/get.dart';
import 'package:padel_mobile/presentations/score_board/score_board_controller.dart';

class ScoreBoardBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ScoreBoardController());
  }

}