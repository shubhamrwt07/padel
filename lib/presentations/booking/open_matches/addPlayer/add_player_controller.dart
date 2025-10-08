import 'package:padel_mobile/presentations/booking/open_matches/all_open_matches/all_open_match_controller.dart';
import '../../widgets/booking_exports.dart';

class AddPlayerController extends GetxController {
  OpenMatchesController? openMatchesController;
  AllOpenMatchController? allOpenMatchController;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  RxString gender = 'Male'.obs;
  RxString playerLevel = ''.obs;

  /// Updated: unique values for dropdown items
  final playerLevels = [
    {"label": "A - Top Player", "value": "A"},
    {"label": "B1 - Experienced Player", "value": "B1"},
    {"label": "B2 - Advanced Player", "value": "B2"},
    {"label": "C1 - Confident Player", "value": "C1"},
    {"label": "C2 - Intermediate Player", "value": "C2"},
    {"label": "D1 - Amateur Player", "value": "D1"},
    {"label": "D2 - Novice Player", "value": "D2"},
  ];
  var isLoading = false.obs;
  OpenMatchRepository repository = Get.put(OpenMatchRepository());
  var playerId = "".obs;
  var selectedTeam = "".obs;
  var matchId = "".obs;

  Future<void> createUser() async {
    if (isLoading.value || Get.isSnackbarOpen) return;

    if (fullNameController.text.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Enter Full Name");
    } else if (emailController.text.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Enter Email Address");
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      return SnackBarUtils.showWarningSnackBar(
          "Please Enter a Valid Email Address");
    } else if (phoneController.text.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Enter Phone Number");
    } else if (gender.value.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Select the Gender");
    } else if (playerLevel.value.isEmpty) {
      return SnackBarUtils.showWarningSnackBar(
          "Please Select the Player Level");
    }

    isLoading.value = true;
    try {
      // Map playerLevel for API (B1/B2 both become B)
      final apiLevel = playerLevel.value.startsWith("B")
          ? "B"
          : playerLevel.value.startsWith("C")
          ? "C"
          : playerLevel.value;

      final body = {
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "gender": gender.value,
        "level": apiLevel,
      };

      final response = await repository.createUserForOpenMatch(body: body);

      if (response?.status == "200" && response?.response?.sId != null) {
        playerId.value = response!.response!.sId!;
        final added = await addPlayer();

        if (added) {
          CustomLogger.logMessage(
            msg: "User Created & Player Added $body",
            level: LogLevel.info,
          );
        }
      } else {
        SnackBarUtils.showInfoSnackBar(
            response?.message ?? "Failed to create user");
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addPlayer() async {
    try {
      final body = {
        "matchId": matchId.value,
        "playerId": playerId.value,
        "team": selectedTeam.value
      };

      final response = await repository.addPlayerForOpenMatch(body: body);

      if (response?.match != null) {
        await openMatchesController?.fetchMatchesForSelection();
        await allOpenMatchController?.fetchOpenMatches();
        Get.back();
        SnackBarUtils.showSuccessSnackBar(
            response?.message ?? "Player added successfully");
        CustomLogger.logMessage(
          msg: "Player Added To the Match $body",
          level: LogLevel.info,
        );
        return true;
      } else {
        SnackBarUtils.showInfoSnackBar(
            response?.message ?? "Failed to add player");
        return false;
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
      return false;
    }
  }

  @override
  void onInit() {
    final args = Get.arguments;
    matchId.value = args["matchId"] ?? "";
    selectedTeam.value = args["team"] ?? "";

    if (args["needAllOpenMatches"] == true) {
      allOpenMatchController = Get.isRegistered<AllOpenMatchController>()
          ? Get.find<AllOpenMatchController>()
          : Get.put(AllOpenMatchController());
    }

    if (args["needOpenMatches"] == true) {
      openMatchesController = Get.isRegistered<OpenMatchesController>()
          ? Get.find<OpenMatchesController>()
          : Get.put(OpenMatchesController());
    }

    CustomLogger.logMessage(
        msg: "Match Id-> ${matchId.value}\nSelected Team-> ${selectedTeam.value}",
        level: LogLevel.info);
    super.onInit();
  }
}
