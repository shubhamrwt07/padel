import 'package:intl/intl.dart';
import '../../../../data/request_models/home_models/get_club_name_model.dart';
import '../../widgets/booking_exports.dart';
class AllOpenMatchController extends GetxController {
  final OpenMatchRepository repository = OpenMatchRepository();

  Rx<AllOpenMatches?> matchesBySelection = Rx<AllOpenMatches?>(null);
  RxBool isLoading = false.obs;
  List<String> playerLevels = [
    'All Players',
    'A',
    'B',
    'C',
    'D',
    'A/B',
    'B/C',
    'C/D',
  ];
  ///Day and Date format--------------------------------------------------------
  String getDay(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('EEEE').format(parsed); // e.g. Monday
    } catch (_) {
      return ymd;
    }
  }
  String getDate(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('dd MMMM').format(parsed); // e.g. 16 September
    } catch (_) {
      return ymd;
    }
  }

  //Filter----------------------------------------------------------------------
  var selectedTiming = ''.obs;
  RxString selectedLevel = ''.obs;

  void clearAll() {
    selectedDate.value = DateTime.now();
    selectedTiming.value = '';
    selectedLevel.value = '';
  }

  //Select DATE-----------------------------------------------------------------
  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }
  Courts club = Courts();
  @override
  void onInit() async{
    club =Get.arguments["club"];
    await fetchOpenMatches();
    super.onInit();
  }

  /// Fetch Open Matched
  Future<void> fetchOpenMatches() async {
    try {
      isLoading.value = true;
      final repo = OpenMatchRepository();
      final response = await repo.getMatchesByDateTime(
        matchDate: "",
        matchTime: "",
        cubId: club.id??"",
      );
      matchesBySelection.value = response;
    } catch (e) {
      CustomLogger.logMessage(msg: "Error -> $e", level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

}
