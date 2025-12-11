import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/components/multiple_gender.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import '../widgets/booking_exports.dart';

class OpenMatchesScreen extends StatelessWidget {
  final OpenMatchesController controller = Get.put(OpenMatchesController());
  OpenMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDatePicker(),
                  // Transform.translate(
                  //   offset: Offset(0, -Get.height * 0.05),
                  //   child: _buildSlotHeader(context),
                  // ),
                  Transform.translate(
                    offset: Offset(0, -Get.height * 0.03),
                    child: _buildTimeTabs(),
                  ),
                  // Transform.translate(
                  //   offset: Offset(0, -Get.height * 0.04),
                  //   child: _buildTimeSlots(),
                  // ),
                  // Transform.translate(
                  //   offset: Offset(0, -Get.height * 0.04),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text("Available Matches", style: Get.textTheme.headlineMedium),
                  //       GestureDetector(
                  //         onTap: () => Get.toNamed(RoutesName.allOpenMatch, arguments: {"club": controller.argument}),
                  //         child: Container(
                  //           color: Colors.transparent,
                  //           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  //           alignment: Alignment.center,
                  //           child: Text("View all", style: Get.textTheme.labelMedium!.copyWith(color: AppColors.primaryColor)),
                  //         ),
                  //       ),
                  //     ],
                  //   ).paddingOnly(bottom: 10,top: 15),
                  // ),
                  Transform.translate(
                    offset: Offset(0, -Get.height * 0.015),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: buildMatchCardShimmer());
                      }
                      final matches = controller.matchesBySelection.value;
                      if (matches == null || (matches.data?.isEmpty ?? true)) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(Icons.event_busy_outlined, size: 50, color: AppColors.darkGrey),
                              Text(
                                'No matches available for this time',
                                style: Get.textTheme.labelLarge?.copyWith(color: AppColors.darkGrey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ).paddingOnly(top: Get.height * 0.1),
                        );
                      }
                      return Column(
                        children: matches.data!.map((m) => _buildMatchCardFromData(context, m)).toList(),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _bottomButton(context),
        )
      ],
    );
  }
  ///---------------- BOTTOM BUTTON --------------
  Widget _bottomButton(BuildContext context){
    return Container(
      height: Get.height * .09,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        width: Get.width * 0.9,
        child: Text(
          "Create an Open Match",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.whiteColor),
        ).paddingOnly(right: Get.width * 0.14),
        onTap: () {
          final booking = Get.put(BookSessionController());
          Get.toNamed(RoutesName.createOpenMatch, arguments: {"id": booking.argument});
        },
      ).paddingOnly(bottom: 0),
    );
  }
  /// --------------- DATE PICKER ---------------
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Date",
          style: Get.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
        ).paddingOnly(top: 10),
        Obx(
              () => Transform.translate(
            offset: Offset(0, -19),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: Get.height * 0.069,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textFieldColor,
                    border: Border.all(color: AppColors.blackColor.withAlpha(10)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: DateFormat('MMM')
                        .format(controller.focusedDate.value)
                        .toUpperCase()
                        .split('')
                        .map((char) => Text(
                      char,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ))
                        .toList(),
                  ),
                ).paddingOnly(right: 5),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        final scrollOffset = scrollNotification.metrics.pixels;
                        final itemExtent = 46.0;
                        final itemsScrolled = (scrollOffset / itemExtent).round();
                        final estimatedDate = DateTime.now().add(Duration(days: itemsScrolled));

                        // Only update focusedDate for month display, not selectedDate
                        controller.focusedDate.value = estimatedDate;
                      }
                      return false;
                    },
                    child: EasyDateTimeLinePicker.itemBuilder(
                      headerOptions: HeaderOptions(
                        headerBuilder: (_, context, date) => const SizedBox.shrink(),
                      ),
                      selectionMode: SelectionMode.alwaysFirst(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030, 3, 18),
                      focusedDate: controller.selectedDate.value,
                      itemExtent: 46,
                      itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
                        final dayName = DateFormat('E').format(date);
                        return GestureDetector(
                          onTap: onTap,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: 60,
                              width: Get.width * 0.11,
                              key: ValueKey(isSelected),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isSelected ? Colors.black : AppColors.playerCardBackgroundColor,
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : AppColors.blackColor.withAlpha(10),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    date.day.toString(),
                                    style: Get.textTheme.titleMedium!.copyWith(
                                      fontSize: 20,
                                      color: isSelected ? Colors.white : AppColors.textColor,
                                    ),
                                  ),
                                  Text(
                                    dayName,
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      fontSize: 11,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).paddingSymmetric(vertical: 6);
                      },
                      onDateChange: (date) {
                        controller.selectedDate.value = date;
                        controller.focusedDate.value = date; // Sync on selection
                        controller.selectedTime = null;
                        controller.selectedSlots.clear();
                        controller.fetchMatchesForSelection();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  /// ---------------- SLOT HEADER ----------------
  Widget _buildSlotHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Available Slots', style: Theme.of(context).textTheme.labelLarge),
        Row(
          children: [
            Text(
              'Show Unavailable Slots',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.darkGrey),
            ),
            SizedBox(width: Get.width * .01),
            Transform.scale(
              scale: 0.7,
              child: Obx(
                    () => CupertinoSwitch(
                  value: controller.viewUnavailableSlots.value,
                  activeTrackColor: AppColors.secondaryColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Colors.white,
                  onChanged: (value) {
                    controller.viewUnavailableSlots.value = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  /// ---------------- TIME TABS ----------------
  Widget _buildTimeTabs() {
    return Obx(() {
      final selectedFilter = controller.selectedTimeFilter.value;

      final tabs = [
        {"label": "Morning", "icon": Icons.wb_twilight_sharp, "value": "morning"},
        {"label": "Noon", "icon": Icons.wb_sunny, "value": "noon"},
        {"label": "Evening", "icon": Icons.nightlight_round, "value": "night"},
      ];

      return Theme(
        data: Theme.of(Get.context!).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  final value = tab["value"] as String;
                  final isSelected = selectedFilter == value;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                      controller.selectedTimeFilter.value = value,
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 30,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            )
                          ]
                              : [],
                        ),
                        child: Center(
                          child: Icon(
                            tab["icon"] as IconData,
                            size: 20,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final value = tab["value"] as String;
                final isSelected = selectedFilter == value;

                return Expanded(
                  child: Center(
                    child: Text(
                      tab["label"] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  /// ---------------- TIME SLOTS ----------------
  Widget _buildTimeSlots() {
    return Obx(() {
      double spacing = Get.width * .015;
      final double tileWidth = (Get.width - spacing * 5 - 32) / 4;

      final available = controller.filteredAvailableSlots;
      final unavailable = controller.filteredUnavailableSlots;
      final showUnavailable = controller.viewUnavailableSlots.value;

      List<Widget> buildSlotTiles(List<String> slots, {required bool disabled}) {
        return slots.map((time) {
          final isSelected = controller.selectedSlots.contains(time);
          return GestureDetector(
            onTap: () {
              if (disabled) return;
              controller.selectedTime = time;
              controller.selectedSlots
                ..clear()
                ..add(time);
              controller.fetchMatchesForSelection();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: tileWidth,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black
                    : disabled
                    ? AppColors.greyColor.withValues(alpha: 0.3)
                    : AppColors.timeTileBackgroundColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: disabled ? AppColors.greyColor : AppColors.blackColor.withAlpha(10),
                ),
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : disabled
                      ? AppColors.darkGrey
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList();
      }

      final slotsToShow = showUnavailable ? unavailable : available;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (slotsToShow.isEmpty)
            Center(
              child: Text(
                "No slots available",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Wrap(
              spacing: spacing,
              runSpacing: Get.height * 0.008,
              children: buildSlotTiles(slotsToShow, disabled: showUnavailable),
            ),
        ],
      );
    });
  }
  // Rich card from API data
  Widget _buildMatchCardFromData(BuildContext context, MatchData data) {
    final dayStr = controller.getDay(data.matchDate);
    final dateOnlyStr = controller.getDate(data.matchDate);
    final timeStr = (data.matchTime ?? '').toLowerCase();
    final clubName = data.clubId?.clubName ?? '-';
    final address = data.clubId?.address ?? "N/A";
    final price = (data.slot?.isNotEmpty == true &&
        data.slot!.first.slotTimes?.isNotEmpty == true)
        ? '${data.slot!.first.slotTimes!.first.amount ?? ''}'
        : '-';

    // TEAM A
    final teamAPlayers = (data.teamA ?? []).take(2).map((p) {
      return _buildFilledPlayer(
        p.userId?.profilePic ?? "",
        p.userId?.name ?? "",
        p.userId?.playerLevel?.split(' ').first ?? "-",
      );
    }).toList();

    while (teamAPlayers.length < 2) {
      teamAPlayers.add(
        _buildAvailableCircle("teamA", data.sId ?? "", data.skillLevel),
      );
    }

    // TEAM B
    final teamBPlayers = (data.teamB ?? []).take(2).map((p) {
      return _buildFilledPlayer(
        p.userId?.profilePic ?? "",
        p.userId?.name ?? "",
        p.userId?.playerLevel?.split(' ').first ?? "-",
      );
    }).toList();

    while (teamBPlayers.length < 2) {
      teamBPlayers.add(
        _buildAvailableCircle("teamB", data.sId ?? "", data.skillLevel),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffeaf0ff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 TOP SECTION (Day + Date + Time + Level Badge + Arrow)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$dayStr ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1c46a0),
                              ),
                            ),
                            TextSpan(
                              text: '$dateOnlyStr | $timeStr',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "A",
                          style: TextStyle(color: Colors.white,fontSize: 9),
                        ),
                      ).paddingOnly(left: 5),
                    ],
                  ),
                  // ⭐ Professional | Mixed
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(
                        " ${data.skillLevel?.capitalizeFirst ?? 'Professional'} | ",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      genderIcon(data.gender),
                      const SizedBox(width: 4),
                      Text(
                        data.gender?.capitalizeFirst ?? "Mixed",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🧑‍🧑‍ Players Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            width: Get.width*0.44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ]
            ),
            child: SizedBox(
              height: 50,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // TEAM A PLAYERS
                  for (int i = 0; i < teamAPlayers.length; i++)
                    Positioned(
                      left: i * 40, // overlap amount
                      child: teamAPlayers[i],
                    ),

                  // TEAM B PLAYERS (start AFTER Team A)
                  for (int i = 0; i < teamBPlayers.length; i++)
                    Positioned(
                      left: (teamAPlayers.length * 40) + (i * 40),
                      child: teamBPlayers[i],
                    ),
                ],
              ),
            ),
          ),


          const SizedBox(height: 16),

          // 💬 Start Chat + Players Request
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5,right: 1),
                // height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Start Chat with Players",
                      style: TextStyle(color: Colors.grey,fontSize: 12),
                    ).paddingOnly(right: 5),
                    Container(
                      height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primaryColor,
                        ),
                        child:Icon(Icons.chat_outlined, color: Colors.white, size: 18)
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.notifications, color: AppColors.primaryColor,size: 18,),
                  Text(
                    "Players Requests (3)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.darkGreyColor,fontSize: 11
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.share, size: 20,color: AppColors.darkGreyColor,),
                ],
              ),
            ],
          ).paddingOnly(bottom: Get.height*0.01),

          // 📍 Location & Price
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clubName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Transform.translate(
                            offset: Offset(0, -1),
                            child: Image.asset(Assets.imagesIcLocation, scale: 2, color: AppColors.primaryColor)),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            address,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "₹ ${formatAmount(price)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1c46a0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilledPlayer(String? imageUrl, String name, String level) {
    final firstLetter = name.trim().isNotEmpty
        ? name.trim().split(" ").map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Center(
              child: Text(
                firstLetter,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Text(
                firstLetter,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : Center(
            child: Text(
              firstLetter,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAvailableCircle(String team, String matchId, String? skillLevel) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RoutesName.addPlayer,
          arguments: {
            "team": team,
            "matchId": matchId,
            "needOpenMatches": true,
            "matchLevel": skillLevel,
          },
        );
      },
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xffeaf0ff),
          child: const Icon(Icons.add, color: AppColors.primaryColor),
        ),
      ),
    );
  }

}