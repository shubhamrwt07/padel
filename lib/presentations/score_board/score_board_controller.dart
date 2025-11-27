import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:padel_mobile/repositories/score_board_repo/score_board_repository.dart';
import 'package:uuid/uuid.dart';

class ScoreBoardController extends GetxController {
  RxList<Map<String, dynamic>> sets = <Map<String, dynamic>>[].obs;

  RxInt teamAWins = 0.obs;
  RxInt teamBWins = 0.obs;
  RxString winner = "".obs;
  RxString matchDate = "".obs;
  RxString matchTime = "".obs;
  RxString clubName = "".obs;
  RxString courtName = "".obs;

  final _uuid = Uuid();

  ///Capitalize First Word------------------------------------------------------
  String capitalizeFirstWord(String text) {
    if (text.isEmpty) return text;
    List<String> words = text.split(" ");
    String first = words.first;
    return first[0].toUpperCase() + first.substring(1).toLowerCase();
  }

  ///Get Score Board Api--------------------------------------------------------
  RxList<Map<String, dynamic>> teams = <Map<String, dynamic>>[].obs;
  var bookingId = ''.obs;
  var scoreboardId = ''.obs;
  ScoreBoardRepository repository = Get.put(ScoreBoardRepository());
  final isLoading = true.obs;
  final isAddingSet = false.obs;
  Future<void> fetchScoreBoard({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
    }

    try {
      final response = await repository.getScoreBoard(bookingId: bookingId.value);

      if (response.status == 200 && response.data!.isNotEmpty) {
        final item = response.data!.first;
        scoreboardId.value = item.sId ?? "";
        CustomLogger.logMessage(
            msg: "Using scoreboard ID: ${item.sId}", level: LogLevel.info);
        CustomLogger.logMessage(
            msg: "Teams count in response: ${item.teams?.length ?? 0}",
            level: LogLevel.info);

        matchDate.value = item.matchDate ?? "";
        matchTime.value = item.matchTime ?? "";
        clubName.value = item.clubName ?? "";
        courtName.value = item.courtName ?? "";

        teams.clear();

        if (item.teams != null && item.teams!.isNotEmpty) {
          CustomLogger.logMessage(
              msg: "Processing ${item.teams!.length} teams",
              level: LogLevel.info);

          for (int teamIndex = 0; teamIndex < item.teams!.length; teamIndex++) {
            var t = item.teams![teamIndex];

            CustomLogger.logMessage(
                msg:
                "Team ${teamIndex + 1}: ${t.name}, players: ${t.players?.length ?? 0}",
                level: LogLevel.info);

            final playersList = <Map<String, dynamic>>[];

            if (t.players != null) {
              for (var p in t.players!) {
                String fullLevel =
                    p.playerId?.level ?? p.playerId?.playerLevel ?? "";
                String levelCode = fullLevel.contains(' – ')
                    ? fullLevel.split(' – ')[0]
                    : fullLevel;

                final playerData = {
                  "name": p.playerId?.name ?? "Unknown",
                  "lastName": p.playerId?.lastName ?? "",
                  "pic": p.playerId?.profilePic ?? "",
                  "level": levelCode,
                };

                playersList.add(playerData);

                CustomLogger.logMessage(
                    msg:
                    "  Player: ${playerData['name']}, Level: ${playerData['level']}",
                    level: LogLevel.info);
              }
            }

            teams.add({
              "name": t.name ?? "Team ${teamIndex + 1}",
              "players": playersList,
            });
          }
        }

        if (teams.length < 2) {
          CustomLogger.logMessage(
              msg:
              "Only ${teams.length} team(s) in response, adding empty Team B",
              level: LogLevel.warning);
          teams.add({
            "name": "Team B",
            "players": [],
          });
        }

        sets.clear();

        if (item.sets != null && item.sets!.isNotEmpty) {
          for (var s in item.sets!) {
            int setNum = s.setNumber ?? 0;

            sets.add({
              "uniqueId": _uuid.v4(),
              "setNumber": setNum,
              "teamAScore": s.teamAScore ?? 0,
              "teamBScore": s.teamBScore ?? 0,
              "winner": s.winner ?? null,
            });
          }
        } else {
          sets.add({
            "uniqueId": _uuid.v4(),
            "setNumber": 1,
            "teamAScore": 0,
            "teamBScore": 0,
            "winner": null,
          });
        }

        sets.refresh();

        teamAWins.value = item.totalScore?.teamA ?? 0;
        teamBWins.value = item.totalScore?.teamB ?? 0;
        winner.value = item.winner?.toString() ?? "None";

        CustomLogger.logMessage(msg: "=== FINAL TEAMS ===", level: LogLevel.info);
        for (int i = 0; i < teams.length; i++) {
          final team = teams[i];
          final players = team['players'] as List;
          CustomLogger.logMessage(
              msg: "Team ${i + 1}: ${team['name']}, ${players.length} player(s)",
              level: LogLevel.info);
        }

        teams.refresh();
      }
    } catch (e, stackTrace) {
      CustomLogger.logMessage(msg: "ERROR-> $e", level: LogLevel.error);
      CustomLogger.logMessage(
          msg: "Stack: $stackTrace", level: LogLevel.error);
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }

  Future<void> createSets(int setNumber) async {
    isAddingSet.value = true;
    try {
      final body = {
        "scoreboardId": scoreboardId.value,
        "sets": [
          {"setNumber": setNumber}
        ]
      };

      final response = await repository.updateScoreBoard(data: body);

      if (response.success == true) {
        sets.add({
          "uniqueId": _uuid.v4(),
          "setNumber": setNumber,
          "teamAScore": 0,
          "teamBScore": 0,
          "winner": null,
        });

        sets.refresh();

        CustomLogger.logMessage(msg: "Set $setNumber added successfully", level: LogLevel.debug);
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "ERROR-> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("Failed to add set. Please try again.");
    } finally {
      isAddingSet.value = false;
    }
  }

  ///Remove Sets Api------------------------------------------------------------
  Future<void> removeSetsFromAPI(int setNumber) async {
    // 🔥 FIXED: Store the removed set data for potential rollback
    final removedSet = sets.firstWhere(
          (s) => s["setNumber"] == setNumber,
      orElse: () => {},
    );
    final removedIndex = sets.indexWhere((s) => s["setNumber"] == setNumber);

    try {
      final body = {
        "scoreboardId": scoreboardId.value,
        "setNumber": setNumber,
      };

      final response = await repository.updateScoreBoard(data: body, type: "remove");

      if (response.success == true) {
        CustomLogger.logMessage(
          msg: "Set $setNumber removed successfully from backend",
          level: LogLevel.info,
        );

        // ✅ Don't fetch - set is already removed from UI
      } else {
        // ❌ API failed - restore the set
        SnackBarUtils.showErrorSnackBar("Failed to remove set from server");
        if (removedSet.isNotEmpty && removedIndex != -1) {
          sets.insert(removedIndex, removedSet);
          sets.refresh();
        }
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "ERROR-> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("Failed to remove set from server");

      // ❌ API error - restore the set
      if (removedSet.isNotEmpty && removedIndex != -1) {
        sets.insert(removedIndex, removedSet);
        sets.refresh();
      }
    }
  }

  ///Add Set--------------------------------------------------------------------
  Future<void> addSet() async {
    if (sets.length < 10) {
      await createSets(_nextAvailableSetNumber());
    } else {
      SnackBarUtils.showInfoSnackBar("Limit Reached\nYou can add up to 10 sets only");
    }
  }
  int _nextAvailableSetNumber() {
    final existingNumbers = sets
        .map((s) => s["setNumber"])
        .whereType<int>()
        .toSet();

    int candidate = 1;
    while (existingNumbers.contains(candidate)) {
      candidate++;
    }
    return candidate;
  }

  @override
  void onInit() async {
    super.onInit();
    bookingId.value = Get.arguments["bookingId"];
    CustomLogger.logMessage(msg: "BOOKING ID-> ${bookingId.value}", level: LogLevel.info);
    await fetchScoreBoard();
  }

  ///Add Score------------------------------------------------------------------
  Future<void> addScore(int setNumber, int teamAScore, int teamBScore) async {
    try {
      String winner = "None";
      if (teamAScore > teamBScore) {
        winner = "Team A";
      } else if (teamBScore > teamAScore) {
        winner = "Team B";
      }

      final body = {
        "scoreboardId": scoreboardId.value,
        "sets": [
          {
            "setNumber": setNumber,
            "teamAScore": teamAScore,
            "teamBScore": teamBScore,
            "winner": winner
          }
        ]
      };
      
      final response = await repository.updateScoreBoard(data: body);
      if (response.success == true) {
        CustomLogger.logMessage(msg: "Score Added Successfully", level: LogLevel.info);
        await fetchScoreBoard(showLoader: false);
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error-> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("Failed to add score. Please try again.");
    }
  }
}