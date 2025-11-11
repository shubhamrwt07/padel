import 'package:get/get.dart';

class Player {
  final String name;
  final int points;
  final String imageUrl;
  final String record;

  Player(this.name, this.points, this.imageUrl, {this.record = "8 - 7 - 0"});
}

class LeaderboardController extends GetxController {
  // Player list
  final players = <Player>[
    Player("Dianne Smith", 122, "https://i.pravatar.cc/150?img=1"),
    Player("Jane Cooper", 110, "https://i.pravatar.cc/150?img=2"),
    Player("Lily Johnson", 100, "https://i.pravatar.cc/150?img=3"),
    Player("Sophia Brown", 95, "https://i.pravatar.cc/150?img=4"),
    Player("Olivia Davis", 90, "https://i.pravatar.cc/150?img=5"),
    Player("Emma Wilson", 88, "https://i.pravatar.cc/150?img=6"),
    Player("Ava Martinez", 85, "https://i.pravatar.cc/150?img=7"),
    Player("Isabella Anderson", 83, "https://i.pravatar.cc/150?img=8"),
    Player("Mia Thomas", 80, "https://i.pravatar.cc/150?img=9"),
    Player("Charlotte Taylor", 78, "https://i.pravatar.cc/150?img=10"),
    Player("Amelia Moore", 75, "https://i.pravatar.cc/150?img=11"),
  ].obs;
  final clubs = <Player>[
    Player("Raptors Club", 200, "https://i.pravatar.cc/150?img=12"),
    Player("Falcons Club", 180, "https://i.pravatar.cc/150?img=13"),
    Player("Lions Club", 175, "https://i.pravatar.cc/150?img=14"),
    Player("Eagles Club", 160, "https://i.pravatar.cc/150?img=15"),
    Player("Wolves Club", 150, "https://i.pravatar.cc/150?img=16"),
  ].obs;

  final selectedTab = 0.obs;
  final leftScore = 16.obs;
  final rightScore = 22.obs;

  final categories = ['Player', 'Team', 'Tournaments', 'State Level'];
  var selectedCategory = 'Player'.obs;
  RxDouble borderRadius = 24.0.obs;

  var expandedIndex = (-1).obs;
  RxBool isHandleVisible = true.obs;
  var selectedGender = ''.obs;
  var selectedYear = ''.obs;
  var showStateFilters = false.obs;
  var selectedCity = 'All Location'.obs;

  final List<String> indianCities = [
    'All Location',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Jaipur',
    'Ahmedabad',
    'Lucknow',
    'Indore',
    'Chandigarh',
    'Bhopal',
    'Surat',
    'Patna',
    'Nagpur',
    'Coimbatore',
    'Goa',
    'Thiruvananthapuram',
  ];

  // ✅ Convert players into leaderboardData (Map format)
  List<Map<String, dynamic>> get leaderboardData {
    final list = selectedCategory.value == 'Team' ? clubs : players;

    return List.generate(list.length, (index) {
      final p = list[index];
      return {
        'rank': index + 1,
        'name': p.name,
        'score': p.points,
        'change': (index % 3 == 0)
            ? 1
            : (index % 3 == 1 ? -1 : 0), // mock rank change
        'image': p.imageUrl,
        'streak': (index + 1) * 2,
        'matches': 40 + index,
        'wins': 20 + index,
        'losses': 10 + index,
      };
    });
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}