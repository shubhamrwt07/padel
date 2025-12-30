import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/custom_button.dart';
import 'package:padel_mobile/configs/components/fade_divider.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/data/request_models/home_models/get_available_court.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/court_slots_shimmer.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/upword_arrow_animation.dart';
import 'create_open_match_for_all_courts_controller.dart';
class CreateOpenMatchForAllCourtsScreen extends StatelessWidget {

  final CreateOpenMatchForAllCourtsController controller = Get.put(CreateOpenMatchForAllCourtsController());

  CreateOpenMatchForAllCourtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: _bottomBar(context),

      appBar: primaryAppBar(title: Text("Create Open matches"), centerTitle: true, context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildDatePicker(context),
              Transform.translate(
                  offset: Offset(0, -30),
                  child: fadeDivider()),
              Transform.translate(
                  offset: Offset(0, -20),
                  child: _durationSection()),
              Transform.translate(
                offset: Offset(0, -15),
                child: Text(
                  'Available Slots',
                  style: Get.textTheme.labelLarge,
                ),
              ),
              Transform.translate(
                  offset: Offset(0, -5),
                  child: _buildAllCourtsWithSlots()),
              const SizedBox(height: 10),
              availableCourts()
            ],
          ),
        ),
      ),
    );
  }

  Widget _durationSection() {
    final durations = ['30 min', '60 min', '90 min', '120 min'];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(
            () => Row(
          children: durations.map((e) {
            final isSelected = controller.selectedDuration.value == e;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.select(e),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsetsGeometry.symmetric(vertical: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [
                        Color(0xff1F41BB),
                        Color(0xff0E1E55),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                        : null,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isSelected ? 1.05 : 1,
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color:
                        isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget availableCourts() {
    final courts = [
      'The Good Club',
      'Chandigarh Club',
      'Let’s Padel',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Courts',
          style: Get.textTheme.labelLarge,
        ),
        ...List.generate(courts.length, (index) {
          return Obx(() {
            final isExpanded =
                controller.expandedIndex.value == index;

            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                // margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey.shade300),
                  // borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    /// HEADER
                    GestureDetector(
                      onTap: ()=>controller.toggle(index),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: 'https://picsum.photos/44/44?random=$index',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 44,
                                  height: 44,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.sports_tennis),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 44,
                                  height: 44,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.sports_tennis),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courts[index],
                                    style: Get.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Chandigarh',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹ 2000',
                              style: Get.textTheme.titleLarge!.copyWith(fontSize: 23),),
                            const SizedBox(width: 6),

                                AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration:
                                const Duration(milliseconds: 250),
                                child: const Icon(
                                    Icons.keyboard_arrow_down),
                              ),
                          ],
                        ),
                      ),
                    ),

                    /// EXPANDED CONTENT
                    if (isExpanded) ...[
                      const SizedBox(height: 16),

                      _courtRow(
                        courtName: 'Court 1',
                        type: 'Outdoor',
                        selectedIndex: 0,
                      ),

                      const SizedBox(height: 16),

                      _courtRow(
                        courtName: 'Court 2',
                        type: 'Outdoor',
                        selectedIndex: 1,
                      ),

                      const SizedBox(height: 16),

                      _courtRow(
                        courtName: 'Court 3',
                        type: 'Indoor',
                        selectedIndex: 2,
                      ),
                    ],

                  ],
                ),
              ),
            );
          });
        }),
      ],
    );
  }
  Widget _courtRow({
    required String courtName,
    required String type,
    required int selectedIndex,
  }) {
    return Obx(() {
      // Get the same slots for all courts but show different selections
      List<Slots> displaySlots = [];
      
      if (controller.selectedSlots.isNotEmpty) {
        // Get 3 consecutive slots based on the first selected slot
        displaySlots = controller.getThreeConsecutiveSlots(controller.selectedSlots.first);
      }
      
      // Fallback to default times if no selection or no consecutive slots found
      if (displaySlots.isEmpty) {
        displaySlots = [
          Slots(sId: 'default1', time: '08:00 AM', amount: 400),
          Slots(sId: 'default2', time: '09:00 AM', amount: 400),
          Slots(sId: 'default3', time: '10:00 AM', amount: 400),
        ];
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT TEXT
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courtName,
                  style:Get.textTheme.headlineMedium,
                ),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// TIME SLOTS
          Expanded(
            child: Row(
              children: List.generate(displaySlots.length, (index) {
                final slot = displaySlots[index];

                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        right: index == displaySlots.length - 1 ? 0 : 10),
                    child: _buildCourtSlotTile(slot, courtName, selectedIndex, index),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }


  /// Date Picker - Fixed spacing and toggle functionality
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Date",
              style: Get.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: ()=>showChangeLocationBottomSheet(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4,horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on,color: AppColors.primaryColor,size: 17,),
                    Text('Change Location' ,style: Get.textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor
                    ),)
                  ],
                ),
              ),
            ),
          ],
        ),

        /// Date picker wrapped separately with Obx
        Obx(() => Transform.translate(
          offset: Offset(0, -13),
          child: Row(
            children: [
              Transform.translate(
                offset: Offset(0, 0),
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
                  // Display month vertically (O C T) - now uses focusedMonth
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
                      headerBuilder: (_, context, date) => const SizedBox.shrink(),
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
                      if (currentDate.isBefore(today)) {
                        return const SizedBox.shrink();
                      }
                      final dayName = DateFormat('E').format(date);
                      final dateString =
                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                      return GestureDetector(
                        onTap: onTap,
                        child: Obx(() {
                          final dateSelections =
                              controller.getSelectionsByDate()[dateString] ?? [];

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
                              height: 55,
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
                                      //     ? AppColors.primaryColor.withValues(alpha: 0.1)
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
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : dateSelections.isNotEmpty
                                                ? AppColors.primaryColor
                                                : AppColors.textColor,
                                          ),
                                        ),
                                        Transform.translate(offset: Offset(0, -2),
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
                                      top: -2,
                                      right: -6,
                                      child: Container(
                                        height: 16,
                                        width: 16,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? AppColors.secondaryColor
                                              : AppColors.primaryColor,
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
                            ),
                          );
                        }),
                      );
                    },
                    onDateChange: (date) {
                      controller.selectedDate.value = date;
                      controller.focusedMonth.value = DateTime(date.year, date.month, 1);
                      controller.clearAllSelections();
                      controller.isLoadingCourts.value = true;
                      controller.refreshSlots(
                        showUnavailable: controller.showUnavailableSlots.value,
                      );
                      controller.slots.refresh();
                    },
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Obx(() {
      final totalSelections = controller.getTotalSelectionsCount();
      final hasSelections = totalSelections > 0;
      // final isSheetOpen = controller.isBottomSheetOpen.value;

      final double collapsedHeight = Get.height * .11;
      final double expandedHeight = Get.height * .13;

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
          // behavior: HitTestBehavior.opaque,
          // onVerticalDragEnd: hasSelections
          //     ? (details) {
          //   if ((details.primaryVelocity ?? 0) < -300) {
          //     _openSelectedSlotsBottomSheet(context);
          //   }
          // }
          //     : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                width: Get.width*0.9,
                child: Text("Next",style:  Get.textTheme.headlineMedium!.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),).paddingOnly(right: 40),
                onTap: () {
                  if (!hasSelections) {
                    SnackBarUtils.showInfoSnackBar("Please select at least one slot to continue.");
                    return;
                  }
                  // SnackBarUtils.showInfoSnackBar("coming soon");
                  SnackBarUtils.showInfoSnackBar("Note\nYou’ll be refunded for all players except your own share once players are added.",duration: Duration(seconds: 4));
                  controller.onNext();
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAllCourtsWithSlots() {
    return Obx(() {
      if (controller.isLoadingCourts.value) {
        return CourtSlotsShimmer();
      }

      final slotsData = controller.slots.value;

      if (slotsData == null || slotsData.data == null || slotsData.data!.isEmpty) {
        return const Center(child: Text("No slots available"));
      }

      final court = slotsData.data!.first;
      final slotTimes = court.slots ?? [];

      return _buildSlotsGrid(slotTimes, court.sId ?? '');
    });
  }
  Widget _buildSlotsGrid(List<dynamic> slotTimes, String courtId) {
    if (slotTimes.isEmpty) {
      return const Center(
        child: Text(
          "No time slots available",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            fontSize: 12,
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
        childAspectRatio: 2.2,
      ),
      itemCount: slotTimes.length,
      itemBuilder: (context, index) {
        final slot = slotTimes[index];
        return Obx(() => _buildSlotTile(slot, courtId));
      },
    );
  }

  /// Build slot tile for court rows with different selection states
  Widget _buildCourtSlotTile(dynamic slot, String courtName, int courtIndex, int slotIndex) {
    // Check actual selection state from controller
    final courtId = 'court${courtIndex + 1}';
    final isSelected = controller.isSlotSelected(slot, courtId);
    
    // Check if this time slot is already selected in other courts
    final isTimeSlotTakenInOtherCourts = controller.isTimeSlotSelectedInOtherCourts(slot.time, courtId);
    final isDisabled = isTimeSlotTakenInOtherCourts && !isSelected;

    const blueColor = Color(0xff053CFF);
    const radius = 5.0;

    return GestureDetector(
      onTap: isDisabled ? null : () {
        controller.toggleCourtRowSlotSelection(
          slot,
          courtId: courtId,
          courtName: courtName,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: isDisabled ? Colors.grey.shade100 : Colors.white,
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
                : null,
            border: Border.all(
              color: isDisabled ? Colors.grey.shade300 : Colors.grey.shade300,
            ),
          ),
          child: Stack(
            children: [
              /// LEFT BLUE STRIP (ONLY WHEN NOT SELECTED AND NOT DISABLED)
              if (!isSelected && !isDisabled)
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

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, 2),
                      child: Text(
                        slot.time ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDisabled 
                              ? Colors.grey.shade500
                              : isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -1),
                      child: Text(
                        "₹ ${slot.amount??0}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: isDisabled 
                              ? Colors.grey.shade500
                              : isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSlotTile(dynamic slot, String courtId) {
    final isSelected = controller.isSlotSelected(slot, courtId);
    final isDisabled = controller.isSlotDisabled(slot, courtId);

    final isUnavailable = controller.isPastAndUnavailable(slot) ||
        (slot.status?.toLowerCase() == 'booked') ||
        (slot.availabilityStatus?.toLowerCase() == 'maintenance') ||
        (slot.availabilityStatus?.toLowerCase() == 'weather conditions') ||
        (slot.availabilityStatus?.toLowerCase() == 'staff unavailability');

    const blueColor = Color(0xff053CFF);
    const radius = 5.0;

    return GestureDetector(
      onTap: (isUnavailable || isDisabled)
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
            color: (isUnavailable || isDisabled) ? Colors.grey.shade100 : Colors.white,
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
                : null,
            border: Border.all(
              color: (isUnavailable || isDisabled)
                  ? Colors.grey.shade300
                  : Colors.grey.shade300,
            ),
          ),
          child: Stack(
            children: [
              /// LEFT BLUE STRIP (ONLY WHEN AVAILABLE AND NOT DISABLED)
              if (!isUnavailable && !isDisabled && !isSelected)
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

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, 2),
                      child: Text(
                        slot.time ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: (isUnavailable || isDisabled)
                              ? Colors.grey.shade500
                              : isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -1),
                      child: Text(
                        "₹ ${slot.amount??0}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: (isUnavailable || isDisabled)
                              ? Colors.grey.shade500
                              : isSelected
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showChangeLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangeLocationBottomSheet(),
    );
  }

}
class ChangeLocationBottomSheet extends StatelessWidget {
  const ChangeLocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cities = [
      'Panchkula, Haryana',
      'Jaipur, Rajasthan',
      'Mumbai, Maharashtra',
      'Mohali, Punjab',
      'Shimla, Himachal',
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
        children: [
          // const SizedBox(height: 12),
          //
          // /// DRAG HANDLE
          // Container(
          //   width: 40,
          //   height: 4,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade400,
          //     borderRadius: BorderRadius.circular(2),
          //   ),
          // ),

          const SizedBox(height: 5),

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Change Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // balance back icon
              ],
            ),
          ),
          fadeDivider(),

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: Get.textTheme.headlineSmall!.copyWith(color: AppColors.labelBlackColor),
              decoration: InputDecoration(
                hintText: 'Search by city name',
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.textFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// CITY LIST
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                return Text(
                  cities[index],
                  style: Get.textTheme.headlineSmall!.copyWith(color: AppColors.labelBlackColor)
                ).paddingOnly(left: 12);
              },
            ),
          ),

          /// CHANGE BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2C3EBB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
        ),
      ),
    );
  }
}

