import 'dart:developer';
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.03),
                child: _buildSlotHeader(context),
              ),
              // Show all courts with their slots
              _buildAllCourtsWithSlots(),
            ],
          ),
        ),
      ),
    );
  }

  /// 📅 Date Picker
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select date", style: Get.textTheme.labelLarge)
            .paddingOnly(bottom: 5),
        Obx(
              () => EasyDateTimeLinePicker.itemBuilder(
            headerOptions: HeaderOptions(
              headerBuilder: (_, context, date) => const SizedBox.shrink(),
            ),
            selectionMode: SelectionMode.alwaysFirst(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030, 3, 18),
            focusedDate: controller.selectedDate.value,
            itemExtent: 70,
            itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final currentDate = DateTime(date.year, date.month, date.day);

              if (currentDate.isBefore(today)) {
                return const SizedBox.shrink();
              }

              final dayName = DateFormat('E').format(date);
              final monthName = DateFormat('MMM').format(date);

              return GestureDetector(
                onTap: onTap,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    height: Get.height * 0.14,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 6),
                          child: Container(
                            height: Get.height * 0.09,
                            width: Get.width * 0.15,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.playerCardBackgroundColor,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.blackColor.withAlpha(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(dayName,
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                Text("${date.day}",
                                    style: Get.textTheme.titleMedium!.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textColor,
                                    )),
                                Text(monthName,
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 0,
                            right: -4,
                            child: Obx(() {
                              final selectedCount =
                                  controller.selectedSlotsWithCourtInfo.length;
                              return selectedCount == 0
                                  ? const SizedBox.shrink()
                                  : Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondaryColor,
                                ),
                                child: Text(
                                  "$selectedCount",
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            onDateChange: (date) async {
              controller.selectedSlots.clear();
              controller.selectedDate.value = date;
              log("Selected date: $date");

              // Force loading state
              controller.isLoadingCourts.value = true;

              await controller.getAvailableCourtsById(controller.argument.id!);

              // Ensure UI updates
              controller.slots.refresh();
            },
          ),
        ),
      ],
    );
  }

  /// Header toggle between available/unavailable
  Widget _buildSlotHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Available Courts & Slots',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Obx(() => Row(
          children: [
            Text(
              controller.showUnavailableSlots.value
                  ?"Show Available":"Show Unavailable",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: controller.showUnavailableSlots.value,
                onChanged: (value) =>
                controller.showUnavailableSlots.value = value,
                activeColor: Colors.white,
                activeTrackColor: AppColors.secondaryColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.blackColor,
              ),
            ),
          ],
        )),
      ],
    ).paddingOnly(top: 10, bottom: 5);
  }

  /// Build all courts with their slots
  Widget _buildAllCourtsWithSlots() {
    return Obx(() {
      if (controller.isLoadingCourts.value) {
        return _buildLoadingShimmer();
      }

      // More detailed debugging
      log("Building courts widget...");
      log("slots.value: ${controller.slots.value}");

      final slotsData = controller.slots.value;

      if (slotsData == null) {
        log("slotsData is null");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                "Loading courts...",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please wait while we fetch court information",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      final slots = slotsData.data;
      log("slots data: $slots");
      log("slots length: ${slots?.length}");

      if (slots == null || slots.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_busy,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                "No courts available",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "No courts are available for the selected date.\nTry selecting a different date.",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Add a retry button for debugging
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.getAvailableCourtsById(controller.argument.id!);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: slots.map((courtData) {
          return _buildCourtSection(courtData);
        }).toList(),
      );
    });
  }
  /// Build individual court section with its slots
  Widget _buildCourtSection(dynamic courtData) {
    final courtName = courtData.courtName ?? 'Unknown Court';
    final slotTimes = courtData.slots ?? [];

    // Use courtType from register_club_id instead of features
    final courtType = courtData.registerClubId?.courtType ??
        courtData.register_club_id?.courtType ??
        'Standard court';

    final featureText = courtType;

    // Debug logging for court data
    log("Building court section for: $courtName with ${slotTimes.length} slots");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Court Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
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
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    // Show selected slots count for this court
                    Obx(() {
                      final courtId = courtData.sId ?? '';
                      final selectedCount = controller.getSelectedSlotsCountForCourt(courtId);
                      return selectedCount > 0
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                const SizedBox(height: 0),
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
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
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
          padding: EdgeInsets.all(0),
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

    // Filter slots based on toggle
    final filteredSlots = slotTimes.where((slot) {
      final availability = slot.availabilityStatus?.toLowerCase();
      final isBlocked = availability == "maintenance" ||
          availability == "weather conditions" ||
          availability == "staff unavailability";
      final isUnavailable = controller.isPastAndUnavailable(slot);
      final isBooked = slot.status?.toLowerCase() == "booked";

      final isAvailableSlot = !(isUnavailable || isBlocked || isBooked);

      return controller.showUnavailableSlots.value
          ? !isAvailableSlot
          : isAvailableSlot;
    }).toList();

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

    return GridView.builder(padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: filteredSlots.length,
      itemBuilder: (context, index) {
        final slot = filteredSlots[index];
        // 👇 Wrap in Obx so it rebuilds when selectedSlots changes
        return Obx(() => _buildSlotTile(slot, courtId));
      },
    );

  }
  /// Build individual slot tile
  /// Build individual slot tile
  Widget _buildSlotTile(dynamic slot, String courtId) {
    final compositeKey = '${courtId}_${slot.sId ?? ''}';
    final isSelected = controller.selectedSlotsWithCourtInfo.containsKey(compositeKey);

    // Check if this slot is unavailable
    final isUnavailable = controller.isPastAndUnavailable(slot) ||
        (slot.status?.toLowerCase() == 'booked') ||
        (slot.availabilityStatus?.toLowerCase() == 'maintenance') ||
        (slot.availabilityStatus?.toLowerCase() == 'weather conditions') ||
        (slot.availabilityStatus?.toLowerCase() == 'staff unavailability');

    // 🎨 Colors
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
        controller.toggleSlotSelection(slot, courtId: courtId, courtName: '');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20), // pill shape
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          slot.time ?? '',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  /// Loading shimmer effect
  /// Loading shimmer effect
  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(2, (courtIndex) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Court Header shimmer
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Court type text shimmer
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 15),

                // Slots Grid shimmer
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: 8, // Show 2 rows of 4 slots
                    itemBuilder: (_, __) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // same as slot tile
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
  }

  /// Bottom bar with total & book button
  Widget _bottomButton() {
    return Container(
      height: Get.height * .09,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Obx(
              () => CustomButton(
            width: Get.width * 0.9,
            onTap: () {
              if (controller.selectedSlots.isEmpty) {
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
                Obx(() => RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "₹ ",
                        style: Get.textTheme.titleMedium!.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: "${controller.totalAmount}",
                        style: Get.textTheme.titleMedium!.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600)),
                  ]),
                ).paddingOnly(right: Get.width * 0.3, left: Get.width * 0.05)),
                Text("Book Now",
                    style: Get.textTheme.headlineMedium!
                        .copyWith(color: AppColors.whiteColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}