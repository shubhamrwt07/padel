import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookSession extends StatelessWidget {
  BookSession({super.key});

  final BookSessionController controller = Get.put(BookSessionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.03),
                child: _buildSlotHeader(context),
              ),
              _buildTimeSlots(),
              Text('Available Courts', style: Theme.of(context).textTheme.labelLarge),
              buildCourtList(controller)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select date",
          style: Get.textTheme.labelLarge,
        ).paddingOnly(bottom: 5),
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
            itemBuilder:
                (context, date, isSelected, isDisabled, isToday, onTap) {
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
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: SizedBox(
                    height: Get.height * 0.14,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Transform.translate(
                          offset: Offset(0, 6),
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
                                    : AppColors.blackColor.withAlpha(10),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: Get.textTheme.bodySmall!.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  date.day.toString(),
                                  style: Get.textTheme.titleMedium!.copyWith(
                                    fontSize: 22,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  monthName,
                                  style: Get.textTheme.bodySmall!.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
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
                              if (selectedCount == 0) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                alignment: Alignment.center,
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondaryColor,
                                ),
                                child: Text(
                                  '$selectedCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
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
              log('Selected date: $date');
              await controller.getAvailableCourtsById(controller.argument.id!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlotHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Available Slots', style: Theme.of(context).textTheme.labelLarge),

      ],
    ).paddingOnly(top: 10,bottom: 5);
  }

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
              return  Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          );
        }

        final courts = controller.slots.value?.data;
        if (courts == null || courts.isEmpty) {
          return const Center(child: Text("No courts available"));
        }

        final slots = courts[0].slot;
        if (slots == null || slots.isEmpty || slots[0].slotTimes == null) {
          return const Center(
            child: Text(
              "No time slots available",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ).paddingOnly(top: Get.height * .15);
        }

        final slotTimes = slots[0].slotTimes!;
        double spacing = Get.width * 0.02;
        final double tileWidth = (Get.width - spacing * 3 - 32) / 4;

        return Wrap(
          spacing: spacing,
          runSpacing: Get.height * 0.015,
          children: slotTimes.map((slot) {
            final isUnavailable = controller.isPastAndUnavailable(slot);
            final isSelected = controller.selectedSlots.contains(slot);

            return GestureDetector(
                onTap: isUnavailable
                    ? null
                    : () => controller.toggleSlotSelection(slot),
                child: Container(
                  width: tileWidth,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isUnavailable
                        ? AppColors.greyColor
                        : isSelected
                        ? Colors.black
                        : AppColors.playerCardBackgroundColor,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: isUnavailable
                          ? Colors.transparent
                          :
                      AppColors.cartColor,

                      width:  1,
                    ),
                  ),
                  child: Text(
                    slot.time ?? '',
                    style: Get.textTheme.labelLarge?.copyWith(
                      color: isUnavailable
                          ? Colors.grey
                          : isSelected
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                )
            );
          }).toList(),
        );
      }),
    );
  }
  Widget buildCourtList(BookSessionController controller) {
    return Obx(() {
      final slots = controller.slots.value?.data ?? [];

      if (controller.isLoadingCourts.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (slots.isEmpty) {
        return const Center(child: Text("No courts available"));
      }

      List<Widget> courtWidgets = [];

      for (var slot in slots) {
        final courts = slot.courts ?? [];
        final features = slot.registerClubId?.features ?? [];

        final featureText = features.isNotEmpty
            ? features.join(' | ')
            : 'No features available';

        for (var court in courts) {
          final courtName = court.courtName ?? '';

          courtWidgets.add(
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.greyColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => Radio<String>(
                    value: courtName,  // <-- Set courtName as value
                    groupValue: controller.courtName.value,  // Current selected courtName
                    onChanged: (value) {
                      controller.courtName.value = value!;  // Update with courtName
                    },
                  )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          court.courtName ?? 'Court',
                          style: Get.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          featureText,
                          style: Get.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }

      if (courtWidgets.isEmpty) {
        return const Center(child: Text("No courts available"));
      }

      return Column(children: courtWidgets);
    });
  }
  Widget _bottomButton() {
    return Container(
      height: Get.height * .09,
      padding: const EdgeInsets.only(top: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: CustomButton(
          width: Get.width * 0.9,
          onTap: () async {
            // Validate court selection before proceeding
            if (controller.courtName.value.isEmpty) {
              Get.snackbar(
                "Select Court",
                "Please select a court before booking.",
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.all(12),
                duration: const Duration(seconds: 2),
              );
              return;
            }

            // Proceed to add to cart
            controller.addToCart();
          },
          child: Row(
            children: [
              Obx(() => RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹ ",
                      style: Get.textTheme.titleMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontFamily: "Roboto",
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
              ).paddingOnly(right: Get.width * 0.3, left: Get.width * 0.05)),
              Text(
                "Book Now",
                style: Get.textTheme.headlineMedium!.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}