import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/court_slots_shimmer.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/upword_arrow_animation.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../../../handler/text_formatter.dart';
class BookSession extends StatelessWidget {
  BookSession({super.key});
  final BookSessionController controller = Get.put(BookSessionController());
  @override
  Widget build(BuildContext context) {
    return Stack(  // Change from Scaffold to Stack
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80), // bottom padding for button
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.05),
                child: _buildTimeOfDayTabs(),
              ),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.04),
                child: _buildAllCourtsWithSlots(),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _bottomButton(context),
        ),
      ],
    );
  }
  /// 📅 Date Picker - Fixed spacing and toggle functionality
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Date",
          style: Get.textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).paddingOnly(top: 10),

        Obx(() => Transform.translate(
          offset: const Offset(0, -30),

          child: Row(
            children: [
              /// Month container (vertical text)
              Transform.translate(
                offset: const Offset(0, 0),
                child: Container(
                  width: 25,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffF3F3F5),
                    border: Border.all(
                      color: AppColors.blackColor.withAlpha(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: DateFormat('MMM')
                        .format(controller.focusedMonth.value)
                        .toUpperCase()
                        .split('')
                        .map(
                          (char) => Text(
                        char,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ).paddingOnly(right: 5),
              ),

              /// Date timeline with scroll listener
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      final scrollOffset = scrollNotification.metrics.pixels;
                      final itemExtent = 46.0;
                      final itemsScrolled = (scrollOffset / itemExtent).round();
                      final estimatedDate = DateTime.now().add(Duration(days: itemsScrolled));

                      // Update focusedMonth based on scroll position
                      final newMonth = DateTime(estimatedDate.year, estimatedDate.month, 1);
                      if (controller.focusedMonth.value.month != newMonth.month ||
                          controller.focusedMonth.value.year != newMonth.year) {
                        controller.focusedMonth.value = newMonth;
                      }
                    }
                    return false;
                  },
                  child: EasyDateTimeLinePicker.itemBuilder(
                    headerOptions: HeaderOptions(
                      headerBuilder: (_, context, date) =>
                      const SizedBox.shrink(),
                    ),
                    selectionMode: SelectionMode.alwaysFirst(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030, 3, 18),
                    focusedDate: controller.selectedDate.value,
                    itemExtent: 46,
                    itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final currentDate = DateTime(date.year, date.month, date.day);
                      if (currentDate.isBefore(today)) return const SizedBox.shrink();

                      final dayName = DateFormat('E').format(date);
                      final dateString =
                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                      return GestureDetector(
                        onTap: () {
                          onTap();
                          // Update both selectedDate and focusedMonth here
                          controller.selectedDate.value = date;
                          controller.focusedMonth.value =
                              DateTime(date.year, date.month, 1);
                        },
                        child: Obx(() {
                          final dateSelections =
                              controller.getSelectionsByDate()[dateString] ?? [];

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 55,
                                  width: Get.width * 0.11,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: isSelected ? LinearGradient(
                                      colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ) : null,
                                    color: isSelected ? null : Colors.white,
                                    // color: isSelected
                                    //     ? Colors.black
                                    //     : dateSelections.isNotEmpty
                                    //     ? AppColors.primaryColor
                                    //     .withValues(alpha: 0.1)
                                    //     : AppColors.playerCardBackgroundColor,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : dateSelections.isNotEmpty
                                          ? AppColors.primaryColor
                                          : AppColors.blackColor.withAlpha(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${date.day}",
                                        style: Get.textTheme.titleMedium!.copyWith(
                                          fontSize: 18,
                                          color: isSelected
                                              ? Colors.white
                                              : dateSelections.isNotEmpty
                                              ? AppColors.primaryColor
                                              : AppColors.textColor,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -2),
                                        child: Text(
                                          dayName,
                                          style: Get.textTheme.bodySmall!.copyWith(
                                            fontSize: 11,
                                            color: isSelected
                                                ? Colors.white
                                                : dateSelections.isNotEmpty
                                                ? AppColors.primaryColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (dateSelections.isNotEmpty)
                                  Positioned(
                                    top: -3,
                                    right: -2,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.secondaryColor,
                                      ),
                                      child: Text(
                                        "${dateSelections.length}",
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      );
                    },

                    onDateChange: (date) async {
                      controller.selectedDate.value = date;
                      controller.focusedMonth.value =
                          DateTime(date.year, date.month, 1);
                      controller.isLoadingCourts.value = true;
                      await controller.getAvailableCourtsById(
                        controller.argument.id!,
                        showUnavailable:
                        controller.showUnavailableSlots.value,
                      );
                      controller.slots.refresh();
                      controller.isLoadingCourts.value = false;
                    },
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: 10),
        )),

        /// Toggle Row
        Obx(() => Transform.translate(
          offset: Offset(0, -Get.height * .06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Available Slots", style: Get.textTheme.labelLarge),
              Row(
                children: [
                  Text(
                    controller.showUnavailableSlots.value
                        ? "Show Available Slots"
                        : "Show Unavailable Slots",
                    style: Get.textTheme.labelSmall?.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: controller.showUnavailableSlots.value,
                      activeTrackColor: AppColors.secondaryColor,
                      onChanged: (val) async {
                        controller.showUnavailableSlots.value = val;
                        controller.isLoadingCourts.value = true;
                        await controller.getAvailableCourtsById(
                          controller.argument.id!,
                          showUnavailable:
                          controller.showUnavailableSlots.value,
                        );
                        controller.slots.refresh();
                        controller.isLoadingCourts.value = false;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
  /// Time of Day Filter Tabs (Morning /Noon/ Night)
  Widget _buildTimeOfDayTabs() {
    return Obx(() {
      final selectedTab = controller.selectedTimeOfDay.value;
      final tabs = [
        {"label": "Morning", "icon": Icons.wb_twilight_sharp, "value": 0},
        {"label": "Noon", "icon": Icons.wb_sunny, "value": 1},
        {"label": "Evening", "icon": Icons.nightlight_round, "value": 2},
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
                  final value = tab["value"] as int;
                  final isSelected = selectedTab == value;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.selectedTimeOfDay.value = value;
                        controller.filterSlotsByTimeOfDay();
                      },
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
                final value = tab["value"] as int;
                final isSelected = selectedTab == value;

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

  /// Build all courts with their slots
  Widget _buildAllCourtsWithSlots() {
    return Obx(() {
      if (controller.isLoadingCourts.value) {
        return CourtSlotsShimmer();
      }

      final slotsData = controller.slots.value;

      if (slotsData == null || slotsData.data == null || slotsData.data!.isEmpty) {
        return const Center(child: Text("No courts available"));
      }

      final courts = slotsData.data!;

      return GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe left (negative velocity) = next tab
          if (details.primaryVelocity! < -300) {
            // Move to next tab
            int nextTab = (controller.selectedTimeOfDay.value + 1) % 3;
            controller.selectedTimeOfDay.value = nextTab;
            controller.filterSlotsByTimeOfDay();
          }
          // Swipe right (positive velocity) = previous tab
          else if (details.primaryVelocity! > 300) {
            // Move to previous tab
            int prevTab = (controller.selectedTimeOfDay.value - 1) % 3;
            if (prevTab < 0) prevTab = 2; // Wrap around to Night
            controller.selectedTimeOfDay.value = prevTab;
            controller.filterSlotsByTimeOfDay();
          }
        },
        child: Column(
          children: [
            // Show all courts in a list
            ...courts.asMap().entries.map((entry) {
              final index = entry.key;
              final court = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCourtSection(court, index),
              );
            }),

            const SizedBox(height: 26),
          ],
        ),
      );
    });
  }

  Widget _buildCourtSection(dynamic courtData, int index) {
    final courtName = courtData.courtName ?? 'Unknown Court';
    final slotTimes = courtData.slots ?? [];

    final courtTypes = courtData.registerClubId?.courtType;

    final featureText = (courtTypes is List && index < courtTypes.length)
        ? courtTypes[index].toString()
        : 'Standard court';

    log("Building court section for: $courtName with ${slotTimes.length} slots");

    // Check if there are any slots to display
    final hasSlots = slotTimes.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        courtName,
                        style: Get.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    // Obx(() {
                    //   final courtId = courtData.sId ?? '';
                    //   final selectedCount = controller.getSelectedSlotsCountForCourt(courtId);
                    //   return selectedCount > 0
                    //       ? Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.secondaryColor,
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Text(
                    //       '$selectedCount selected',
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   )
                    //       : const SizedBox.shrink();
                    // }),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  featureText,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Slots Grid - Reduced padding when no slots
          Padding(
            padding: hasSlots
                ? const EdgeInsets.all(12)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: _buildSlotsGrid(slotTimes, courtData.sId ?? ''),
          ),
        ],
      ),
    );
  }
  /// Build slots grid for a specific court
  Widget _buildSlotsGrid(List<dynamic> slotTimes, String courtId) {
    if (slotTimes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),  // Reduced from 15
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Important: shrink to content
            children: const [
              Icon(
                Icons.schedule,
                size: 20,  // Slightly smaller icon
                color: Colors.grey,
              ),
              SizedBox(height: 6),  // Reduced spacing
              Text(
                "No time slots available",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 12,  // Slightly smaller text
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filteredSlots = slotTimes;

    if (filteredSlots.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),  // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Important: shrink to content
            children: [
              Icon(
                controller.showUnavailableSlots.value
                    ? Icons.event_available
                    : Icons.event_busy,
                size: 28,  // Slightly smaller
                color: Colors.grey,
              ),
              const SizedBox(height: 6),
              Text(
                controller.showUnavailableSlots.value
                    ? "No unavailable slots"
                    : "No available slots",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                controller.showUnavailableSlots.value
                    ? "All slots are currently available"
                    : "Try selecting a different date",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8,
        childAspectRatio: 2.3,
      ),
      itemCount: filteredSlots.length,
      itemBuilder: (context, index) {
        final slot = filteredSlots[index];
        return Obx(() => _buildSlotTile(slot, courtId));
      },
    );
  }
  /// Build individual slot tile
  Widget _buildSlotTile(dynamic slot, String courtId) {
    final isSelected = controller.isSlotSelected(slot, courtId);

    final isUnavailable = controller.isPastAndUnavailable(slot) ||
        (slot.status?.toLowerCase() == 'booked') ||
        (slot.availabilityStatus?.toLowerCase() == 'maintenance') ||
        (slot.availabilityStatus?.toLowerCase() == 'weather conditions') ||
        (slot.availabilityStatus?.toLowerCase() == 'staff unavailability');

    const blueColor = Color(0xff053CFF);
    const radius = 5.0;

    return GestureDetector(
      onTap: isUnavailable
          ? null
          : () {
        controller.toggleSlotSelection(
          slot,
          courtId: courtId,
          courtName: '',
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: isUnavailable ? Colors.grey.shade100 : Colors.white,
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
                : null,
            border: Border.all(
              color: isUnavailable
                  ? Colors.grey.shade300
                  : Colors.grey.shade300,
            ),
          ),
          child: Stack(
            children: [
              /// LEFT BLUE STRIP (ONLY WHEN AVAILABLE)
              if (!isUnavailable && !isSelected)
                Positioned.fill(
                  left: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(radius),
                          bottomLeft: Radius.circular(radius),
                        ),
                      ),
                    ),
                  ),
                ),

              /// TIME TEXT
              Center(
                child: Text(
                  formatTimeSlot(slot.time ?? ""),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isUnavailable
                        ? Colors.grey.shade500
                        : isSelected
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Bottom bar with total & book button
  Widget _bottomButton(BuildContext context) {
    return Obx(() {
      final hasSelections = controller.multiDateSelections.isNotEmpty;
      final totalSelections = controller.getTotalSelectionsCount();

      final double collapsedHeight = Get.height * .11;
      final double expandedHeight = Get.height * .13;
      void openSelectedSlotsBottomSheet(BuildContext context) {
        if (Get.isSnackbarOpen) return;
        if (controller.multiDateSelections.isEmpty) return;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetContext) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.65,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Obx(() {
                        final selectionsByDate = controller.getSelectionsByDate();
                        final totalSelections = controller.getTotalSelectionsCount();

                        if (totalSelections == 0) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (Navigator.of(sheetContext).canPop()) {
                              Navigator.of(sheetContext).pop();
                            }
                          });
                          return const SizedBox.shrink();
                        }

                        final totalAmount = controller.totalAmount.value;
                        final entries = selectionsByDate.entries.toList()
                          ..sort((a, b) => a.key.compareTo(b.key));

                        return SafeArea(
                          top: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Selected Slots Summary',
                                      style: Get.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,fontSize: 16
                                      ),
                                    ),
                                    // IconButton(
                                    //   splashRadius: 20,
                                    //   padding: EdgeInsets.zero,
                                    //   constraints: const BoxConstraints(),
                                    //   onPressed: () => Navigator.of(sheetContext).pop(),
                                    //   icon: const Icon(Icons.close_rounded, size: 22),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Summary',
                                            style: Get.textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '$totalSelections slot${totalSelections > 1 ? 's' : ''} selected',
                                            style: Get.textTheme.bodySmall?.copyWith(
                                              color: AppColors.darkGrey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹ ${formatAmount(totalAmount)}',
                                        style: Get.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                child: Text(
                                  'Date-wise Breakdown',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.labelBlackColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: entries.length,
                                  itemBuilder: (context, index) {
                                    final entry = entries[index];
                                    final date = DateTime.parse(entry.key);
                                    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
                                    final dayName = DateFormat('EEEE').format(date);
                                    final selections = entry.value;
                                    final selectionsByCourt = <String, List<Map<String, dynamic>>>{};

                                    for (final selection in selections) {
                                      final courtId = selection['courtId'] as String? ?? '';
                                      selectionsByCourt.putIfAbsent(courtId, () => []).add(selection);
                                    }

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// ---- OUTSIDE ROW ---- ///
                                        Row(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.calendar_month,
                                                color: AppColors.primaryColor,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                '$formattedDate ($dayName)',
                                                style: Get.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                '${selections.length}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 6),

                                        /// ---- CONTAINER BELOW ---- ///
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 14),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: Colors.grey.shade200),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.04),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ...selectionsByCourt.entries.map((courtEntry) {
                                                final courtSelections = courtEntry.value;
                                                final courtName =
                                                (courtSelections.first['courtName'] ?? 'Court');

                                                return Container(
                                                  margin: const EdgeInsets.only(bottom: 0),
                                                  padding: const EdgeInsets.all(3),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.sports_tennis,
                                                              size: 14, color: AppColors.primaryColor),
                                                          const SizedBox(width: 6),
                                                          Expanded(
                                                            child: Text(
                                                              courtName,
                                                              style: Get.textTheme.bodyMedium?.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            courtSelections.length == 1
                                                                ? '1 slot'
                                                                : '${courtSelections.length} slots',
                                                            style: Get.textTheme.bodySmall?.copyWith(
                                                              color: AppColors.darkGrey,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Wrap(
                                                        spacing: 6,
                                                        runSpacing: 6,
                                                        children: courtSelections.map((selection) {
                                                          final formattedTime =
                                                          formatTimeSlot(selection['slot'].time);

                                                          return Container(
                                                            width: 60,
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: AppColors.blackColor,
                                                              borderRadius: BorderRadius.circular(6),
                                                            ),
                                                            child: Text(
                                                              formattedTime,
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Positioned(
                        top: -10,
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => Get.back(),
                                child: ClipRect(
                                  child: Align(
                                    alignment: Alignment.topCenter,        // show only top part
                                    heightFactor: 0.6,
                                    child: Transform.translate(
                                      offset: Offset(0,4),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withValues(alpha: 0.1),
                                              blurRadius: 1,
                                              spreadRadius: -2,
                                              offset: Offset(0, -5),
                                            ),
                                          ],
                                        ),
                                        child: Transform.translate(offset: Offset(0, -10),child: ArrowAnimation(isUpward: false,)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      }
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        height: hasSelections ? expandedHeight : collapsedHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: hasSelections
              ? (details) {
                  if ((details.primaryVelocity ?? 0) < -300) {
                    openSelectedSlotsBottomSheet(context);
                  }
                }
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasSelections)
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    GestureDetector(
                      onTap: ()=>openSelectedSlotsBottomSheet(context),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              "$totalSelections slot${totalSelections > 1 ? 's' : ''} selected",
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${formatAmount(controller.totalAmount.value)}",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 18,right: 18,),
                      ),
                    ),
                    Positioned(
                      top: -20,
                      child: InkWell(
                        onTap: () => openSelectedSlotsBottomSheet(context),
                        customBorder: const CircleBorder(),
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,        // show only top part
                            heightFactor: 0.7,
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 1,
                                    spreadRadius: -2,
                                    offset: Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Transform.translate(offset: Offset(0, -5),child: ArrowAnimation(isUpward: true,)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              CustomButton(
                width: Get.width * 0.9,
                onTap: () {
                  if (controller.multiDateSelections.isEmpty) {
                    SnackBarUtils.showInfoSnackBar(
                        "Please select at least one slot before booking.");
                    return;
                  }
                  controller.addToCart();
                },
                child: controller.cartLoader.value
                    ? LoadingAnimationWidget.waveDots(
                        color: AppColors.whiteColor,
                        size: 45,
                      ).paddingOnly(right: 40)
                    : Text(
                        "Book Now",
                        style: Get.textTheme.headlineMedium!.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
