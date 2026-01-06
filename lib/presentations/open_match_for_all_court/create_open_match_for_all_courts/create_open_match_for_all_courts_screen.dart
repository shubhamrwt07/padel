import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/custom_button.dart';
import 'package:padel_mobile/configs/components/fade_divider.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/data/request_models/home_models/get_available_court.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/court_slots_shimmer.dart';
import 'package:padel_mobile/presentations/booking/book_session/widgets/upword_arrow_animation.dart';
import 'package:padel_mobile/data/response_models/get_courts_by_duration_model.dart' as GetCourtsByDurationModel;
import 'create_open_match_for_all_courts_controller.dart';

class CreateOpenMatchForAllCourtsScreen extends StatelessWidget {
  final CreateOpenMatchForAllCourtsController controller = Get.put(CreateOpenMatchForAllCourtsController());
  final RxBool isExpanded = false.obs;
  final RxBool isProcessing = false.obs;

  CreateOpenMatchForAllCourtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: _buildPaymentPanel(),
      appBar: primaryAppBar(
        title: Text("Create Open Match"),
        centerTitle: true,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildDatePicker(context),
              Transform.translate(offset: Offset(0, -30), child: fadeDivider()),
              Transform.translate(
                offset: Offset(0, -20),
                child: _durationSection(),
              ),
              Transform.translate(
                offset: Offset(0, -10),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Available Slots', style: Get.textTheme.labelLarge),
                    if (controller.selectedSearchSlotId.value != null)
                      GestureDetector(
                        onTap: () => controller.toggleSlotsCollapse(),
                        child: AnimatedRotation(
                          turns: controller.isSlotsCollapsed.value ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              size: 22,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
              ),
              _buildAllCourtsWithSlots(),
              const SizedBox(height: 10),
              availableCourts(),
              const SizedBox(height: 20),
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
        borderRadius: BorderRadius.circular(5),
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
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
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
                        color: isSelected ? Colors.white : Colors.grey.shade700,
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
    return Obx(() {
      // Check if no slots are selected from main grid
      if (controller.multiDateSelections.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Courts', style: Get.textTheme.labelLarge),
            const SizedBox(height: 16),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Please select a time slot from above to see available courts.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }

      // Show loading state
      if (controller.isLoadingCourtsByDuration.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Courts', style: Get.textTheme.labelLarge),
            const SizedBox(height: 100),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: LoadingWidget(color: AppColors.primaryColor,),
              ),
            ),
          ],
        );
      }

      final courtsByDuration = controller.courtsByDuration.value;
      
      // Show empty state if no data
      if (courtsByDuration == null || 
          courtsByDuration.data == null || 
          courtsByDuration.data!.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Courts', style: Get.textTheme.labelLarge),
            const SizedBox(height: 16),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No courts available for the selected time slot.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      }

      final clubs = courtsByDuration.data!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Courts', style: Get.textTheme.labelLarge),
          ...List.generate(clubs.length, (index) {
            final club = clubs[index];
            
            // Use totalAmount from fetchCourtsByDuration API
            int minPrice = 0;
            if (club.courts != null && club.courts!.isNotEmpty) {
              final allTotalAmounts = club.courts!
                  .expand((court) => court.availabilityByTime ?? [])
                  .where((availability) => availability.totalAmount != null && availability.totalAmount! > 0)
                  .map((availability) => availability.totalAmount!)
                  .toList();
              if (allTotalAmounts.isNotEmpty) {
                minPrice = allTotalAmounts.reduce((a, b) => a < b ? a : b);
              }
            }

            return Obx(() {
              final isExpanded = controller.expandedIndex.value == index;

              return Column(
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          /// HEADER
                          GestureDetector(
                            onTap: () => controller.toggle(index),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: (club.courtImage != null &&
                                            club.courtImage!.isNotEmpty)
                                        ? CachedNetworkImage(
                                            imageUrl: club.courtImage!.first,
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
                                          )
                                        : Container(
                                            width: 44,
                                            height: 44,
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.sports_tennis),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          club.clubName ?? 'Club',
                                          style: Get.textTheme.headlineMedium!
                                              .copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          club.city ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // if (minPrice > 0)
                                    Text(
                                      '₹ $minPrice',
                                      style: Get.textTheme.titleLarge!.copyWith(
                                        fontSize: 23,
                                      ),
                                    ),
                                  const SizedBox(width: 6),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 250),
                                    child: const Icon(Icons.keyboard_arrow_down),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// EXPANDED CONTENT
                          if (isExpanded && club.courts != null && club.courts!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            ...List.generate(club.courts!.length, (courtIndex) {
                              final court = club.courts![courtIndex];
                              final courtType = (court.courtType != null && court.courtType!.isNotEmpty)
                                  ? court.courtType!.join(', ')
                                  : 'Court';

                              // Get unique slots from availabilityByTime (remove duplicates by slot ID)
                              final availableSlots = court.availabilityByTime
                                  ?.expand((availability) => availability.slots ?? [])
                                  .cast<GetCourtsByDurationModel.CourtDurationSlots>()
                                  .fold<Map<String, GetCourtsByDurationModel.CourtDurationSlots>>({}, (map, slot) {
                                    if (slot.sId != null) {
                                      map[slot.sId!] = slot;
                                    }
                                    return map;
                                  })
                                  .values
                                  .toList();
                              
                              // Update slot prices if fetchAllSlotPrices has been called
                              if (availableSlots != null && controller.allSlotPricesResponse.value != null) {
                                final currentDate = controller.selectedDate.value ?? DateTime.now();
                                final dayName = controller.getWeekday(currentDate.weekday);
                                final selectedDurationMinutes = int.tryParse(controller.selectedDuration.value.replaceAll(' min', '')) ?? 60;
                                
                                for (var slot in availableSlots) {
                                  if (slot.time != null) {
                                    int? updatedPrice;
                                    if (selectedDurationMinutes == 90) {
                                      // For 90min display: show only 60min price
                                      updatedPrice = controller.findPriceForSlot(slot.time!, dayName, 60);
                                    } else {
                                      final duration = selectedDurationMinutes == 120 ? 60 : selectedDurationMinutes;
                                      updatedPrice = controller.findPriceForSlot(slot.time!, dayName, duration);
                                    }
                                    
                                    if (updatedPrice != null) {
                                      slot.amount = updatedPrice;
                                    }
                                  }
                                }
                              }

                              // Get totalAmount from availabilityByTime
                              int? totalAmount;
                              if (court.availabilityByTime != null && court.availabilityByTime!.isNotEmpty) {
                                totalAmount = court.availabilityByTime!.first.totalAmount;
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: courtIndex < club.courts!.length - 1 ? 16 : 0,
                                ),
                                child: _courtRow(
                                  courtName: court.courtName ?? 'Court ${courtIndex + 1}',
                                  type: courtType,
                                  selectedIndex: index * 100 + courtIndex, // Unique index
                                  availableSlots: availableSlots,
                                  courtId: court.courtId ?? '',
                                  totalAmount: totalAmount,
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ),
                  fadeDivider()
                ],
              );
            });
          }),
        ],
      );
    });
  }

  Widget _courtRow({
    required String courtName,
    required String type,
    required int selectedIndex,
    List<GetCourtsByDurationModel.CourtDurationSlots>? availableSlots,
    String? courtId,
    int? totalAmount,
  }) {
    return Obx(() {
      // Only show slots if available from API
      final displaySlots = availableSlots?.isNotEmpty == true
          ? availableSlots!.take(3).map((slot) => Slots(
              sId: slot.sId ?? 'slot_${selectedIndex}_${slot.time}',
              time: slot.time ?? '',
              amount: slot.amount ?? 0,
            )).toList()
          : <Slots>[];

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT TEXT
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(courtName, style: Get.textTheme.headlineMedium),
                Text(
                  type.split(',').first,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 15,),

          /// TIME SLOTS - Only show if slots available
          if (displaySlots.isNotEmpty)
            Expanded(
              child: Row(
                children: List.generate(displaySlots.length, (index) {
                  final slot = displaySlots[index];

                  return Container(
                    width: 83,
                    margin: EdgeInsets.only(
                      right: index == displaySlots.length - 1 ? 0 : 10,
                    ),
                    child: _buildCourtSlotTile(
                      slot,
                      courtName,
                      selectedIndex,
                      index,
                      courtId: courtId ?? 'court$selectedIndex',
                      availableSlots: displaySlots,
                      totalAmount: totalAmount,
                    ),
                  );
                }),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'No slots available',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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
              onTap: () => showChangeLocationBottomSheet(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                      size: 17,
                    ),
                    Text(
                      'Change Location',
                      style: Get.textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        /// Date picker wrapped separately with Obx
        Obx(
          () => Transform.translate(
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
                        final itemsScrolled = (scrollOffset / itemExtent)
                            .round();
                        final estimatedDate = DateTime.now().add(
                          Duration(days: itemsScrolled),
                        );

                        // Update focusedMonth based on scroll position
                        final newMonth = DateTime(
                          estimatedDate.year,
                          estimatedDate.month,
                          1,
                        );
                        if (controller.focusedMonth.value.month !=
                                newMonth.month ||
                            controller.focusedMonth.value.year !=
                                newMonth.year) {
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
                      itemExtent: 43,
                      itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final currentDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                        if (currentDate.isBefore(today)) {
                          return const SizedBox.shrink();
                        }
                        final dayName = DateFormat('E').format(date);
                        final dateString =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                        return GestureDetector(
                          onTap: onTap,
                          child: Obx(() {
                            final realCourtSelections = 
                                controller.realCourtSelections.entries
                                    .where((entry) => entry.value['date'] == dateString)
                                    .map((entry) => entry.value)
                                    .toList();
                            final totalSelections = realCourtSelections.length;

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
                                        gradient: isSelected
                                            ? LinearGradient(
                                                colors: [
                                                  Color(0xff1F41BB),
                                                  Color(0xff0E1E55),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )
                                            : null,
                                        color: isSelected ? null : Colors.white,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : totalSelections > 0
                                              ? AppColors.primaryColor
                                              : AppColors.blackColor.withAlpha(
                                                  20,
                                                ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${date.day}",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : totalSelections > 0
                                                      ? AppColors.primaryColor
                                                      : AppColors.textColor,
                                                ),
                                          ),
                                          Transform.translate(
                                            offset: Offset(0, -2),
                                            child: Text(
                                              dayName,
                                              style: Get.textTheme.bodySmall!
                                                  .copyWith(
                                                    fontSize: 11,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : totalSelections > 0
                                                        ? AppColors.primaryColor
                                                        : Colors.black,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (totalSelections > 0)
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
                                            "$totalSelections",
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
                        controller.focusedMonth.value = DateTime(
                          date.year,
                          date.month,
                          1,
                        );
                        controller.clearAllSelections();
                        controller.isLoadingCourts.value = true;
                        controller.refreshSlots(
                          showUnavailable:
                              controller.showUnavailableSlots.value,
                        );
                        controller.slots.refresh();
                        // Refresh courts by duration if time slot is selected
                        controller.fetchCourtsIfReady();
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

  Widget _buildAllCourtsWithSlots() {
    return Obx(() {
      if (controller.isLoadingCourts.value) {
        return CourtSlotsShimmer();
      }

      final slotsData = controller.slots.value;

      if (slotsData == null ||
          slotsData.data == null ||
          slotsData.data!.isEmpty) {
        return const Center(child: Text("No slots available"));
      }

      final court = slotsData.data!.first;
      var slotTimes = court.slots ?? [];
      
      // Filter to show only the row containing selected slot when collapsed
      if (controller.isSlotsCollapsed.value && controller.selectedSearchSlotId.value != null) {
        final selectedSlotId = controller.selectedSearchSlotId.value!;
        final selectedIndex = slotTimes.indexWhere((slot) => slot.sId == selectedSlotId);
        
        if (selectedIndex != -1) {
          // Grid has 4 columns per row
          const columnsPerRow = 4;
          final rowIndex = selectedIndex ~/ columnsPerRow;
          final startIndex = rowIndex * columnsPerRow;
          final endIndex = (startIndex + columnsPerRow).clamp(0, slotTimes.length);
          
          // Get all slots in the same row
          slotTimes = slotTimes.sublist(startIndex, endIndex);
        }
      }

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
        childAspectRatio: 2.5,
      ),
      itemCount: slotTimes.length,
      itemBuilder: (context, index) {
        final slot = slotTimes[index];
        return Obx(() => _buildSlotTile(slot, courtId));
      },
    );
  }

  /// Build slot tile for court rows with different selection states
  Widget _buildCourtSlotTile(
    dynamic slot,
    String courtName,
    int courtIndex,
    int slotIndex, {
    String? courtId,
    List<dynamic>? availableSlots,
    int? totalAmount,
  }) {
    // Check actual selection state from controller (for real court selections)
    final resolvedCourtId = courtId ?? 'court${courtIndex + 1}';
    final isSelected = controller.isRealCourtSlotSelected(slot, resolvedCourtId);
    final selectedDuration = controller.selectedDuration.value;
    final isHalfSlot = selectedDuration == '30 min';
    final is90MinSlot = selectedDuration == '90 min';

    // Check if this is the second slot in 90min mode
    final isSecondSlotIn90Min = is90MinSlot && !isSelected && 
        controller.isSecondSlotIn90MinForRealCourt(slot, resolvedCourtId, availableSlots);

    // Check if this is the second slot in 120min mode
    final is120MinSlot = selectedDuration == '120 min';
    final isSecondSlotIn120Min = is120MinSlot && !isSelected && 
        controller.isSecondSlotIn120MinForRealCourt(slot, resolvedCourtId, availableSlots);

    const blueColor = Color(0xff053CFF);
    const radius = 5.0;

    return Builder(
      builder: (BuildContext slotContext) {
        return GestureDetector(
          onTapDown: (details) {
            if (selectedDuration == '30 min') {
              final RenderBox box = slotContext.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final isLeftHalf = localPosition.dx < box.size.width / 2;

              controller.toggleCourtRowSlotSelection(
                slot,
                courtId: resolvedCourtId,
                courtName: courtName,
                isLeftHalf: isLeftHalf,
              );
            } else if (selectedDuration == '90 min' && isSecondSlotIn90Min) {
              // Special handling for 90min second slot
              final RenderBox box = slotContext.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final isLeftHalf = localPosition.dx < box.size.width / 2;
              
              if (isLeftHalf) {
                // Clicked left half of second slot - select as 90min
                controller.toggleCourtRowSlotSelection(
                  slot,
                  courtId: resolvedCourtId,
                  courtName: courtName,
                );
              }
            } else {
              controller.toggleCourtRowSlotSelection(
                slot,
                courtId: resolvedCourtId,
                courtName: courtName,
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: AnimatedContainer(
              height: 34,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  /// FULL GRADIENT FOR BOTH HALVES SELECTED (30MIN)
                  if (isHalfSlot && controller.isBothHalvesSelectedInRealCourt(slot, resolvedCourtId))
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// LEFT HALF GRADIENT (30MIN)
                  if (isHalfSlot && controller.isLeftHalfSelectedInRealCourt(slot, resolvedCourtId) && !controller.isBothHalvesSelectedInRealCourt(slot, resolvedCourtId))
                    Positioned.fill(
                      left: 0,
                      right: 41.5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// LEFT HALF GRADIENT (90MIN SECOND SLOT)
                  if (is90MinSlot && isSecondSlotIn90Min)
                    Positioned.fill(
                      left: 0,
                      right: 41.5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// RIGHT HALF GRADIENT (30MIN)
                  if (isHalfSlot && controller.isRightHalfSelectedInRealCourt(slot, resolvedCourtId) && !controller.isBothHalvesSelectedInRealCourt(slot, resolvedCourtId))
                    Positioned.fill(
                      left: 41.5,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(radius),
                            bottomRight: Radius.circular(radius),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// FULL GRADIENT FOR SELECTED SLOT (60MIN, 90MIN, 120MIN)
                  if (!isHalfSlot && isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// FULL GRADIENT FOR 120MIN SECOND SLOT
                  if (is120MinSlot && isSecondSlotIn120Min)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// LEFT BLUE STRIP (ONLY WHEN NOT SELECTED)
                  if (!isSelected && !isSecondSlotIn90Min && !isSecondSlotIn120Min)
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

                  /// DIVIDER LINE FOR 30MIN SLOTS
                  if (isHalfSlot && !controller.isLeftHalfSelectedInRealCourt(slot, resolvedCourtId) && !controller.isRightHalfSelectedInRealCourt(slot, resolvedCourtId))
                    Positioned(
                      left: 41.5,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        width: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),

                  /// DIVIDER LINE FOR 90MIN SECOND SLOT
                  if (is90MinSlot && isSecondSlotIn90Min)
                    Positioned(
                      left: 41.5,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        width: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),

                  /// TIME AND AMOUNT TEXT WITH SHADER EFFECTS
                  
                  /// TEXT FOR 30MIN LEFT HALF SELECTED
                  if (isHalfSlot && controller.isLeftHalfSelectedInRealCourt(slot, resolvedCourtId) && !controller.isBothHalvesSelectedInRealCourt(slot, resolvedCourtId))
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.white, Colors.white, Colors.black87, Colors.black87],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot.time ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            if (slot.amount != null && slot.amount! > 0)
                              Text(
                                '₹${slot.amount}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  /// TEXT FOR 30MIN RIGHT HALF SELECTED
                  if (isHalfSlot && controller.isRightHalfSelectedInRealCourt(slot, resolvedCourtId) && !controller.isBothHalvesSelectedInRealCourt(slot, resolvedCourtId))
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.black87, Colors.black87, Colors.white, Colors.white],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot.time ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            if (slot.amount != null && slot.amount! > 0)
                              Text(
                                '₹${slot.amount}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  /// TEXT FOR 90MIN SECOND SLOT
                  if (is90MinSlot && isSecondSlotIn90Min)
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.white, Colors.white, Colors.black87, Colors.black87],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot.time ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            if (slot.amount != null && slot.amount! > 0)
                              Text(
                                '₹${slot.amount}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  /// TEXT FOR OTHER CASES
                  if (!isSecondSlotIn90Min && (!isHalfSlot || controller.isBothHalvesSelectedInRealCourt(slot, resolvedCourtId) || 
                      (!controller.isLeftHalfSelectedInRealCourt(slot, resolvedCourtId) && !controller.isRightHalfSelectedInRealCourt(slot, resolvedCourtId))))
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot.time ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: (isSelected ||
                                      (isHalfSlot && (controller.isLeftHalfSelectedInRealCourt(slot, resolvedCourtId) || controller.isRightHalfSelectedInRealCourt(slot, resolvedCourtId))) ||
                                      isSecondSlotIn90Min ||
                                      isSecondSlotIn120Min)
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          if (slot.amount != null && slot.amount! > 0)
                            Text(
                              '₹${slot.amount}',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: (isSelected ||
                                    (isHalfSlot && (controller.isLeftHalfSelectedInRealCourt(slot, resolvedCourtId) || controller.isRightHalfSelectedInRealCourt(slot, resolvedCourtId))) ||
                                    isSecondSlotIn90Min ||
                                    isSecondSlotIn120Min)
                                    ? Colors.white70
                                    : Colors.grey.shade600,
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
      },
    );
  }

  Widget _buildSlotTile(dynamic slot, String courtId) {
    final isSelected = controller.isSlotSelected(slot, courtId);
    final isPartOfGroup = _isPartOfSelectedGroup(slot, courtId);
    final selectedDuration = controller.selectedDuration.value;
    final isHalfSlot = selectedDuration == '30 min';
    final is90MinSlot = selectedDuration == '90 min';

    final isUnavailable = controller.isPastAndUnavailable(slot) ||
        (slot.status?.toLowerCase() == 'booked') ||
        (slot.availabilityStatus?.toLowerCase() == 'maintenance') ||
        (slot.availabilityStatus?.toLowerCase() == 'weather conditions') ||
        (slot.availabilityStatus?.toLowerCase() == 'staff unavailability');

    const blueColor = Color(0xff053CFF);
    const radius = 5.0;

    // For 90 min, check if this is the second slot (should show half selection)
    bool isSecondSlotIn90Min = false;
    if (is90MinSlot && !isSelected) {
      final courtData = controller.slots.value?.data?.first;
      if (courtData?.slots != null) {
        final allSlots = courtData!.slots!;
        final currentSlotIndex = allSlots.indexWhere((s) => s.sId == slot.sId);

        if (currentSlotIndex > 0) {
          final previousSlot = allSlots[currentSlotIndex - 1];
          final currentDate = controller.selectedDate.value ?? DateTime.now();
          final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
          final previousSlotKey = '${dateString}_${courtId}_${previousSlot.sId}';

          // Check if previous slot is selected - this makes current slot the second in 90min
          isSecondSlotIn90Min = controller.multiDateSelections.containsKey(previousSlotKey);
        }
      }
    }

    return Builder(
      builder: (BuildContext slotContext) {
        return GestureDetector(
          onTapDown: isUnavailable
              ? null
              : (details) {
            if (selectedDuration == '30 min') {
              final RenderBox box = slotContext.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final isLeftHalf = localPosition.dx < box.size.width / 2;

              controller.toggleSlotSelection(
                slot,
                courtId: courtId,
                courtName: '',
                isLeftHalf: isLeftHalf,
              );
            } else if (selectedDuration == '90 min' && isSecondSlotIn90Min) {
              // Special handling for 90min second slot
              final RenderBox box = slotContext.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final isRightHalf = localPosition.dx >= box.size.width / 2;
              
              if (isRightHalf) {
                // Clicked right half of second slot - select next 1.5 slots
                controller.toggleSlotSelection(
                  slot,
                  courtId: courtId,
                  courtName: '',
                );
              }
            } else {
              controller.toggleSlotSelection(
                slot,
                courtId: courtId,
                courtName: '',
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: isUnavailable ? Colors.grey.shade100 : Colors.white,
                border: Border.all(
                  color: isUnavailable
                      ? Colors.grey.shade300
                      : (isSelected || isPartOfGroup)
                      ? Colors.transparent
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  /// FULL GRADIENT FOR BOTH HALVES SELECTED (30MIN)
                  if (isHalfSlot && controller.isBothHalvesSelected(slot, courtId))
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// FULL GRADIENT FOR NON-30MIN AND NON-90MIN-SECOND-SLOT SELECTIONS
                  if ((isSelected || isPartOfGroup) && !isHalfSlot && !isSecondSlotIn90Min)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// LEFT HALF GRADIENT FOR 90MIN SECOND SLOT
                  if (isSecondSlotIn90Min)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// LEFT HALF GRADIENT FOR 30MIN LEFT SELECTION
                  if (isHalfSlot && controller.isLeftHalfSelected(slot, courtId) && !controller.isBothHalvesSelected(slot, courtId))
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// RIGHT HALF GRADIENT FOR 30MIN RIGHT SELECTION
                  if (isHalfSlot && controller.isRightHalfSelected(slot, courtId) && !controller.isBothHalvesSelected(slot, courtId))
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(radius),
                            bottomRight: Radius.circular(radius),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff1F41BB), Color(0xff0E1E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  /// VERTICAL DIVIDER FOR 30MIN SLOTS
                  if (isHalfSlot && !isUnavailable && !controller.isRightHalfSelected(slot, courtId) && !controller.isLeftHalfSelected(slot, courtId))
                    Positioned(
                      left: 40,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: AppColors.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),

                  /// LEFT BLUE STRIP (ONLY WHEN AVAILABLE AND NOT SELECTED)
                  if (!isUnavailable && !isSelected && !isPartOfGroup && (!isHalfSlot || (!controller.isLeftHalfSelected(slot, courtId) && !controller.isRightHalfSelected(slot, courtId))))
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

                  /// TEXT FOR 30MIN LEFT HALF SELECTED
                  if (isHalfSlot && controller.isLeftHalfSelected(slot, courtId) && !controller.isBothHalvesSelected(slot, courtId))
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.white, Colors.white, Colors.black87, Colors.black87],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          slot.time ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  /// TEXT FOR 30MIN RIGHT HALF SELECTED
                  if (isHalfSlot && controller.isRightHalfSelected(slot, courtId) && !controller.isBothHalvesSelected(slot, courtId))
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.black87, Colors.black87, Colors.white, Colors.white],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          slot.time ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  /// TEXT FOR 90MIN SECOND SLOT
                  if (isSecondSlotIn90Min)
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.white, Colors.white, Colors.black87, Colors.black87],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          slot.time ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  /// TEXT FOR OTHER CASES
                  if (!isSecondSlotIn90Min && (!isHalfSlot || controller.isBothHalvesSelected(slot, courtId) || 
                      (!controller.isLeftHalfSelected(slot, courtId) && !controller.isRightHalfSelected(slot, courtId))))
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            slot.time ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isUnavailable
                                  ? Colors.grey.shade500
                                  : (isSelected || isPartOfGroup || controller.isBothHalvesSelected(slot, courtId))
                                  ? Colors.white
                                  : Colors.black87,
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
      },
    );
  }

  /// Helper methods for slot selection logic
  bool _isPartOfSelectedGroup(dynamic slot, String courtId) {
    final selectedDuration = controller.selectedDuration.value;
    
    // For 30min and 60min, no grouping logic needed
    if (selectedDuration == '30 min' || selectedDuration == '60 min') return false;
    
    // For 90min and 120min, only check if this slot is the second slot in a selection
    if (selectedDuration == '90 min') {
      return false; // For 90min, we handle this separately with isSecondSlotIn90Min
    }
    
    // For 120min, no grouping logic needed - only show exactly 2 selected slots
    if (selectedDuration == '120 min') {
      return false;
    }
    
    return false;
  }

  Widget _buildPaymentPanel() {
    return Obx(() {
      final totalSelections = controller.getTotalSelectionsCount();
      final hasSelections = totalSelections > 0;

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
                SnackBarUtils.showInfoSnackBar("Note\nYou'll be refunded for all players except your own share once players are added.",duration: Duration(seconds: 4));
                controller.onNext();
              },
            )
          ],
        ),
      );
    });
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