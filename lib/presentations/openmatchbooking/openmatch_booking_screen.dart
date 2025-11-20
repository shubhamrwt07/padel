import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/web.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/configs/components/multiple_gender.dart';
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
  OpenMatchBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String? backRoute =
    (args is Map) ? args['backRoute'] as String? : null;

    return Obx(() {
      if (!controller.isControllerReady.value || controller.tabController == null) {
        return const Scaffold(
          body: Center(
            child: LoadingWidget(color: AppColors.primaryColor),
          ),
        );
      }

      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: primaryAppBar(
            centerTitle: true,
            showLeading: controller.argument.value == "detailPage" || Navigator.canPop(context),
            leading: GestureDetector(
              onTap: () {
                if (backRoute != null && backRoute.isNotEmpty) {
                  Get.toNamed(backRoute);
                  return;
                }
                if (controller.argument.value == "detailPage") {
                  Get.toNamed(RoutesName.bottomNav);
                } else if (controller.argument.value == "profile") {
                  Get.back();
                } else {
                  Get.toNamed(RoutesName.bottomNav);
                }
              },
              child: Container(
                color: Colors.transparent,
                height: 30,
                width: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor,
                  size: 22,
                ),
              ),
            ),
            title: const Text("Open matches"),
            context: context,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tabBar(controller.tabController!),
              const SizedBox(height: 4),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController!,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildMatchesTab(context, completed: false),
                    _buildMatchesTab(context, completed: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget tabBar(TabController tabCtrl) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TabBar(
        controller: tabCtrl,
        isScrollable: false,
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 2.5,
        labelColor: AppColors.primaryColor,
        dividerColor: AppColors.tabColor,
        unselectedLabelColor: AppColors.labelBlackColor.withValues(alpha: 0.6),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: "Upcoming"),
          Tab(text: "Completed"),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(BuildContext context, {required bool completed}) {
    // Determine which list to use based on completed flag instead of tab controller
    final matchesList = completed ? controller.completedMatchesList : controller.upcomingMatchesList;
    final isLoadingState = completed ? controller.isLoadingCompleted : controller.isLoadingUpcoming;
    final isLoadingMoreState = completed ? controller.isLoadingMoreCompleted : controller.isLoadingMoreUpcoming;
    final hasMoreDataState = completed ? controller.completedHasMoreData : controller.upcomingHasMoreData;

    return RefreshIndicator(
      edgeOffset: 1,
      displacement: Get.width * .2,
      color: AppColors.whiteColor,
      onRefresh: () async {
        String type = completed ? 'completed' : 'upcoming';
        controller.resetPagination(type: type);
        await controller.fetchOpenMatchesBooking(type: type);
      },
      child: Column(
        children: [
          _buildAllMatchesAndFilter(context),
          Expanded(
            child: Obx(() {
              // Show loading
              if (isLoadingState.value) {
                return ListView.builder(
                  itemCount: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemBuilder: (context, index) => const MatchCardSkeleton().paddingOnly(bottom: 8),
                );
              }

              // Show empty state
              if (matchesList.isEmpty) {
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
                            completed
                                ? "No Completed Matches available."
                                : "No Upcoming Matches available.",
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
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      hasMoreDataState.value &&
                      !isLoadingMoreState.value) {
                    controller.loadMoreData();
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: matchesList.length + (hasMoreDataState.value ? 1 : 0),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end
                    if (index == matchesList.length) {
                      return Obx(() {
                        if (isLoadingMoreState.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: LoadingWidget(color: AppColors.primaryColor),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      });
                    }

                    final matches = matchesList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: _buildMatchCard(
                        context,
                        match: matches,
                        completed: completed,
                      ),
                    );
                  },
                ),
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
        // Uncomment to enable filter
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
        //   () => DetailsScreen(
        //     buttonType: completed ? "completed" : "upcoming",
        //     matchId: id,
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
          border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchHeader(context, match),
            _buildPlayerRow(completed: completed, match: match),
            Divider(
              thickness: 1.5,
              height: 0,
              color: AppColors.blackColor.withValues(alpha: 0.5),
            ).paddingOnly(bottom: 3),
            _buildMatchFooter(context, match),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context, OpenMatchBookingData? match) {
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
                  text: "${formatDateOnly(match?.matchDate ?? "")} | $times",
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
            genderIcon(match?.gender),
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
  }) {
    final teamAPlayers = match?.teamA ?? [];
    final teamBPlayers = match?.teamB ?? [];

    // Build exactly 2 slots for Team A
    List<Widget> teamAWidgets = [];
    for (int i = 0; i < 2; i++) {
      if (i < teamAPlayers.length) {
        final player = teamAPlayers[i];
        final user = player.userId;
        final level = _extractLevelCode(player.userId?.playerLevel ?? "");
        if (!completed && user == null) {
          if (i == 0) {
            teamAWidgets.add(
              _buildPlayerSlot(
                imageUrl: '',
                name: '',
                category: true,
                completed: completed,
                level: level,
                playerIndex: i + 1
              ),
            );
          } else {
            teamAWidgets.add(
              _buildAddPlayerSlot(
                onTap: () async {
                  final id = match?.sId;
                  final result = await Get.toNamed(
                    RoutesName.addPlayer,
                    arguments: {
                      "matchId": id,
                      "team": "teamA",
                      "needBottomAllOpenMatches": true
                    },
                  );
                  if (result == true) {
                    final type = controller.tabController?.index == 0
                        ? 'upcoming'
                        : 'completed';
                    await controller.fetchOpenMatchesBooking(type: type);
                  }
                },
              ),
            );
          }
        } else {
      
          teamAWidgets.add(
            _buildPlayerSlot(
              imageUrl: user?.profilePic ?? '',
              // imageUrl: '',
              name: (user?.name ?? '').trim(),
              category: true,
              completed: completed,
              level: level,
              playerIndex: i + 1
            ),
          );
        }
      } else {
        if (completed) {
          teamAWidgets.add(
            _buildPlayerSlot(
              imageUrl: '',
              name: '',
              category: false,
              completed: completed,
              level: "-",
              playerIndex: i + 1
            ),
          );
        } else {
          teamAWidgets.add(
            _buildAddPlayerSlot(
              onTap: () {
                final id = match?.sId;
                Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {"matchId": id, "team": "teamA","needBottomAllOpenMatches": true},
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
        final level = _extractLevelCode(player.userId?.playerLevel ?? "");

        if (!completed && user == null) {
          teamBWidgets.add(
            _buildAddPlayerSlot(
              onTap: () async {
                final id = match?.sId;
                final result = await Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {
                    "matchId": id,
                    "team": "teamB",
                    "needBottomAllOpenMatches": true
                  },
                );
                if (result == true) {
                  final type = controller.tabController?.index == 0
                      ? 'upcoming'
                      : 'completed';
                  await controller.fetchOpenMatchesBooking(type: type);
                }
              },
            ),
          );
        } else {
          teamBWidgets.add(
            _buildPlayerSlot(
              imageUrl: user?.profilePic ?? '',
              // imageUrl: '',
              name: (user?.name ?? '').trim(),
              category: true,
              completed: completed,
              level: level,
              playerIndex: i + 3
            ),
          );
        }
      } else {
        if (completed) {
          teamBWidgets.add(
            _buildPlayerSlot(
              imageUrl: '',
              name: '',
              category: false,
              completed: completed,
              level: "-",
              playerIndex: i + 3
            ),
          );
        } else {
          teamBWidgets.add(
            _buildAddPlayerSlot(
              onTap: () {
                final id = match?.sId;
                Get.toNamed(
                  RoutesName.addPlayer,
                  arguments: {"matchId": id, "team": "teamB","needBottomAllOpenMatches": true},
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
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            teamAWidgets[0],
            teamAWidgets[1],
            Container(
              width: 1,
              margin: const EdgeInsets.only(bottom: 19),
              color: AppColors.blackColor.withValues(alpha: 0.5),
            ),
            teamBWidgets[0],
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
    required int playerIndex
  }) {
  final firstLetter = name.trim().isNotEmpty
      ? name.trim().split(" ").map((e) => e[0]).take(2).join().toUpperCase()
      : 'P$playerIndex';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor
          ),
          child: imageUrl.isEmpty
              ? CircleAvatar(
            backgroundColor:
            AppColors.primaryColor.withValues(alpha: 0.1),
            child: Text(
              firstLetter,
              style: const TextStyle(
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
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: LoadingWidget(color: AppColors.primaryColor),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  firstLetter,
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
        Container(
          color: Colors.transparent,
          width: Get.width * 0.18,
          child: Text(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            name.isNotEmpty? name.split(' ').first.capitalizeFirst!:"Player $playerIndex",
            style: Get.textTheme.bodySmall!.copyWith(
              color: name.isNotEmpty
                  ? AppColors.darkGreyColor
                  : AppColors.primaryColor,
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
              color: AppColors.secondaryColor.withValues(alpha: 0.2),
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
            const Icon(Icons.currency_rupee,
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
            width: Get.width * 0.18,
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

  String _extractLevelCode(String value) {
    if (value.isEmpty) return '-';
    final parts = value.split(RegExp(r"\s*[–-]\s*"));
    final code = parts.isNotEmpty ? parts.first.trim() : '';
    return code.isNotEmpty ? code : '-';
  }
 
}