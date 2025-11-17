import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:padel_mobile/repositories/score_board_repo/score_board_repository.dart';
class ScoreBoardController extends GetxController {
  RxList<Map<String, dynamic>> sets = <Map<String, dynamic>>[].obs;
  RxInt expandedSetIndex = (-1).obs;

  RxInt teamAWins = 0.obs;
  RxInt teamBWins = 0.obs;
  RxString winner = "None".obs;
  RxString matchDate = "".obs;
  RxString matchTime = "".obs;
  RxString clubName = "".obs;
  RxString courtName = "".obs;

  @override
  void onInit()async {
    super.onInit();
    bookingId.value = Get.arguments["bookingId"];
    CustomLogger.logMessage(msg: "BOOKING ID-> ${bookingId.value}", level: LogLevel.info);
    await fetchScoreBoard();
    sets.addAll([
      {"set": 1, "scores": []},
      {"set": 2, "scores": []},
    ]);

    expandedSetIndex.value = -1; // keep collapsed by default
  }

  void addSet() {
    if (sets.length < 10) {
      sets.add({"set": sets.length + 1, "teamA": "Team A", "teamB": "Team B"});
    } else {
      SnackBarUtils.showInfoSnackBar("Limit Reached\nYou can add up to 8 sets only",);
    }
  }

  void toggleSetExpansion(int index) {
    expandedSetIndex.value =
    (expandedSetIndex.value == index) ? -1 : index;
  }
  RxList<Map<String, dynamic>> teams = <Map<String, dynamic>>[].obs;
  var bookingId = ''.obs;
  var scoreboardId = ''.obs;
  ScoreBoardRepository repository = Get.put(ScoreBoardRepository());
  final isLoading = true.obs;

  Future<void> fetchScoreBoard() async {
    isLoading.value = true;
    try {
      final response = await repository.getScoreBoard(bookingId: bookingId.value);

      if (response.status == 200 && response.data!.isNotEmpty) {
        // Just use the first scoreboard
        final item = response.data!.first;
        scoreboardId.value = item.sId??"";
        CustomLogger.logMessage(
            msg: "Using scoreboard ID: ${item.sId}",
            level: LogLevel.info
        );
        CustomLogger.logMessage(
            msg: "Teams count in response: ${item.teams?.length ?? 0}",
            level: LogLevel.info
        );

        /// Update Match Info
        matchDate.value = item.matchDate ?? "";
        matchTime.value = item.matchTime ?? "";
        clubName.value = item.clubName ?? "";
        courtName.value = item.courtName ?? "";

        // Clear and rebuild teams
        teams.clear();

        if (item.teams != null && item.teams!.isNotEmpty) {
          CustomLogger.logMessage(
              msg: "Processing ${item.teams!.length} teams",
              level: LogLevel.info
          );

          for (int teamIndex = 0; teamIndex < item.teams!.length; teamIndex++) {
            var t = item.teams![teamIndex];

            CustomLogger.logMessage(
                msg: "Team ${teamIndex + 1}: ${t.name}, players: ${t.players?.length ?? 0}",
                level: LogLevel.info
            );

            final playersList = <Map<String, dynamic>>[];

            if (t.players != null) {
              for (var p in t.players!) {
                final playerData = {
                  "name": p.playerId?.name ?? "Unknown",
                  "pic": p.playerId?.profilePic ?? "",
                };

                playersList.add(playerData);

                CustomLogger.logMessage(
                    msg: "  Player: ${playerData['name']}",
                    level: LogLevel.info
                );
              }
            }

            teams.add({
              "name": t.name ?? "Team ${teamIndex + 1}",
              "players": playersList,
            });
          }
        }

        // Ensure we always have 2 teams
        if (teams.length < 2) {
          CustomLogger.logMessage(
              msg: "Only ${teams.length} team(s) in response, adding empty Team B",
              level: LogLevel.warning
          );
          teams.add({
            "name": "Team B",
            "players": [],
          });
        }

        /// Update Sets
        // sets.clear();
        if (item.sets != null && item.sets!.isNotEmpty) {
          for (var s in item.sets!) {
            sets.add({
              "set": s.setNumber,
              "teamA": s.teamAScore,
              "teamB": s.teamBScore,
              "rounds": s.rounds
            });
          }
        }

        /// Summary
        teamAWins.value = item.totalScore?.teamA ?? 0;
        teamBWins.value = item.totalScore?.teamB ?? 0;
        winner.value = item.winner?.toString() ?? "None";

        // Final verification
        CustomLogger.logMessage(
            msg: "=== FINAL TEAMS ===",
            level: LogLevel.info
        );
        for (int i = 0; i < teams.length; i++) {
          final team = teams[i];
          final players = team['players'] as List;
          CustomLogger.logMessage(
              msg: "Team ${i + 1}: ${team['name']}, ${players.length} player(s)",
              level: LogLevel.info
          );
        }

        teams.refresh();
      }
    } catch (e, stackTrace) {
      CustomLogger.logMessage(msg: "ERROR-> $e", level: LogLevel.error);
      CustomLogger.logMessage(msg: "Stack: $stackTrace", level: LogLevel.error);
    }finally{
      isLoading.value = false;

    }
  }
}