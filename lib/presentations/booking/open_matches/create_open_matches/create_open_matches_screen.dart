import 'dart:developer';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/court_slots_shimmer.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/upword_arrow_animation.dart';
import '../../../../data/request_models/home_models/get_available_court.dart';
import '../../../../handler/text_formatter.dart';
import 'create_open_matches_controller.dart';

class CreateOpenMatchesScreen extends StatelessWidget {
  CreateOpenMatchesScreen({super.key});

  final CreateOpenMatchesController controller = Get.put(CreateOpenMatchesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: _bottomBar(context),

      appBar: primaryAppBar(title: Text("Create match"), centerTitle: true, context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildDatePicker(),
              Transform.translate(
                  offset: Offset(0, -20),
                  child: _buildTimeOfDayTabs()),
              Transform.translate(
                  offset: Offset(0, -13),
                  child: _buildAllCourtsWithSlots()),
            ],
          ),
        ),
      ),
    );
  }

  /// Date Picker - Fixed spacing and toggle functionality
  Widget _buildDatePicker() {
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

            /// Toggle wrapped with Obx
            Obx(() => InkWell(
              onTap: () async {
                controller.showUnavailableSlots.value =
                !controller.showUnavailableSlots.value;

                controller.isLoadingCourts.value = true;
                await controller.getAvailableCourtsById(
                  controller.argument.id!,
                  showUnavailable: controller.showUnavailableSlots.value,
                );
                controller.slots.refresh();
                controller.isLoadingCourts.value = false;
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.showUnavailableSlots.value
                          ? "Show Available"
                          : "Show Unavailable",
                      style: Get.textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 35,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: controller.showUnavailableSlots.value
                            ? AppColors.secondaryColor
                            : AppColors.blackColor.withValues(alpha: 0.3),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: controller.showUnavailableSlots.value
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
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
                  width: 30,
                  height: Get.height * 0.069,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textFieldColor,
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
                          fontSize: 13,
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
                              height: 60,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 60,
                                    width: Get.width * 0.11,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSelected
                                          ? Colors.black
                                          : dateSelections.isNotEmpty
                                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                                          : AppColors.playerCardBackgroundColor,
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
                                            fontSize: 20,
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
                    onDateChange: (date) async {
                      controller.selectedDate.value = date;
                      controller.focusedMonth.value = DateTime(date.year, date.month, 1);
                      controller.clearAllSelections();
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
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
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

  Future<void> _openSelectedSlotsBottomSheet(BuildContext context) async {
    if (Get.isSnackbarOpen) return;
    if (controller.getTotalSelectionsCount() == 0) return;
    if (controller.isBottomSheetOpen.value) return;

    controller.isBottomSheetOpen.value = true;

    try {
      await showModalBottomSheet(
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
                                              fontSize: 14
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$totalSelections slot${totalSelections > 1 ? 's' : ''} selected',
                                          style: Get.textTheme.bodySmall?.copyWith(
                                            color: AppColors.darkGrey,
                                              fontSize: 12
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ $totalAmount',
                                      style: Get.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                          fontSize: 16
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            //   child: Text(
                            //     'Date-wise Breakdown',
                            //     style: Get.textTheme.bodyMedium?.copyWith(
                            //       fontWeight: FontWeight.w600,
                            //       color: AppColors.labelBlackColor,
                            //         fontSize: 13
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 5,),
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
                                    children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '$formattedDate ($dayName)',
                                                  style: Get.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                      fontSize: 14
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryColor,
                                              shape: BoxShape.circle
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
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 14),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
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
                                                  (courtSelections.first['courtName'] as String?)?.isNotEmpty == true
                                                      ? courtSelections.first['courtName'] as String
                                                      : 'Court';

                                              return Container(
                                                margin: const EdgeInsets.only(bottom: 0),
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: AppColors.playerCardBackgroundColor,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.sports_tennis,
                                                          size: 14,
                                                          color: AppColors.primaryColor,
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Expanded(
                                                          child: Text(
                                                            courtName,
                                                            style: Get.textTheme.bodyMedium?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          courtSelections.length == 1
                                                              ? '1 slot'
                                                              : '${courtSelections.length} slots',
                                                          style: Get.textTheme.bodySmall?.copyWith(
                                                            color: AppColors.darkGrey,
                                                            fontSize: 11
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Wrap(
                                                      spacing: 6,
                                                      runSpacing: 6,
                                                      children: courtSelections.map((selection) {
                                                        final slot = selection['slot'] as Slots;
                                                        final formattedTime = formatTimeSlot(slot.time ?? '');
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
    } finally {
      controller.isBottomSheetOpen.value = false;
    }
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
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: hasSelections
              ? (details) {
                  if ((details.primaryVelocity ?? 0) < -300) {
                    _openSelectedSlotsBottomSheet(context);
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
                      onTap: ()=>_openSelectedSlotsBottomSheet(context),
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
                            "₹ ${controller.totalAmount.value}",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ).paddingOnly(left: 18,right: 18,),
                    ),
                    Positioned(
                      top: -24,
                      child: InkWell(
                        onTap: () {
                          if (controller.isBottomSheetOpen.value) {
                            Get.back();
                          } else {
                            _openSelectedSlotsBottomSheet(context);
                          }
                        },
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
              SizedBox(
                width: Get.width * 0.9,
                child: PrimaryButton(
                  onTap: () {
                    if (!hasSelections) {
                      SnackBarUtils.showInfoSnackBar("Please select at least one slot to continue.");
                      return;
                    }
                    controller.onNext();
                  },
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
// In create_open_matches_screen.dart
// Replace the _buildAllCourtsWithSlots method with this:

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
            // Display all courts in a vertical list
            ...courts.map((court) => _buildCourtSection(court)),

            const SizedBox(height: 26),
          ],
        ),
      );
    });
  }

// Also update the controller to remove PageController:
// In create_open_matches_controller.dart

// REMOVE these lines:
// PageController pageController = PageController();
// RxInt currentPage = 0.obs;

// In onClose() method, REMOVE:
// pageController.dispose();
  /// Build all courts with their slots
  // Widget _buildAllCourtsWithSlots() {
  //   return Obx(() {
  //     if (controller.isLoadingCourts.value) {
  //       return CourtSlotsShimmer();
  //     }
  //
  //     final slotsData = controller.slots.value;
  //
  //     if (slotsData == null || slotsData.data == null || slotsData.data!.isEmpty) {
  //       return const Center(child: Text("No courts available"));
  //     }
  //
  //     final courts = slotsData.data!;
  //     final totalPages = (courts.length / 2).ceil();
  //
  //     return Column(
  //       children: [
  //         // PageView for courts
  //         SizedBox(
  //           height: Get.height * 0.46,
  //           child: PageView.builder(
  //             controller: controller.pageController,
  //             onPageChanged: (index) {
  //               controller.currentPage.value = index;
  //             },
  //             itemCount: totalPages,
  //             itemBuilder: (context, pageIndex) {
  //               final start = pageIndex * 2;
  //               final end = (start + 2 > courts.length) ? courts.length : start + 2;
  //               final courtsSlice = courts.sublist(start, end);
  //
  //               return Column(
  //                 children: courtsSlice.map((court) => _buildCourtSection(court)).toList(),
  //               );
  //             },
  //           ),
  //         ),
  //
  //         const SizedBox(height: 6),
  //
  //         /// Swipe hint with arrow animation
  //         Obx(() {
  //           final currentPage = controller.currentPage.value;
  //
  //           if (totalPages <= 1) return const SizedBox.shrink();
  //
  //           if (currentPage == 0) {
  //             // First page → swipe left
  //             return _buildSwipeHint("Swipe Left for more slots ", Icons.arrow_right_alt);
  //           } else if (currentPage == totalPages - 1) {
  //             // Last page → swipe right
  //             return _buildSwipeHint("Swipe Right", Icons.arrow_left);
  //           }
  //           return const SizedBox.shrink();
  //         }),
  //
  //         const SizedBox(height: 6),
  //
  //         /// Dot indicator placed right below courts
  //         _buildDotIndicator(totalPages),
  //         const SizedBox(height: 26),
  //
  //       ],
  //     );
  //   });
  // }

  /// Helper method to safely extract court type as String
  String _getCourtType(dynamic courtData) {
    try {
      var courtType = courtData.registerClubId?.courtType ??
          courtData.register_club_id?.courtType ??
          'Standard court';

      // Handle case where courtType is a list
      if (courtType is List) {
        return courtType.isNotEmpty ? courtType.first.toString() : 'Standard court';
      }

      // Handle null case
      if (courtType == null) {
        return 'Standard court';
      }

      // Return as string
      return courtType.toString();
    } catch (e) {
      log("Error extracting court type: $e");
      return 'Standard court';
    }
  }

  /// Build individual court section with its slots
  Widget _buildCourtSection(dynamic courtData) {
    final courtName = courtData.courtName ?? 'Unknown Court';
    final slotTimes = courtData.slots ?? [];

    // Use the helper method to safely get court type
    final featureText = _getCourtType(courtData);

    log("Building court section for: $courtName with ${slotTimes.length} slots");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.all(12),
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
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Slots Grid
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
        child: Column(
          children: [
            // Icon(
            //   Icons.schedule,
            //   size: 20,
            //   color: Colors.grey,
            // ),
            // SizedBox(height: 2),
            Text(
              "No time slots available",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // Controller already filtered available/unavailable lists.
    // Use provided list directly to avoid double-filtering.
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}