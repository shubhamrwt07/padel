import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
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
              _buildTimeSlots(),
              const SizedBox(height: 10),
              Text('Available Courts',
                  style: Theme.of(context).textTheme.labelLarge),
              buildCourtList(controller),
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
                                  controller.selectedSlots.length;
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
              await controller.getAvailableCourtsById(controller.argument.id!);
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
        Text('Available Slots',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Obx(() => Row(
          children: [
            Text(
              controller.showUnavailableSlots.value
                  ?"Show Available Slots":"Show Unavailable Slots",
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

  /// Time slots grid
  Widget _buildTimeSlots() {
    return Transform.translate(
      offset: Offset(0, -Get.height * 0.025),
      child: Obx(() {
        if (controller.isLoadingCourts.value) {
          return GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            children: List.generate(16, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          );
        }

        final slotTimes = controller.getSlotsForCourt(controller.courtId.value);

        if (slotTimes.isEmpty) {
          return const Center(
            child: Text(
              "No time slots available",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          );
        }

        // 🔑 Filtering like _buildSlotsForCourt
        final filteredSlots = slotTimes.where((slot) {
          final availability = slot.availabilityStatus?.toLowerCase();
          final isBlocked = availability == "maintenance" ||
              availability == "weather conditions" ||
              availability == "staff unavailability";
          final isUnavailable = controller.isPastAndUnavailable(slot);
          final isBooked = slot.status?.toLowerCase() == "booked";

          final isAvailableSlot = !(isUnavailable || isBlocked || isBooked);

          return controller.showUnavailableSlots.value
              ?!isAvailableSlot: isAvailableSlot;
        }).toList();

        if (filteredSlots.isEmpty) {
          return const Center(child: Text("No matching slots"));
        }

        final spacing = Get.width * 0.02;
        final tileWidth = (Get.width - spacing * 3 - 32) / 4;

        return SingleChildScrollView(
          child: Wrap(
            spacing: spacing,
            runSpacing: Get.height * 0.015,
            children: filteredSlots.map((slot) {
              final availability = slot.availabilityStatus?.toLowerCase();
              final isBlocked = availability == "maintenance" ||
                  availability == "weather conditions" ||
                  availability == "staff unavailability";
              final isUnavailable = controller.isPastAndUnavailable(slot);
              final isBooked = slot.status?.toLowerCase() == "booked";
              final isSelected = controller.selectedSlots.contains(slot);

              return GestureDetector(
                onTap: () {
                  if (isBooked) {
                    SnackBarUtils.showInfoSnackBar(
                      "Slot Unavailable\nThis slot is already booked.",
                    );
                  } else if (isUnavailable) {
                    SnackBarUtils.showInfoSnackBar(
                      "Slot Unavailable\nThis slot is not available.",
                    );
                  } else if (isBlocked) {
                    SnackBarUtils.showInfoSnackBar(
                      "Slot Blocked\nReason: ${slot.availabilityStatus?.capitalizeFirst ?? 'Blocked'}",
                    );
                  } else {
                    controller.toggleSlotSelection(slot);
                  }
                },
                child: SizedBox(
                  width: tileWidth,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.red.shade50
                          : isUnavailable
                          ? Colors.grey.shade100
                          : isBlocked
                          ? Colors.orange.shade50
                          : isSelected
                          ? Colors.black
                          : const Color(0xFFF5F6FF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      slot.time ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isBooked
                            ? Colors.red.shade900
                            : isUnavailable
                            ? Colors.grey
                            : isBlocked
                            ? Colors.orange.shade900
                            : isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }


  Widget buildCourtList(BookSessionController controller) {
    return Obx(() {

      if (controller.isLoadingCourts.value) {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4, // number of shimmer rows
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    // Radio button placeholder
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text placeholders
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 200,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      final slots = controller.slots.value?.data ?? [];

      if (slots.isEmpty) {
        return const Center(child: Text("No courts available"));
      }

      List<Widget> courtWidgets = [];

      for (var slot in slots) {
        final courts = slot.courts ?? [];
        final features = slot.registerClubId?.features ?? [];

        final featureText =
        features.isNotEmpty ? features.join(' | ') : 'No features available';

        for (var court in courts) {
          final courtName = court.courtName ?? '';
          final courtId = court.sId ?? '';

          courtWidgets.add(
              InkWell(
                onTap: () async {
                  controller.courtName.value = courtName;
                  controller.courtId.value = courtId;
                  controller.selectedSlots.clear();
                  await controller.getAvailableCourtsById(
                    controller.argument.id!,
                    selectedCourtId: courtId,
                  );
                },
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.greyColor, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Obx(() => Radio<String>(
                        value: courtName,
                        groupValue: controller.courtName.value,
                        onChanged: (value) async {
                          controller.courtName.value = value!;
                          controller.courtId.value = courtId;
                          controller.selectedSlots.clear();
                          await controller.getAvailableCourtsById(
                            controller.argument.id!,
                            selectedCourtId: courtId,
                          );
                        },
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(courtName, style: Get.textTheme.headlineSmall),
                            const SizedBox(height: 4),
                            Text(featureText, style: Get.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )

          );
        }
      }

      return courtWidgets.isEmpty
          ? const Center(child: Text("No courts available"))
          : Column(children: courtWidgets);
    });
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
          ()=> CustomButton(
            width: Get.width * 0.9,
            onTap: () {
              if (controller.courtName.value.isEmpty) {
                Get.snackbar("Select Court", "Please select a court before booking.",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(12),
                    duration: const Duration(seconds: 2));
                return;
              }
              controller.addToCart();
            },
            child:controller.cartLoader.value?
                CircularProgressIndicator(color: AppColors.whiteColor,):
            Row(
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
