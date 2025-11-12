import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../widgets/booking_exports.dart';

class OpenMatchesScreen extends StatelessWidget {
  final OpenMatchesController controller = Get.put(OpenMatchesController());
  OpenMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.05),
                child: _buildSlotHeader(context),
              ),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.05),
                child: _buildTimeTabs(),
              ),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.04),
                child: _buildTimeSlots(),
              ),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available Matches", style: Get.textTheme.headlineMedium),
                    GestureDetector(
                      onTap: () => Get.toNamed(RoutesName.allOpenMatch, arguments: {"club": controller.argument}),
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        alignment: Alignment.center,
                        child: Text("View all", style: Get.textTheme.labelMedium!.copyWith(color: AppColors.primaryColor)),
                      ),
                    ),
                  ],
                ).paddingOnly(bottom: 10),
              ),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.04),
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
            offset: Offset(0, -Get.height * .02),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: Get.height * 0.061,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textFieldColor,
                    border: Border.all(color: AppColors.blackColor.withAlpha(10)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: DateFormat('MMM')
                        .format(controller.selectedDate.value ?? DateTime.now())
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
                ),
                Expanded(
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
                            height: Get.height * 0.06,
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
                                    fontSize: 18,
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
                      controller.selectedTime = null;
                      controller.selectedSlots.clear();
                      controller.fetchMatchesForSelection();
                    },
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
        {"label": "Night", "icon": Icons.nightlight_round, "value": "night"},
      ];

      return Container(
        margin: EdgeInsets.only(bottom: Get.height * 0.015),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.lightBlueColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = selectedFilter == tab["value"];

            return Flexible(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    controller.selectedTimeFilter.value = tab["value"] as String;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab["icon"] as IconData,
                          size: 14,
                          color: isSelected ? AppColors.primaryColor : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tab["label"] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.primaryColor : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
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
    final price = (data.slot?.isNotEmpty == true && data.slot!.first.slotTimes?.isNotEmpty == true)
        ? '₹${data.slot!.first.slotTimes!.first.amount ?? ''}'
        : '₹-';

    final teamAPlayers = (data.teamA ?? []).take(2).map((p) {
      final pic = p.userId?.profilePic;
      final name = (p.userId?.name?.split(' ').first ?? '').capitalizeFirst!;
      final level = p.userId?.level?.split(' ').first ?? "-";
      if (pic != null && pic.isNotEmpty) {
        return _buildFilledPlayer(pic, name, level);
      } else {
        return _buildFilledPlayer("", name, level);
      }
    }).toList();

    while (teamAPlayers.length < 2) {
      teamAPlayers.add(_buildAvailableCircle("teamA", data.sId ?? ""));
    }

    final teamBPlayers = (data.teamB ?? []).take(2).map((p) {
      final pic = p.userId?.profilePic;
      final name = (p.userId?.name?.split(' ').first ?? '').capitalizeFirst!;
      final level = p.userId?.level?.split(' ').first ?? "-";
      if (pic != null && pic.isNotEmpty) {
        return _buildFilledPlayer(pic, name, level);
      } else {
        return _buildFilledPlayer("", name, level);
      }
    }).toList();

    while (teamBPlayers.length < 2) {
      teamBPlayers.add(_buildAvailableCircle("teamB", data.sId ?? ""));
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.playerCardBackgroundColor,
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$dayStr ',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: '$dateOnlyStr | $timeStr',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ).paddingOnly(right: Get.width * 0.05),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "${data.skillLevel?.capitalizeFirst ?? 'Professional'} |",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Icon(
                    data.gender == "female"
                        ? Icons.female
                        : data.gender == "male"
                        ? Icons.male
                        : Icons.wc,
                    size: 14,
                  ).paddingOnly(right: 5, left: 5),
                  Text(
                    data.matchType?.capitalizeFirst ?? 'Mixed',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )
            ],
          ).paddingOnly(top: 15, bottom: 10, left: 15),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...teamAPlayers,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: VerticalDivider(
                      color: AppColors.greyColor,
                      thickness: 1.5,
                      width: 0,
                    ),
                  ),
                  ...teamBPlayers,
                ],
              ),
            ),
          ),
          Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(clubName, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppColors.darkGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: Theme.of(context).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Get.width * .22,
                color: AppColors.playerCardBackgroundColor,
                child: Text(
                  price,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.primaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ).paddingOnly(top: 10, bottom: 12, left: 15),
        ],
      ),
    ).paddingOnly(bottom: 12);
  }

  Widget _buildFilledPlayer(String? imageUrl, String name, String level) {
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade400,
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: 48,
              height: 48,
              placeholder: (context, url) => LoadingWidget(color: AppColors.primaryColor),
              errorWidget: (context, url, error) => Text(
                firstLetter,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : Text(
            firstLetter,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 50,
          child: Text(
            name,
            style: Get.textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 17,
          width: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.secondaryColor.withAlpha(20),
          ),
          child: Text(
            level,
            style: Get.textTheme.labelMedium!.copyWith(color: AppColors.secondaryColor),
          ),
        ).paddingOnly(top: 4)
      ],
    );
  }

  Widget _buildAvailableCircle(String team, String matchId) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(
              RoutesName.addPlayer,
              arguments: {"team": team, "matchId": matchId, "needOpenMatches": true},
            );
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor, width: 1),
            ),
            child: const Center(
              child: Icon(Icons.add, color: AppColors.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Available",
          style: Get.textTheme.labelSmall!.copyWith(color: AppColors.primaryColor),
        )
      ],
    );
  }
}