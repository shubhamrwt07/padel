import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../../data/response_models/openmatch_model/all_open_matches.dart';
import 'open_match_controller.dart';

class OpenMatchView extends StatelessWidget {
  OpenMatchView({super.key});

  final OpenMatchController controller = Get.put(OpenMatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        centerTitle: true,
        title: const Text("All Suggestions"),
        context: context,
      ),
      bottomNavigationBar: bottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// "For your level" section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("For your level", style: Get.textTheme.headlineLarge),
                GestureDetector(
                  onTap: () {
                    controller.showFilter.toggle();
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: AppColors.playerCardBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(Assets.imagesIcFilter, scale: 3.5),
                  ),
                ),
              ],
            ).paddingOnly(
              left: Get.width * .025,
              right: Get.width * .025,
              top: Get.height * 0.01,
              bottom: 12,
            ),

            /// Match cards with API data
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading matches',
                        style: Get.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchOpenMatches(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.matches.value?.data == null ||
                  controller.matches.value!.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_tennis,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No matches available',
                        style: Get.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later for new matches',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: controller.matches.value!.data!.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, int index) {
                  final match = controller.matches.value!.data![index];
                  return MatchCard(match: match).paddingOnly(bottom: 12);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget bottomButton() {
    return Container(
      height: Get.height * .14,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: CustomButton(
          width: Get.width * 0.9,
          child: Text(
            "+ Start a creatematch",
            style: Get.textTheme.headlineMedium!.copyWith(
              color: AppColors.whiteColor,
            ),
          ).paddingOnly(right: Get.width * 0.14),
          onTap: () {
            Get.to(() => DetailsScreen(), transition: Transition.rightToLeft);
          },
        ),
      ),
    );
  }
}

/// ---- Updated Match Card Widget with API Data ----
class MatchCard extends StatelessWidget {
  final MatchData match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(match.matchDate, match.matchTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    match.skillLevel ?? "A",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            /// Sub-header: Match type & Gender
            Text(
              "${match.matchType ?? 'Professional'}   |   ${match.gender ?? 'Mixed'}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const Divider(height: 24),

            /// Players section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildPlayerTiles(),
            ),

            const Divider(height: 24),

            /// Footer with club & price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.clubId?.clubName ?? "The Good Club",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          match.clubId?.city ?? "Chandigarh 160001",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "₹${_getMatchPrice()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build Player & Available slots
  List<Widget> _buildPlayerTiles() {
    List<Widget> tiles = [];

    // Team A
    if (match.teamA != null) {
      for (var player in match.teamA!) {
        if (player.userId != null) {
          tiles.add(_playerTile(
            "${player.userId!.name ?? ''} ${player.userId!.lastname ?? ''}",
            player.userId!.category ?? "A/B",
            player.userId!.profilePic ?? "",
          ));
        }
      }
    }

    // Team B
    if (match.teamB != null) {
      for (var player in match.teamB!) {
        if (player.userId != null) {
          tiles.add(_playerTile(
            "${player.userId!.name ?? ''} ${player.userId!.lastname ?? ''}",
            player.userId!.category ?? "B/C",
            player.userId!.profilePic ?? "",
          ));
        } else {
          tiles.add(_availableTile());
        }
      }
    }

    // Fill with Available slots up to 4
    while (tiles.length < 4) {
      tiles.add(_availableTile());
    }

    return tiles.take(4).toList();
  }

  /// Player Tile
  static Widget _playerTile(String name, String level, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.person, size: 28)
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            level,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          ),
        ),
      ],
    );
  }

  /// Available Slot
  static Widget _availableTile() {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 1.5),
          ),
          child: const Icon(Icons.add, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        const Text("Available",
            style: TextStyle(fontSize: 12, color: Colors.blue)),
      ],
    );
  }

  /// Price
  String _getMatchPrice() {
    if (match.slot != null && match.slot!.isNotEmpty) {
      var slot = match.slot!.first;
      if (slot.slotTimes != null && slot.slotTimes!.isNotEmpty) {
        return slot.slotTimes!.first.amount?.toString() ?? "2000";
      }
    }
    return "2000";
  }

  /// Date + Time
  String _formatDateTime(String? date, String? time) {
    if (date == null && time == null) return "Date & Time";

    try {
      String formatted = "";
      if (date != null) {
        final dt = DateTime.parse(date);
        final weekday = _getWeekday(dt.weekday);
        final month = _getMonth(dt.month);
        formatted = "$weekday ${dt.day} $month";
      }
      if (time != null) formatted += " | $time";
      return formatted;
    } catch (_) {
      return "${date ?? ''} ${time ?? ''}".trim();
    }
  }

  String _getWeekday(int weekday) =>
      ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][weekday - 1];

  String _getMonth(int month) =>
      ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
}
