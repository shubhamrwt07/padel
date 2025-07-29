import 'package:get/get.dart';
import 'package:padel_mobile/presentations/scoreview/score_view_controoler.dart';

class ScoreViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ScoreViewController());
  }
}
