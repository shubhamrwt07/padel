import 'dart:async';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/repositories/score_board_repo/score_board_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

class ScoreBoardController extends GetxController {
  RxList<Map<String, dynamic>> sets = <Map<String, dynamic>>[].obs;

  RxInt teamAWins = 0.obs;
  RxInt teamBWins = 0.obs;
  RxString winner = "".obs;
  RxString matchDate = "".obs;
  RxString matchTime = "".obs;
  RxString clubName = "".obs;
  RxString courtName = "".obs;
  RxBool isCompleted = false.obs;

  final _uuid = Uuid();
  
  // Stream controller for periodic updates
  late StreamController<Map<String, dynamic>> _scoreboardStreamController;
  late Timer _periodicTimer;
  
  Stream<Map<String, dynamic>> get scoreboardStream => _scoreboardStreamController.stream;

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
  var openMatchId = ''.obs;
  ScoreBoardRepository repository = Get.put(ScoreBoardRepository());
  final isLoading = true.obs;
  final isAddingSet = false.obs;
  final isAddingScore = false.obs;
  final isShuffleMode = false.obs;
  final hasPlayerSwaps = false.obs;
  var matchBookingId = ''.obs;
  Future<void> fetchScoreBoard({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
    }

    try {
      final response = await repository.getScoreBoard(bookingId: bookingId.value);

      if (response.status == 200 && response.data!.isNotEmpty) {
        final item = response.data!.first;
        scoreboardId.value = item.sId ?? "";
        openMatchId.value = item.bookingId?.openMatchId ?? "";
        matchBookingId.value = item.bookingId?.sId??"";
        CustomLogger.logMessage(
            msg: "Using scoreboard ID: ${item.sId}", level: LogLevel.info);
        CustomLogger.logMessage(
            msg: "Open Match ID from API: ${item.bookingId?.openMatchId}", level: LogLevel.info);
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
                  "playerId": p.playerId?.sId ?? p.playerId?.sId ?? "",
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
              "winner": s.winner,
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
        isCompleted.value = item.isCompleted ?? false;

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

  Future<void> createSets(int setNumber, {String? type}) async {
    CustomLogger.logMessage(msg: 'createSets API call - setNumber: $setNumber', level: LogLevel.info);
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
    CustomLogger.logMessage(msg: 'removeSetsFromAPI call - setNumber: $setNumber', level: LogLevel.info);
    // 🔥 FIXED: Store the removed set data for potential rollback
    final removedSet = sets.firstWhere(
          (s) => s["setNumber"] == setNumber,
      orElse: () => {},
    );
    final removedIndex = sets.indexWhere((s) => s["setNumber"] == setNumber);

    try {
      final body = {
        "scoreboardId": scoreboardId.value,
        'type': 'remove',
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
    openMatchId.value = Get.arguments["openMatchId"] ?? "";
    CustomLogger.logMessage(msg: "BOOKING ID-> ${bookingId.value}", level: LogLevel.info);
    CustomLogger.logMessage(msg: "OPEN MATCH ID-> ${openMatchId.value}", level: LogLevel.info);
    
    _scoreboardStreamController = StreamController<Map<String, dynamic>>.broadcast();
    await fetchScoreBoard();
    _startPeriodicUpdates();
  }
  
  void _startPeriodicUpdates() {
    _periodicTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await _fetchScoreBoardForStream();
    });
  }
  
  Future<void> _fetchScoreBoardForStream() async {
    try {
      if (_scoreboardStreamController.isClosed) return;
      
      final response = await repository.getScoreBoard(bookingId: bookingId.value);
      if (response.status == 200 && response.data!.isNotEmpty) {
        final item = response.data!.first;
        
        // Update sets
        sets.clear();
        if (item.sets != null && item.sets!.isNotEmpty) {
          for (var s in item.sets!) {
            sets.add({
              "uniqueId": _uuid.v4(),
              "setNumber": s.setNumber ?? 0,
              "teamAScore": s.teamAScore ?? 0,
              "teamBScore": s.teamBScore ?? 0,
              "winner": s.winner,
            });
          }
        }
        sets.refresh();
        
        // Update scores
        teamAWins.value = item.totalScore?.teamA ?? 0;
        teamBWins.value = item.totalScore?.teamB ?? 0;
        winner.value = item.winner?.toString() ?? "None";
        isCompleted.value = item.isCompleted ?? false;
        
        if (!_scoreboardStreamController.isClosed) {
          _scoreboardStreamController.add({'updated': true});
        }
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Stream fetch error: $e", level: LogLevel.error);
    }
  }
  
  @override
  void onClose() {
    _periodicTimer.cancel();
    if (!_scoreboardStreamController.isClosed) {
      _scoreboardStreamController.close();
    }
    super.onClose();
  }

  ///Add Score------------------------------------------------------------------
  Future<void> addScore(int setNumber, int teamAScore, int teamBScore) async {
    CustomLogger.logMessage(msg: 'addScore API call - set: $setNumber, scores: $teamAScore-$teamBScore', level: LogLevel.info);
    if (teamAScore == 0 && teamBScore == 0) {
      SnackBarUtils.showErrorSnackBar("Both team scores cannot be zero.");
      return;
    }
    isAddingScore.value = true;
    try {
      // Only send the score for the team that actually scored
      final Map<String, dynamic> setData = {
        "setNumber": setNumber,
      };
      
      if (teamAScore > 0) {
        setData["teamAScore"] = teamAScore;
      }
      if (teamBScore > 0) {
        setData["teamBScore"] = teamBScore;
      }
      
      // Only determine winner if both teams have scores
      final currentSet = sets.firstWhere((s) => s["setNumber"] == setNumber, orElse: () => {});
      final currentTeamAScore = currentSet["teamAScore"] ?? 0;
      final currentTeamBScore = currentSet["teamBScore"] ?? 0;
      
      final finalTeamAScore = teamAScore > 0 ? teamAScore : currentTeamAScore;
      final finalTeamBScore = teamBScore > 0 ? teamBScore : currentTeamBScore;
      
      if (finalTeamAScore > 0 && finalTeamBScore > 0) {
        if (finalTeamAScore > finalTeamBScore) {
          setData["winner"] = "Team A";
        } else if (finalTeamBScore > finalTeamAScore) {
          setData["winner"] = "Team B";
        }
      }

      final body = {
        "scoreboardId": scoreboardId.value,
        "sets": [setData]
      };
      
      final response = await repository.updateScoreBoard(data: body);
      if (response.success == true) {
        CustomLogger.logMessage(msg: "Score Added Successfully", level: LogLevel.info);
        await fetchScoreBoard(showLoader: false);
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error-> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("Failed to add score. Please try again.");
    } finally {
      isAddingScore.value = false;
    }
  }

  ///End Game------------------------------------------------------------------
  var isEndGame = false.obs;
  ProfileController profileController = Get.put(ProfileController());
  Future<void> endGame() async {
    CustomLogger.logMessage(msg: 'endGame API call', level: LogLevel.info);
    // Check if any set is empty (no scores)
    bool hasEmptySet = sets.any((set) {
      final teamAScore = set["teamAScore"] ?? 0;
      final teamBScore = set["teamBScore"] ?? 0;
      return teamAScore == 0 && teamBScore == 0;
    });

    if (hasEmptySet) {
      SnackBarUtils.showErrorSnackBar("Cannot end game with empty sets. Please add scores first.");
      return;
    }

    isEndGame.value = true;
    try {
      final body = {
        "scoreboardId": scoreboardId.value,
        "type": "completed"
      };

      final response = await repository.updateScoreBoard(data: body);
      
      if (response.success == true) {
        SnackBarUtils.showInfoSnackBar("Game Ended Successfully!");
        await fetchScoreBoard(showLoader: false);
        await profileController.fetchUserProfile();
      }else{
        SnackBarUtils.showErrorSnackBar(response.message??"");
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "ERROR-> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("Failed to end game. Please try again.");
    } finally {
      isEndGame.value = false;
    }
  }

  ///Check if swapping is allowed----------------------------------------------
  bool get canSwapPlayers => !isCompleted.value;

  ///Check user's team and scoring permissions----------------------------------
  String get currentUserId => profileController.profileModel.value?.response?.sId ?? '';
  
  bool get isUserInTeamA {
    if (teams.isEmpty) return false;
    final teamAPlayers = teams[0]['players'] as List;
    return teamAPlayers.any((player) => player['playerId'] == currentUserId);
  }
  
  bool get isUserInTeamB {
    if (teams.length < 2) return false;
    final teamBPlayers = teams[1]['players'] as List;
    return teamBPlayers.any((player) => player['playerId'] == currentUserId);
  }
  
  bool canScoreForTeam(String team) {
    if (team == 'Team A') return isUserInTeamA;
    if (team == 'Team B') return isUserInTeamB;
    return false;
  }

  ///Swap Players---------------------------------------------------------------
  void swapPlayers(String draggedPlayerId, String targetTeam, int targetIndex) {
    CustomLogger.logMessage(msg: 'swapPlayers called - LOCAL UPDATE ONLY', level: LogLevel.info);
    try {
      // Find dragged player and remove from current position
      Map<String, dynamic>? draggedPlayer;
      int draggedTeamIndex = -1;
      int draggedPlayerIndex = -1;
      
      for (int teamIndex = 0; teamIndex < teams.length; teamIndex++) {
        final teamPlayers = teams[teamIndex]['players'] as List;
        for (int playerIndex = 0; playerIndex < teamPlayers.length; playerIndex++) {
          if (teamPlayers[playerIndex]['playerId'] == draggedPlayerId) {
            draggedPlayer = Map<String, dynamic>.from(teamPlayers[playerIndex]);
            draggedTeamIndex = teamIndex;
            draggedPlayerIndex = playerIndex;
            break;
          }
        }
        if (draggedPlayer != null) break;
      }
      
      if (draggedPlayer == null) return;
      
      // Get target team index
      int targetTeamIndex = targetTeam == 'Team A' ? 0 : 1;
      
      // Get target player if exists
      Map<String, dynamic>? targetPlayer;
      final targetTeamPlayers = teams[targetTeamIndex]['players'] as List;
      if (targetIndex < targetTeamPlayers.length) {
        targetPlayer = Map<String, dynamic>.from(targetTeamPlayers[targetIndex]);
      }
      
      // Perform the swap in local data only - NO API CALL
      final draggedTeamPlayers = teams[draggedTeamIndex]['players'] as List;
      
      if (targetPlayer != null) {
        // Swap players
        draggedTeamPlayers[draggedPlayerIndex] = targetPlayer;
        targetTeamPlayers[targetIndex] = draggedPlayer;
      } else {
        // Move player to empty slot
        draggedTeamPlayers.removeAt(draggedPlayerIndex);
        if (targetIndex < targetTeamPlayers.length) {
          targetTeamPlayers[targetIndex] = draggedPlayer;
        } else {
          targetTeamPlayers.add(draggedPlayer);
        }
      }
      
      hasPlayerSwaps.value = true; // Mark that swaps occurred
      teams.refresh();
      CustomLogger.logMessage(msg: 'Local swap completed - NO API CALL MADE', level: LogLevel.info);
    } catch (e) {
      CustomLogger.logMessage(msg: 'Swap error: $e', level: LogLevel.error);
    }
  }

  ///Move Player to Empty Slot-------------------------------------------------
  void movePlayerToEmptySlot(String playerId, String targetTeam, int targetIndex) {
    CustomLogger.logMessage(msg: 'movePlayerToEmptySlot called', level: LogLevel.info);
    try {
      // Find the player to move
      Map<String, dynamic>? playerToMove;
      int sourceTeamIndex = -1;
      int sourcePlayerIndex = -1;
      
      for (int teamIndex = 0; teamIndex < teams.length; teamIndex++) {
        final teamPlayers = teams[teamIndex]['players'] as List;
        for (int playerIndex = 0; playerIndex < teamPlayers.length; playerIndex++) {
          if (teamPlayers[playerIndex]['playerId'] == playerId) {
            playerToMove = Map<String, dynamic>.from(teamPlayers[playerIndex]);
            sourceTeamIndex = teamIndex;
            sourcePlayerIndex = playerIndex;
            break;
          }
        }
        if (playerToMove != null) break;
      }
      
      if (playerToMove == null) return;
      
      // Get target team index
      int targetTeamIndex = targetTeam == 'Team A' ? 0 : 1;
      
      // Remove player from source team
      final sourceTeamPlayers = teams[sourceTeamIndex]['players'] as List;
      sourceTeamPlayers.removeAt(sourcePlayerIndex);
      
      // Add player to target team at specific index
      final targetTeamPlayers = teams[targetTeamIndex]['players'] as List;
      if (targetIndex < targetTeamPlayers.length) {
        targetTeamPlayers[targetIndex] = playerToMove;
      } else {
        targetTeamPlayers.add(playerToMove);
      }
      
      hasPlayerSwaps.value = true;
      teams.refresh();
      CustomLogger.logMessage(msg: 'Player moved to empty slot successfully', level: LogLevel.info);
    } catch (e) {
      CustomLogger.logMessage(msg: 'Move player error: $e', level: LogLevel.error);
    }
  }

  ///Save Player Swaps---------------------------------------------------------
  Future<void> savePlayerSwaps() async {
    if (!hasPlayerSwaps.value) {
      CustomLogger.logMessage(msg: 'No swaps made - exiting shuffle mode without API call', level: LogLevel.info);
      isShuffleMode.value = false;
      return;
    }
    
    CustomLogger.logMessage(msg: 'savePlayerSwaps called - API CALL STARTING', level: LogLevel.info);
    try {
      // Build API body
      final updatedTeams = [];
      for (int i = 0; i < teams.length; i++) {
        final teamPlayers = teams[i]['players'] as List;
        final playerIds = teamPlayers.map((p) => {'playerId': p['playerId']}).toList();
        
        updatedTeams.add({
          'name': teams[i]['name'],
          'players': playerIds,
        });
      }
      
      final body = {
        'scoreboardId': scoreboardId.value,
        'teams': updatedTeams,
        'action': 'swap',
      };
      
      CustomLogger.logMessage(msg: 'Making API call to save player swaps', level: LogLevel.info);
      final response = await repository.updateScoreBoard(data: body);
      if (response.success == true) {
        hasPlayerSwaps.value = false; // Reset swap flag
        isShuffleMode.value = false;
        await fetchScoreBoard();
        SnackBarUtils.showInfoSnackBar('Players updated successfully!');
        CustomLogger.logMessage(msg: 'API call successful - shuffle mode disabled', level: LogLevel.info);
      } else {
        // Revert changes on API failure
        await fetchScoreBoard(showLoader: false);
        SnackBarUtils.showErrorSnackBar('Failed to update players');
      }
    } catch (e) {
      CustomLogger.logMessage(msg: 'Save error: $e', level: LogLevel.error);
      await fetchScoreBoard(showLoader: false);
      SnackBarUtils.showErrorSnackBar('Failed to update players');
    }
  }

  ///Share Scoreboard-----------------------------------------------------------
  Future<void> shareScoreboard(BuildContext context) async {
    String formatPlayerNames(List<dynamic> players) {
      if (players.isEmpty) return "Available";
      return players
          .where((p) => p['name'] != null && p['name'].toString().isNotEmpty)
          .map((p) {
        final firstName = (p['name']?.toString())?.capitalizeFirst ?? '';
        final lastName = (p['lastName']?.toString())?.capitalizeFirst ?? '';
        final fullName = "$firstName $lastName".trim();
        return fullName.isEmpty ? "Unknown" : fullName;
      }).join(", ");
    }

    final teamAPlayers = teams.isNotEmpty ? formatPlayerNames(teams[0]["players"]) : "Available";
    final teamBPlayers = teams.length > 1 ? formatPlayerNames(teams[1]["players"]) : "Available";

    final formattedDate = formatMatchDateAt(matchDate.value);
    final clubNameValue = clubName.value.isNotEmpty ? clubName.value : "Unknown Club";
    final courtNameValue = courtName.value.isNotEmpty ? courtName.value : "Court 1";

    String setsResults = "";
    if (sets.isNotEmpty) {
      setsResults = sets.map((set) {
        final teamA = set["teamAScore"] ?? 0;
        final teamB = set["teamBScore"] ?? 0;
        return "Set ${set["setNumber"]}: $teamA - $teamB";
      }).join("\n");
    } else {
      setsResults = "No scores recorded yet";
    }

    final message = '''
🎾 *Padel Scoreboard*

📍 *Club:* $clubNameValue
🏟️ *Court:* $courtNameValue
📅 *Date:* $formattedDate

👥 *Team A:* $teamAPlayers
👥 *Team B:* $teamBPlayers

📊 *Scores:*
$setsResults

🏆 *Overall Score:* ${teamAWins.value} - ${teamBWins.value}
${winner.value != "None" && winner.value.isNotEmpty ? "🎉 *Winner:* ${winner.value}" : ""}

Great game! 🏓
''';

    final renderBox = context.findRenderObject() as RenderBox?;
    final Rect shareRect = (renderBox != null)
        ? (renderBox.localToGlobal(Offset.zero) & renderBox.size)
        : const Rect.fromLTWH(0, 0, 1, 1);

    await Share.share(
      message,
      subject: "Check out this Padel scoreboard!",
      sharePositionOrigin: (shareRect.width == 0 || shareRect.height == 0)
          ? const Rect.fromLTWH(0, 0, 1, 1)
          : shareRect,
    );
  }
}