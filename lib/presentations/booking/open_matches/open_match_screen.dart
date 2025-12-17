import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/components/multiple_gender.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/booking_exports.dart';

class OpenMatchesScreen extends StatelessWidget {
  final OpenMatchesController controller = Get.put(OpenMatchesController());
  final storage = GetStorage();
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
                  SizedBox(height: 10,),
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
                        children: matches.data!.asMap().entries.map((entry) =>
                          _buildMatchCardFromData(context, entry.value, entry.key)).toList(),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Date",
              style: Get.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
            // Obx(() => PopupMenuButton<String>(
            //   offset: Offset(0, 30),
            //   splashRadius: 0,
            //   padding: EdgeInsets.zero,
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            //     decoration: BoxDecoration(
            //       color: AppColors.primaryColor,
            //       border: Border.all(color: AppColors.blackColor.withAlpha(20)),
            //       borderRadius: BorderRadius.circular(4),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Text(
            //           controller.selectedGameLevel.value,
            //           style: Get.textTheme.labelMedium!.copyWith(color: Colors.white),
            //         ),
            //         SizedBox(width: 4),
            //         Icon(Icons.keyboard_arrow_down, size: 16,color: Colors.white,),
            //       ],
            //     ),
            //   ),
            //   itemBuilder: (context) => [
            //     PopupMenuItem(height: 40,value: "Beginner", child: Text("Beginner",style: Get.textTheme.labelMedium)),
            //     PopupMenuItem(height: 40,value: "Intermediate", child: Text("Intermediate",style: Get.textTheme.labelMedium)),
            //     PopupMenuItem(height: 40,value: "Advanced", child: Text("Advanced",style: Get.textTheme.labelMedium)),
            //     PopupMenuItem(height: 40,value: "Professional", child: Text("Professional",style: Get.textTheme.labelMedium)),
            //   ],
            //   onSelected: (value) {
            //     controller.selectedGameLevel.value = value;
            //   },
            // )),
          ],
        ),
        Obx(
              () => Transform.translate(
            offset: Offset(0, -19),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffF3F3F5),
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
                        fontSize: 11,
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
                              height: 55,
                              width: Get.width * 0.11,
                              key: ValueKey(isSelected),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: isSelected ? LinearGradient(
                                  colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ) : null,
                                color: isSelected ? null : Colors.white,
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : AppColors.blackColor.withAlpha(20),
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
                                  Transform.translate(
                                    offset: Offset(0, -2),
                                    child: Text(
                                      dayName,
                                      style: Get.textTheme.bodySmall!.copyWith(
                                        fontSize: 11,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
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
  Widget _buildMatchCardFromData(BuildContext context, MatchData data, int index) {
    final dayStr = controller.getDay(data.matchDate);
    final dateOnlyStr = controller.getDate(data.matchDate);
    
    // Get all slot times and format as range
    final slotTimes = data.slot?.expand((slot) => 
        slot.slotTimes?.map((st) => st.time ?? '') ?? <String>[]
    ).where((time) => time.isNotEmpty).toList() ?? [];
    final timeStr = controller.formatTimeRange(slotTimes);
    
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
        index,
        p.userId?.lastName??""
      );
    }).toList();

    while (teamAPlayers.length < 2) {
      teamAPlayers.add(
        _buildAvailableCircle("teamA", data.sId ?? "", data.skillLevel, index, data),
      );
    }

    // TEAM B
    final teamBPlayers = (data.teamB ?? []).take(2).map((p) {
      return _buildFilledPlayer(
        p.userId?.profilePic ?? "",
        p.userId?.name ?? "",
        p.userId?.playerLevel?.split(' ').first ?? "-",
        index,
        p.userId?.lastName??""
      );
    }).toList();

    while (teamBPlayers.length < 2) {
      teamBPlayers.add(
        _buildAvailableCircle("teamB", data.sId ?? "", data.skillLevel, index, data),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: const Color(0xffeaf0ff),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color:index % 2 == 0? Color(0xffC8D6FB):Color(0xff3DBE64).withValues(alpha: 0.5)),
        gradient: LinearGradient(
            colors: index % 2 == 0
              ? [Color(0xffF3F7FF), Color(0xff9EBAFF).withValues(alpha: 0.3)]
              : [Color(0xffBFEECD).withValues(alpha: 0.3),Color(0xffBFEECD).withValues(alpha: 0.2)],
        )
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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),

          // 🧑‍🧑‍ Players Row
          Container(
            width: (teamAPlayers.length + teamBPlayers.length) * 30 + 42,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
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
                      left: i * 35, // overlap amount
                      child: teamAPlayers[i],
                    ),

                  // TEAM B PLAYERS (start AFTER Team A)
                  for (int i = 0; i < teamBPlayers.length; i++)
                    Positioned(
                      left: (teamAPlayers.length * 35) + (i * 35),
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
                          color:index % 2 == 0? AppColors.primaryColor:AppColors.secondaryColor,
                        ),
                        child:Icon(Icons.chat_outlined, color: Colors.white, size: 18)
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  if (_isMatchCreator(data)) ...[
                    GestureDetector(
                      onTap: () => _showRequestsBottomSheet(context, data.sId ?? ''),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const Icon(Icons.notifications, color: AppColors.primaryColor,size: 18,),
                            RichText(
                              text: TextSpan(
                                text: 'Players Requests ',
                                style: Get.textTheme.labelSmall!.copyWith(decoration: TextDecoration.underline),
                                children: [
                                  TextSpan(
                                    text: '(',
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '0',
                                    style: Get.textTheme.labelSmall!.copyWith(color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                    text: ')',
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
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
              Transform.translate(
                offset: Offset(0, 2),
                child: Text(
                  "₹ ${formatAmount(price)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff1c46a0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilledPlayer(String? imageUrl, String name, String level,int index,String lastName) {
    final firstLetter = name.trim().isNotEmpty
        ? '${name.trim()[0]}${lastName.trim().isNotEmpty ? lastName.trim()[0] : ''}'
        : '?';

    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: index % 2 == 0? const Color(0xffeaf0ff):Color(0xffDFF7E6),
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
                style:  TextStyle(
                  fontSize: 18,
                  color: index % 2 == 0? AppColors.primaryColor:AppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : Center(
            child: Text(
              firstLetter,
              style:  TextStyle(
                fontSize: 18,
                color: index % 2 == 0? AppColors.primaryColor:AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAvailableCircle(String team, String matchId, String? skillLevel, int index, MatchData? match) {
    final isLoginUserInMatch = _isLoginUserInMatch(match);
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RoutesName.addPlayer,
          arguments: {
            "team": team,
            "matchId": matchId,
            "needOpenMatches": true,
            "matchLevel": skillLevel,
            "isLoginUser": !isLoginUserInMatch,
            "isMatchCreator": _isMatchCreator(match),
          },
        );
      },
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 24,
          backgroundColor:index % 2 == 0? const Color(0xffeaf0ff):Color(0xffDFF7E6),
          child: Icon(Icons.add, color:index % 2 == 0? AppColors.primaryColor:AppColors.secondaryColor),
        ),
      ),
    );
  }

  // Helper method to check if login user is in the match
  bool _isLoginUserInMatch(MatchData? match) {
    final userId = storage.read('userId');
    if (userId == null || match == null) return false;

    // Check in teamA
    for (final player in match.teamA ?? []) {
      if (player.userId?.sId == userId) return true;
    }

    // Check in teamB
    for (final player in match.teamB ?? []) {
      if (player.userId?.sId == userId) return true;
    }

    return false;
  }

  // Helper method to check if login user is the match creator
  bool _isMatchCreator(MatchData? match) {
    final userId = storage.read('userId');
    if (userId == null || match == null) return false;

    // createdBy is a UserId object, so we need to check the sId field
    return match.createdBy == userId.toString();
  }

  void _showRequestsBottomSheet(BuildContext context, String matchId) {
    controller.fetchJoinRequests(matchId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: Get.height * 0.9,
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Player Requests',
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,color: AppColors.primaryColor
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade300, height: 1),

                /// DESCRIPTION
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "You have new match requests! Accept the requests from the "
                        "players you want to play with. Once accepted, you'll be "
                        "paired for the match and can start competing right away.",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13
                    ),
                  ),
                ),

                /// LIST
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingRequests.value) {
                      return Center(
                        child: LoadingWidget(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (controller.joinRequests.isEmpty) {
                      return Center(
                        child: Text(
                          'No join requests yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: controller.joinRequests.length,
                      itemBuilder: (context, index) {
                        final request = controller.joinRequests[index];
                        return _buildRequestItem(request, matchId);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildRequestItem(Map<String, dynamic> request, String matchId) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// AVATAR
          (request['profilePic'] != null && request['profilePic'].isNotEmpty)
              ? CachedNetworkImage(
            imageUrl: request['profilePic'],
            imageBuilder: (_, imageProvider) => CircleAvatar(
              radius: 26,
              backgroundImage: imageProvider,
            ),
            placeholder: (_, __) => _initialAvatar(request),
            errorWidget: (_, __, ___) => _initialAvatar(request),
          )
              : _initialAvatar(request),

          const SizedBox(width: 12),

          /// USER INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _formatName(request['name'], request['lastName']),
                        style: Get.textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (request['isVerified'] == true)
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.blue,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '⭐ ${request['xp']??"0"} XP Points | ${request['gender'] ?? 'Male'}',
                  style: Get.textTheme.labelSmall!.copyWith(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          /// ACTION BUTTONS
          Row(
            children: [
              // /// REJECT BUTTON
              // Obx(() {
              //   final isRejecting =
              //       controller.rejectingRequestId.value == request['id'];
              //
              //   return GestureDetector(
              //     onTap: isRejecting
              //         ? null
              //         : () => _showRejectConfirmation(request, matchId),
              //     child: Container(
              //       padding:
              //       const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              //       decoration: BoxDecoration(
              //         color: Colors.grey.shade200,
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: isRejecting
              //           ? const SizedBox(
              //         width: 18,
              //         height: 18,
              //         child: LoadingWidget(color: Colors.grey),
              //       )
              //           : Text(
              //         'Reject',
              //         style: Get.textTheme.bodyMedium!.copyWith(
              //           color: Colors.grey.shade700,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 14
              //         ),
              //       ),
              //     ),
              //   );
              // }),
              // const SizedBox(width: 8),
              /// ACCEPT BUTTON
              Obx(() {
                final isAccepting =
                    controller.acceptingRequestId.value == request['id'];

                return GestureDetector(
                  onTap: isAccepting
                      ? null
                      : () => _showAcceptConfirmation(request, matchId),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isAccepting
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: LoadingWidget(color: Colors.white),
                    )
                        : Text(
                      'Accept',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
  Widget _initialAvatar(Map<String, dynamic> request) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
      child: Text(
        _getInitialsFromFullName(request['name'], request['lastName']),
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  String _formatName(String name, [String? lastName]) {
    if (name.isEmpty) return '';
    String fullName = name;
    if (lastName != null && lastName.isNotEmpty) {
      fullName = '$name $lastName';
    }
    final parts = fullName.trim().split(' ');
    return parts.map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase()).join(' ');
  }

  String _getInitialsFromFullName(String name, [String? lastName]) {
    if (name.isEmpty) return '';
    String fullName = name;
    if (lastName != null && lastName.isNotEmpty) {
      fullName = '$name $lastName';
    }
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }

  void _showAcceptConfirmation(Map<String, dynamic> request, String matchId) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 22),
                ),
              ),

              const SizedBox(height: 8),

              // Green check icon
              Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                'Add ${_formatName(request['name'], request['lastName'])} to your open match? '
                    'You won’t be able to remove him later.',
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              // Accept button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    controller.acceptRequest(request['id'], matchId);
                  },
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // void _showRejectConfirmation(Map<String, dynamic> request, String matchId) {
  //   Get.dialog(
  //     AlertDialog(
  //       title: Text('Reject Request'),
  //       content: Text('Are you sure you want to reject ${_formatName(request['name'], request['lastName'])}\'s request to join the match?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Get.back();
  //             controller.rejectRequest(request['id'], matchId);
  //           },
  //           child: Text('Reject', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}