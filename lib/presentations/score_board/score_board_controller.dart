import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
class ScoreBoardController extends GetxController {
  RxList<Map<String, dynamic>> sets = <Map<String, dynamic>>[].obs;
  RxInt expandedSetIndex = (-1).obs;

  RxInt teamAWins = 0.obs;
  RxInt teamBWins = 0.obs;
  RxString winner = "None".obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with 6 sets
    for (int i = 0; i < 6; i++) {
      sets.add({"set": i + 1, "teamA": "Team A", "teamB": "Team B"});
    }
  }

  void addSet() {
    if (sets.length < 8) {
      sets.add({"set": sets.length + 1, "teamA": "Team A", "teamB": "Team B"});
    } else {
      SnackBarUtils.showInfoSnackBar("Limit Reached\nYou can add up to 8 sets only",);
    }
  }

  void toggleSetExpansion(int index) {
    expandedSetIndex.value =
    (expandedSetIndex.value == index) ? -1 : index;
  }
}