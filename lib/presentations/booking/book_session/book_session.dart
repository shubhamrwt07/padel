import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:shimmer/shimmer.dart';

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
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.03),
                child: _buildTimeOfDayTabs(),
              ),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.02),
                child: _buildMultiDateSummary(),
              ),
              Obx(() {
                final totalSelections = controller.getTotalSelectionsCount();
                return Transform.translate(
                  offset: Offset(
                    0,
                    totalSelections == 0
                        ? -Get.height * 0.03
                        : -Get.height * 0.02,
                  ),
                  child: _buildAllCourtsWithSlots(),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  /// Helper function to safely convert any value to String
  String _getStringValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }
    if (value is List) return '';
    return value.toString();
  }

  /// Multi-date selections summary widget
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
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
          ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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

            /// Show summary by date
            ...selectionsByDate.entries.map((entry) {
              final date = entry.key;
              final selections = entry.value;
              final dateString = _getStringValue(date);

              DateTime parsedDate;
              try {
                parsedDate = DateTime.parse(dateString);
              } catch (e) {
                parsedDate = DateTime.now();
              }

              final formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

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
                        final slotTimeStr = _getStringValue(slot?.time ?? slot.time);
                        final courtNameStr = _getStringValue(courtName);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$slotTimeStr - $courtNameStr',
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
            }).toList(),
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
        /// Top Row with only title
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Select Date",
              style: Get.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ).paddingOnly(top: 10),

        const SizedBox(height: 8),

        /// Date picker wrapped separately with Obx
        Obx(() => Row(
          children: [
            Transform.translate(
              offset: const Offset(0, -19),
              child: Container(
                width: 30,
                height: Get.height * 0.07,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.textFieldColor.withAlpha(100),
                  border: Border.all(
                    color: AppColors.blackColor.withAlpha(10),
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    DateFormat('MMM').format(
                      controller.selectedDate.value ?? DateTime.now(),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
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
                itemExtent: 55,
                itemBuilder: (context, date, isSelected, isDisabled, isToday,
                    onTap) {
                  return Obx(() {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final currentDate =
                    DateTime(date.year, date.month, date.day);
                    if (currentDate.isBefore(today)) {
                      return const SizedBox.shrink();
                    }

                    final dayName = DateFormat('E').format(date);
                    final dateString =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    final dateSelections =
                        controller.getSelectionsByDate()[dateString] ?? [];

                    return GestureDetector(
                      onTap: onTap,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            height: Get.height * 0.07,
                            width: Get.width * 0.13,
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
                                    fontSize: 18,
                                    color: isSelected
                                        ? Colors.white
                                        : dateSelections.isNotEmpty
                                        ? AppColors.primaryColor
                                        : AppColors.textColor,
                                  ),
                                ),
                                Text(
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
                  });
                },
                onDateChange: (date) async {
                  controller.selectedDate.value = date;
                  controller.isLoadingCourts.value = true;
                  await controller.getAvailableCourtsById(
                    controller.argument.id!,
                    showUnavailable: controller.showUnavailableSlots.value,
                  );
                  controller.slots.refresh();
                  controller.isLoadingCourts.value = false;
                },
              ),
            )
          ],
        )),

        const SizedBox(height: 12),

        /// Toggle row moved here below date picker
        Obx(() => Transform.translate(
          offset: Offset(0, -Get.height * .05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left text — indicates current view
              Text(
                controller.showUnavailableSlots.value
                    ? "Unavailable Slots"
                    : "Available Slots",
                style: Get.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),

              /// Right toggle + label
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
                          showUnavailable: controller.showUnavailableSlots.value,
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

  /// Time of Day Filter Tabs (Morning / Noon / Night)
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
          borderRadius: BorderRadius.circular(30),
          color: AppColors.lightBlueColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = selectedTab == index;

            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    controller.selectedTimeOfDay.value = index;
                    controller.filterSlotsByTimeOfDay();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab["icon"] as IconData,
                          size: 18,
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black87,
                        ),
                        const SizedBox(width: 6),
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
  Widget _buildAllCourtsWithSlots() {
    return Obx(() {
      if (controller.isLoadingCourts.value) {
        return const CourtSlotsShimmer();
      }

      final slotsData = controller.slots.value;

      if (slotsData == null ||
          slotsData.data == null ||
          slotsData.data!.isEmpty) {
        return const Center(child: Text("No courts available"));
      }

      final courts = slotsData.data!;
      final totalPages = (courts.length / 2).ceil();

      return Column(
        children: [
          /// PageView for courts
          SizedBox(
            height: Get.height * 0.45,
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              itemCount: totalPages,
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * 2;
                final end =
                (start + 2 > courts.length) ? courts.length : start + 2;
                final courtsSlice = courts.sublist(start, end);

                return Column(
                  children: courtsSlice
                      .map((court) => _buildCourtSection(court))
                      .toList(),
                );
              },
            ),
          ),

          /// Swipe hint with arrow animation
          Obx(() {
            final currentPage = controller.currentPage.value;

            if (totalPages <= 1) return const SizedBox.shrink();

            if (currentPage == 0) {
              return _buildSwipeHint(
                "Swipe Left for more slots ",
                Icons.arrow_right_alt,
              );
            } else if (currentPage == totalPages - 1) {
              return _buildSwipeHint("Swipe Right", Icons.arrow_left);
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: 6),

          /// Dot indicator placed right below courts
          _buildDotIndicator(totalPages),
          const SizedBox(height: 26),
        ],
      );
    });
  }

  /// Build individual court section with its slots
  Widget _buildCourtSection(dynamic courtData) {
    final courtName = _getStringValue(courtData.courtName);
    final slotTimes = courtData.slots ?? [];

    /// Safely get court type
    var courtTypeValue = courtData.registerClubId?.courtType ??
        courtData.register_club_id?.courtType ??
        'Standard court';
    final courtType = _getStringValue(courtTypeValue);
    final featureText = courtType.isEmpty ? 'Standard court' : courtType;

    log("Building court section for: $courtName with ${slotTimes.length} slots");

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Court Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.1),
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
                        courtName.isEmpty ? 'Unknown Court' : courtName,
                        style: Get.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    Obx(() {
                      final courtId = courtData.sId ?? '';
                      final selectedCount =
                      controller.getSelectedSlotsCountForCourt(courtId);
                      return selectedCount > 0
                          ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          /// Slots Grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildSlotsGrid(slotTimes, courtData.sId ?? ''),
          ),
        ],
      ),
    );
  }

  /// Build slots grid for a specific court
  Widget _buildSlotsGrid(List<dynamic> slotTimes, String courtId) {
    if (slotTimes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.schedule,
                size: 32,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                "No time slots available",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 14,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                controller.showUnavailableSlots.value
                    ? Icons.event_available
                    : Icons.event_busy,
                size: 32,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                controller.showUnavailableSlots.value
                    ? "No unavailable slots"
                    : "No available slots",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.showUnavailableSlots.value
                    ? "All slots are currently available"
                    : "Try selecting a different date",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
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
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
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

    /// Safely get slot time
    final slotTime = _getStringValue(slot.time);

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
            color:
            isSelected ? Colors.black : AppColors.blackColor.withAlpha(20),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          slotTime.isEmpty ? '--' : slotTime,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  /// Swipe hint with animation
  Widget _buildSwipeHint(String text, IconData icon) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: 0, end: 10),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: value),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon == Icons.arrow_left)
                Icon(icon, color: AppColors.primaryColor),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 6),
              if (icon == Icons.arrow_right_alt)
                Icon(icon, color: AppColors.primaryColor),
            ],
          ),
        );
      },
    );
  }

  /// Dot indicator for page view
  Widget _buildDotIndicator(int totalPages) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          final isActive = index == controller.currentPage.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: isActive ? 10 : 8,
            width: isActive ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primaryColor : Colors.grey.shade400,
            ),
          );
        }),
      );
    });
  }

  /// Bottom bar with total & book button
  Widget _bottomButton() {
    return Container(
      alignment: Alignment.center,
      height: Get.height * .09,
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
          /// Book Now button
          Obx(
                () => CustomButton(
              width: Get.width * 0.9,
              onTap: () {
                if (controller.multiDateSelections.isEmpty) {
                  Get.snackbar(
                    "Select Slots",
                    "Please select at least one slot before booking.",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(12),
                    duration: const Duration(seconds: 2),
                    icon: const Icon(Icons.info, color: Colors.white),
                  );
                  return;
                }
                controller.addToCart();
              },
              child: controller.cartLoader.value
                  ? CircularProgressIndicator(color: AppColors.whiteColor)
                  : Row(
                children: [
                  Obx(
                        () => RichText(
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
                  ),
                  Text(
                    "Book Now",
                    style: Get.textTheme.headlineMedium!
                        .copyWith(color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading shimmer effect for courts
class CourtSlotsShimmer extends StatelessWidget {
  const CourtSlotsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(2, (courtIndex) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Court Header Placeholder
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 50,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                /// Slots Grid Placeholder
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.8,
                    ),
                    itemBuilder: (_, __) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}