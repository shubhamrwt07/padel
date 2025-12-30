import 'package:get/get.dart';
import 'package:padel_mobile/data/response_models/openmatch_model/get_requests_player_open_match_model.dart';

class RequestsController extends GetxController {
  RxInt expandedIndex = (-1).obs;

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  RxInt selectedTab = 0.obs; // 0 = Join, 1 = My
  void changeTab(int index) => selectedTab.value = index;

  RxList<Requests> joinRequests = <Requests>[].obs;
  RxList<Requests> myRequests = <Requests>[].obs; // ✅ ADD THIS

  RxBool isLoadingRequests = false.obs;

  void deleteRequest(int index) {
    if (selectedTab.value == 0) {
      if (index >= 0 && index < joinRequests.length) {
        joinRequests.removeAt(index);
        // Reset expanded index if needed
        if (expandedIndex.value == index) {
          expandedIndex.value = -1;
        } else if (expandedIndex.value > index) {
          expandedIndex.value = expandedIndex.value - 1;
        }
      }
    } else {
      if (index >= 0 && index < myRequests.length) {
        myRequests.removeAt(index);
        // Reset expanded index if needed
        if (expandedIndex.value == index) {
          expandedIndex.value = -1;
        } else if (expandedIndex.value > index) {
          expandedIndex.value = expandedIndex.value - 1;
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadStaticData();
  }
  void _loadStaticData() {
    isLoadingRequests.value = true;
    
    final staticRequests = [
      Requests(
        id: "1",
        type: "request",
        status: "pending",
        preferredTeam: "teamA",
        level: "Intermediate",
        match: MatchId(
          id: "match1",
          matchDate: "2024-01-15",
          matchTime: ["10:00", "11:00"],
          skillLevel: "Intermediate",
          gender: "Mixed",
          club: ClubId(
            id: "club1",
            clubName: "Elite Padel Club",
            address: "123 Sports Avenue",
            city: "Mumbai",
            zipCode: "400001",
            courtCount: 4,
            courtType: ["Indoor", "Outdoor"],
          ),
          teamA: [
            TeamA(
              user: RequesterId(
                id: "user1",
                name: "John",
                lastName: "Doe",
                email: "john@example.com",
              ),
            ),
          ],
          teamB: [
            TeamB(
              user: RequesterId(
                id: "user2",
                name: "Jane",
                lastName: "Smith",
                email: "jane@example.com",
              ),
            ),
          ],
        ),
        requester: RequesterId(
          id: "requester1",
          name: "Mike",
          lastName: "Johnson",
          email: "mike@example.com",
        ),
      ),
      Requests(
        id: "2",
        type: "invitation",
        status: "pending",
        preferredTeam: "teamB",
        level: "Advanced",
        match: MatchId(
          id: "match2",
          matchDate: "2024-01-16",
          matchTime: ["14:00", "15:00"],
          skillLevel: "Advanced",
          gender: "Male",
          club: ClubId(
            id: "club2",
            clubName: "Champions Padel Arena",
            address: "456 Victory Road",
            city: "Delhi",
            zipCode: "110001",
            courtCount: 6,
            courtType: ["Professional", "Indoor"],
          ),
          teamA: [
            TeamA(
              user: RequesterId(
                id: "user3",
                name: "Alex",
                lastName: "Wilson",
                email: "alex@example.com",
              ),
            ),
            TeamA(
              user: RequesterId(
                id: "user4",
                name: "Chris",
                lastName: "Brown",
                email: "chris@example.com",
              ),
            ),
          ],
          teamB: [],
        ),
        requester: RequesterId(
          id: "requester2",
          name: "Sarah",
          lastName: "Davis",
          email: "sarah@example.com",
        ),
      ),
    ];

     Future.delayed(const Duration(milliseconds: 500), () {
      joinRequests.assignAll(staticRequests);
      myRequests.assignAll(staticRequests); // 🔹 TEMP (replace with API later)
      isLoadingRequests.value = false;
    });
  }
}