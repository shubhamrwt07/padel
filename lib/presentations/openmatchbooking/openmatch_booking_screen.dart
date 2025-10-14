import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:padel_mobile/presentations/openmatchbooking/widgets/custom_match_shimmer.dart';
import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/routes/routes_name.dart';
import '../../data/response_models/openmatch_model/open_match_booking_model.dart';
import '../../generated/assets.dart';
import '../../handler/logger.dart';
import 'openmatch_booking_controller.dart';
class OpenMatchBookingScreen extends StatelessWidget {
  final OpenMatchBookingController controller = Get.put(OpenMatchBookingController());
  OpenMatchBookingScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        centerTitle: true,
        leading:GestureDetector(
          onTap: () {
            if(controller.argument.value == "profile") {
              Get.back();
            }else if(controller.argument.value == "detailPage"){
              Get.toNamed(RoutesName.bottomNav);
            }
          },
          child: Container(
            color: Colors.transparent,
            height: 30,
            width: 40,
            child: Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 22,
            ),
          ),
        ) ,
        title: const Text("Open matches"),
        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabBar(controller),

          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildMatchesTab(context, completed: false),
                _buildMatchesTab(context, completed: true),
              ],
            ),
          ),
        ],
      )
      ,
    );
  }

  Widget tabBar(OpenMatchBookingController controller) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller.tabController,
        indicatorColor: AppColors.primaryColor,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.labelBlackColor,
        labelStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: "Upcoming"),
          Tab(text: "Completed"),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(BuildContext context, {required bool completed}) {
    return RefreshIndicator(
      edgeOffset: 1,
      displacement: Get.width * .2,
      color: AppColors.primaryColor,
      onRefresh: () async {
        String type = controller.tabController.index == 0 ? 'upcoming' : 'completed';
        await controller.fetchOpenMatchesBooking(type: type);
      },
      child: Column(
        children: [
          _buildAllMatchesAndFilter(context),
          Expanded(
            child: Obx(() {
              // Show loading
              if (controller.isLoading.value) {
                return ListView.builder(
                  itemCount: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemBuilder: (context, index) => const MatchCardSkeleton().paddingOnly(bottom: 8),
                );
              }

              // Show empty state
              if (controller.openMatchesList.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: Get.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "No Open Matches available.",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              // Show list
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.openMatchesList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final matches = controller.openMatchesList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: _buildMatchCard(
                      context,
                      match: matches,
                      completed: completed,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ).paddingOnly(left: Get.width * 0.03, right: Get.width * 0.03),
    );
  }
  Widget _buildAllMatchesAndFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("All Matches", style: Get.textTheme.headlineMedium),
        // GestureDetector(
        //   onTap: () {
        //     Get.bottomSheet(
        //       filter(context),
        //       isScrollControlled: true,
        //       backgroundColor: Colors.transparent,
        //     );
        //   },
        //   child: Container(
        //     height: 35,
        //     width: 35,
        //     decoration: BoxDecoration(
        //       color: AppColors.primaryColor.withOpacity(0.2),
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Image.asset(Assets.imagesIcFilter, scale: 3.5),
        //   ),
        // ),
      ],
    ).paddingOnly(
      top: Get.height * 0.01,
      bottom: 5,
      left: Get.width * 0.025,
      right: Get.width * 0.025,
    );
  }

  Widget _buildMatchCard(
      BuildContext context, {
        bool completed = false,
        OpenMatchBookingData? match,
      }) {
    return GestureDetector(
      onTap: () {
        final id = match?.sId;
        // Get.to(
        //       () => DetailsScreen(
        //     // buttonType: completed ? "completed" : "upcoming",
        //     // matchId: id,
        //   ),
        //   transition: Transition.rightToLeft,
        // );
        CustomLogger.logMessage(
          msg: "Selected Match Id -> $id",
          level: LogLevel.debug,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.playerCardBackgroundColor,
          border: Border.all(color: AppColors.blackColor.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchHeader(context, match),
            _buildPlayerRow(completed: completed, match: match),
            Divider(
              thickness: 1.5,
              height: 0,
              color: AppColors.blackColor.withOpacity(0.5),
            ).paddingOnly(bottom: 3),
            _buildMatchFooter(context, match),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context, OpenMatchBookingData? match)

  {
    final slots = match?.slot ?? [];
    final times = slots
        .expand((slot) => slot.slotTimes ?? [])
        .map((st) => st.time ?? "")
        .where((t) => t.isNotEmpty)
        .join(" | ");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.6,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${formatDayOnly(match?.matchDate ?? "")} ",
                  style: Get.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                  "${formatDateOnly(match?.matchDate ?? "")} | $times",
                  style: Get.textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "${match?.skillLevel ?? "N/A"} | ",
              style: Get.textTheme.displaySmall!.copyWith(fontSize: 11),
            ),
            Icon(
              match?.gender == "female"
                  ? Icons.female
                  : match?.gender == "male"
                  ? Icons.male
                  : Icons.wc,
              size: 14,
            ),
            Text(
              match?.gender?.capitalizeFirst ?? "",
              style: Get.textTheme.displaySmall!.copyWith(fontSize: 11),
            ),
          ],
        ).paddingOnly(top: 2),
      ],
    ).paddingOnly(bottom: 8);
  }

  Widget _buildPlayerRow({
    required bool completed,
    required OpenMatchBookingData? match,
  })

  {
    final teamAPlayers = match?.teamA ?? [];
    final teamBPlayers = match?.teamB ?? [];

    // Build exactly 2 slots for Team A
    List<Widget> teamAWidgets = [];
    for (int i = 0; i < 2; i++) {
      if (i < teamAPlayers.length) {
        final player = teamAPlayers[i];
        final user = player.userId;

        if (!completed && (user?.name?.isEmpty ?? true)) {
          teamAWidgets.add(
            _buildAddPlayerSlot(
              onTap: () {
                final id = match?.sId;
                Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {"matchId": id, "team": "teamA"},
                );
              },
            ),
          );
        } else {
          teamAWidgets.add(
            _buildPlayerSlot(
              imageUrl: user?.profilePic ?? '',
              name: user?.name ?? '',
              category: true,
              completed: completed,
              level: user?.level?.split(" ").first ?? "-",
            ),
          );
        }
      } else {
        // Empty slot
        if (completed) {
          teamAWidgets.add(
            _buildPlayerSlot(
              imageUrl: '',
              name: '',
              category: true,
              completed: completed,
              level: "-",
            ),
          );
        } else {
          teamAWidgets.add(
            _buildAddPlayerSlot(
              onTap: () {
                final id = match?.sId;
                Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {"matchId": id, "team": "teamA"},
                );
              },
            ),
          );
        }
      }
    }

    // Build exactly 2 slots for Team B
    List<Widget> teamBWidgets = [];
    for (int i = 0; i < 2; i++) {
      if (i < teamBPlayers.length) {
        final player = teamBPlayers[i];
        final user = player.userId;

        if (!completed && (user?.name?.isEmpty ?? true)) {
          teamBWidgets.add(
            _buildAddPlayerSlot(
              onTap: () {
                final id = match?.sId;
                Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {"matchId": id, "team": "teamB"},
                );
              },
            ),
          );
        } else {
          teamBWidgets.add(
            _buildPlayerSlot(
              imageUrl: user?.profilePic ?? '',
              name: user?.name ?? '',
              category: true,
              completed: completed,
              level: user?.level?.split(" ").first ?? "-",
            ),
          );
        }
      } else {
        // Empty slot
        if (completed) {
          teamBWidgets.add(
            _buildPlayerSlot(
              imageUrl: '',
              name: '',
              category: true,
              completed: completed,
              level: "-",
            ),
          );
        } else {
          teamBWidgets.add(
            _buildAddPlayerSlot(
              onTap: () {
                final id = match?.sId;
                Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {"matchId": id, "team": "teamB"},
                );
              },
            ),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Team A - Player 1
            teamAWidgets[0],

            // Team A - Player 2
            teamAWidgets[1],

            // Divider
            Container(
              width: 1,
              margin: const EdgeInsets.only(bottom: 19),
              color: AppColors.blackColor.withOpacity(0.5),
            ),

            // Team B - Player 1
            teamBWidgets[0],

            // Team B - Player 2
            teamBWidgets[1],
          ],
        ),
      ),
    );
  }
  Widget _buildPlayerSlot({
    required String imageUrl,
    required String name,
    required bool category,
    required bool completed,
    required String level,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            border: Border.all(
              color: imageUrl.isEmpty ? AppColors.primaryColor : Colors.transparent,
            ),
          ),
          child: imageUrl.isEmpty
              ? CircleAvatar(
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            child: Text(
              (name.isNotEmpty ? name[0] : "?").toUpperCase(),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  (name.isNotEmpty ? name[0] : "?").toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: Get.width * 0.18,
          child: Text(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            name.isNotEmpty ? name : 'Unknown',
            style: Get.textTheme.bodySmall!.copyWith(
              color: name.isNotEmpty ? AppColors.darkGreyColor : AppColors.primaryColor,
              fontSize: 11,
            ),
          ),
        ),
        if (category) ...[
          const SizedBox(height: 4),
          Container(
            height: 18,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.secondaryColor.withOpacity(0.2),
            ),
            child: Text(
              level,
              textAlign: TextAlign.center,
              style: Get.textTheme.displaySmall!.copyWith(
                color: AppColors.secondaryColor,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ],
    );
  }
  Widget _buildMatchFooter(BuildContext context, OpenMatchBookingData? match) {
    final slots = match?.slot ?? [];
    final totalAmount = slots.isNotEmpty
        ? slots
        .expand((slot) => slot.slotTimes ?? [])
        .map((st) => (st.amount ?? 0) as int)
        .fold(0, (a, b) => a + b)
        : 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match?.clubId?.clubName ?? "N/A",
              style: Get.textTheme.labelLarge!.copyWith(fontSize: 11),
            ),
            Row(
              children: [
                Image.asset(Assets.imagesIcLocation, scale: 3),
                Text(
                  "${match?.clubId?.city ?? "N/A"} ${match?.clubId?.zipCode ?? ""}",
                  style: Get.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.currency_rupee,
                size: 18, color: AppColors.primaryColor)
                .paddingOnly(top: 2),
            Text(
              formatAmount(totalAmount),
              style: Get.textTheme.titleMedium!.copyWith(
                color: AppColors.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildAddPlayerSlot({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: const Icon(Icons.add,
                size: 24, color: AppColors.primaryColor),
          ),
          SizedBox(
            width: Get.width * 0.13,
            child: Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              "Available",
              style: Get.textTheme.bodySmall!.copyWith(
                color: AppColors.primaryColor,
                fontSize: 11,
              ),
            ).paddingOnly(top: Get.height * 0.003),
          ),
        ],
      ),
    );
  }
  // Helper functions
  String formatDayOnly(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE').format(date);
    } catch (_) {
      return '';
    }
  }
  String formatDateOnly(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return '';
    }
  }
  String formatAmount(int amount) => amount.toString();
}
