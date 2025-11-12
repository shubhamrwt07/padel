import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/court_slots_shimmer.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../../../handler/text_formatter.dart';
class BookSession extends StatelessWidget {
  BookSession({super.key});
  final BookSessionController controller = Get.put(BookSessionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: _bottomButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                  offset: Offset(0, -Get.height * 0.05),
                  child: _buildTimeOfDayTabs()),  // <-- Added here
              Transform.translate(
                  offset: Offset(0, -Get.height * 0.04),
                  child: _buildMultiDateSummary()),
              Obx((){
                final totalSelections = controller.getTotalSelectionsCount();
                return Transform.translate(
                    offset: Offset(0,totalSelections == 0? -Get.height * 0.05:-Get.height*0.04),
                    child: _buildAllCourtsWithSlots());
              })

            ],
          ),
        ),
      ),
    );
  }
  /// NEW: Multi-date selections summary widget
  Widget _buildMultiDateSummary() {
    return Obx(() {
      final selectionsByDate = controller.getSelectionsByDate();
      final totalSelections = controller.getTotalSelectionsCount();

      if (totalSelections == 0) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Bookings',
                  style: Get.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalSelections slots',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.clearAllSelections(),
                      child: Icon(
                        Icons.clear_all,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Show summary by date
            ...selectionsByDate.entries.map((entry) {
              final date = entry.key;
              final selections = entry.value;
              final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(date));

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: selections.map((selection) {
                        final slot = selection['slot'];
                        final courtName = selection['courtName'];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${slot.time} - $courtName',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryColor,
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
      );
    });
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

        Obx(() => Row(
          children: [
            /// Month container (vertical text)
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                width: 30,
                height: Get.height * 0.068,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.textFieldColor,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),

            /// Date timeline
            Expanded(
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
                  final dateSelections =
                      controller.getSelectionsByDate()[dateString] ?? [];

                  return GestureDetector(
                    onTap: () {
                      onTap();
                      // 👇 Update both selectedDate and focusedMonth here
                      controller.selectedDate.value = date;
                      controller.focusedMonth.value =
                          DateTime(date.year, date.month, 1);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 60,
                          width: Get.width * 0.11,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isSelected
                                ? Colors.black
                                : dateSelections.isNotEmpty
                                ? AppColors.primaryColor
                                .withValues(alpha: 0.1)
                                : AppColors.playerCardBackgroundColor,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : dateSelections.isNotEmpty
                                  ? AppColors.primaryColor
                                  : AppColors.blackColor.withAlpha(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${date.day}",
                                style: Get.textTheme.titleMedium!.copyWith(
                                  fontSize: 20,
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
                            top: 1,
                            right: -3,
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
                },

                onDateChange: (date) async {
                  controller.selectedDate.value = date;
                  controller.focusedMonth.value =
                      DateTime(date.year, date.month, 1); // 👈 Update month
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
        ).paddingOnly(top: 10)),

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
        {"label": "Morning", "icon": Icons.wb_twilight_sharp},
        {"label": "Noon", "icon": Icons.wb_sunny},
        {"label": "Night", "icon": Icons.nightlight_round},
      ];

      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.lightBlueColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = selectedTab == index;

            return Flexible(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    controller.selectedTimeOfDay.value = index;
                    controller.filterSlotsByTimeOfDay();
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
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tab['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.black87,
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

  /// Build all courts with their slots
// In _buildAllCourtsWithSlots method, remove the swipe hint section

// Updated _buildAllCourtsWithSlots method to show all courts in a scrollable list

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

      return Column(
        children: [
          // Show all courts in a list
          ...courts.asMap().entries.map((entry) {
            final index = entry.key;
            final court = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCourtSection(court, index),
            );
          }).toList(),

          const SizedBox(height: 26),
        ],
      );
    });
  }
  /// Build individual court section with its slots
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
                    Obx(() {
                      final courtId = courtData.sId ?? '';
                      final selectedCount = controller.getSelectedSlotsCountForCourt(courtId);
                      return selectedCount > 0
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$selectedCount selected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : const SizedBox.shrink();
                    }),
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

    Color backgroundColor;
    Color textColor;

    if (isUnavailable) {
      backgroundColor = Colors.grey.shade300;
      textColor = Colors.grey.shade600;
    } else if (isSelected) {
      backgroundColor = Colors.black;
      textColor = Colors.white;
    } else {
      backgroundColor = AppColors.playerCardBackgroundColor;
      textColor = Colors.black;
    }

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.blackColor.withAlpha(20),

            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          formatTimeSlot(slot.time??""),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
  /// Bottom bar with total & book button
  Widget _bottomButton() {
    return Container(
      alignment: Alignment.center,
      height: Get.height * .11,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
                () => CustomButton(
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
                  : Row(
                mainAxisAlignment:controller.multiDateSelections.isNotEmpty? MainAxisAlignment.start:MainAxisAlignment.center,
                children: [
                  if (controller.multiDateSelections.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "₹ ",
                            style: Get.textTheme.titleMedium!.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "${controller.totalAmount}",
                            style: Get.textTheme.titleMedium!.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ).paddingOnly(
                      right: Get.width * 0.3,
                      left: Get.width * 0.05,
                    ),
                  Text(
                    "Book Now",
                    style: Get.textTheme.headlineMedium!.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ).paddingOnly(right: controller.multiDateSelections.isNotEmpty?0:40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
