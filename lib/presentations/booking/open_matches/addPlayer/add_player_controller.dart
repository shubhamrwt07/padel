import 'package:padel_mobile/presentations/booking/open_matches/all_open_matches/all_open_match_controller.dart';
import 'package:padel_mobile/presentations/openmatchbooking/openmatch_booking_controller.dart';
import 'package:padel_mobile/presentations/score_board/score_board_controller.dart';
import 'package:padel_mobile/repositories/score_board_repo/score_board_repository.dart';
import '../../widgets/booking_exports.dart';

class AddPlayerController extends GetxController {
  OpenMatchesController? openMatchesController;
  AllOpenMatchController? allOpenMatchController;
  OpenMatchBookingController? openMatchBookingController;
  ScoreBoardController? scoreBoardController;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  RxString gender = ''.obs;
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
      // Send exact selected level code (e.g., A, B1, B2, C1...)
      final apiLevel = playerLevel.value;

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

        // ---------- Add Player For Open Matches ----------
        if (allOpenMatchController != null) {
          final added = await addPlayer();
          if (added) {
            CustomLogger.logMessage(
              msg: "User Created & Player Added $body",
              level: LogLevel.info,
            );
          }
        }else if (openMatchesController != null){
          final added = await addPlayer();
          if (added) {
            CustomLogger.logMessage(
              msg: "User Created & Player Added $body",
              level: LogLevel.info,
            );
          }
        }else if (openMatchBookingController != null){
          final added = await addPlayer();
          if (added) {
            CustomLogger.logMessage(
              msg: "User Created & Player Added $body",
              level: LogLevel.info,
            );
          }
        }

        // ---------- Add Player As Guest ----------
        else if (scoreBoardController != null) {
          final added = await addGuestPlayer();
          if (added) {
            CustomLogger.logMessage(
              msg: "Guest User Created & Added $body",
              level: LogLevel.info,
            );
          }
        }

        return;
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

  ///Add Player In Open Match Api-----------------------------------------------
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
        await openMatchBookingController?.fetchOpenMatchesBooking(type: "upcoming");
        // Return success to caller so it can refresh immediately
        Get.back(result: true);
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

  ///Add Guest Player in the Simple Match---------------------------------------
  ScoreBoardRepository scoreBoardRepository = Get.put(ScoreBoardRepository());
  var scoreboardId = ''.obs;
  Future<bool> addGuestPlayer() async {
    try {
      final body = {
        "scoreboardId": scoreboardId.value,
        "teams": [
          {
            "name": selectedTeam.value,
            "players": [
              {
                "playerId": playerId.value
              }
            ]
          }
        ]
      };
      final response = await scoreBoardRepository.addGuestPlayer(body: body);

      if (response?.data != null) {
        await scoreBoardController?.fetchScoreBoard();
        Get.back(result: true);
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
  @override
  void onInit() {
    final args = Get.arguments;

    matchId.value = args["matchId"] ?? "";
    selectedTeam.value = args["team"] ?? "";
    scoreboardId.value = args["scoreBoardId"] ?? "";

    if (args["needAllOpenMatches"] == true &&
        Get.isRegistered<AllOpenMatchController>()) {
      allOpenMatchController = Get.find<AllOpenMatchController>();
    }
    if (args["needBottomAllOpenMatches"] == true &&
        Get.isRegistered<OpenMatchBookingController>()) {
      openMatchBookingController = Get.find<OpenMatchBookingController>();
    }

    if (args["needOpenMatches"] == true &&
        Get.isRegistered<OpenMatchesController>()) {
      openMatchesController = Get.find<OpenMatchesController>();
    }

    if (args["needAsGuest"] == true &&
        Get.isRegistered<ScoreBoardController>()) {
      scoreBoardController = Get.find<ScoreBoardController>();
    }

    super.onInit();
  }
}
