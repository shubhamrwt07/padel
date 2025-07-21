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
                                  controller.selectedTimes.length;
                              if (selectedCount == 0)
                                return const SizedBox.shrink();
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
              controller.selectedDate.value = date;
              controller.selectedTimes.clear();
              controller.selectedSlotAmounts.clear();

              log('Selected date: $date');

              final nextSlot = controller.timeSlots.firstWhere(
                    (time) => !controller.isPastTimeSlot(time),
                orElse: () => controller.timeSlots.last,
              );

              await controller.getAvailableCourtsById(controller.argument.id!, nextSlot);
              controller.autoSelectFirstAvailableSlot();
              controller.update(); // Force UI refresh
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
        Row(
          children: [
            Text(
              'Show Unavailable Slots',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.darkGrey),
            ),
            Transform.scale(
              scale: 0.7,
              child: Obx(
                () => CupertinoSwitch(
                  value: controller.viewUnavailableSlots.value,
                  activeTrackColor: Theme.of(context).primaryColor,
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
  Widget _buildTimeSlots() {
    return Transform.translate(
      offset: Offset(0, -Get.height * 0.025),
      child: Obx(() {
        if (controller.isLoadingCourts.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final courts = controller.availableCourtData.value?.data;
        if (courts == null || courts.isEmpty) {
          return const Center(child: Text("No courts available"));
        }

        final slots = courts[0].slot;
        if (slots == null || slots.isEmpty || slots[0].slotTimes == null) {
          return const Center(child: Text("No time slots available"));
        }

        final slotTimes = slots[0].slotTimes!;
        final selectedDate = controller.selectedDate.value ?? DateTime.now();
        final now = DateTime.now();

        double spacing = Get.width * 0.02;
        final double tileWidth = (Get.width - spacing * 3 - 32) / 4;

        return Wrap(
          spacing: spacing,
          runSpacing: Get.height * 0.015,
          children: slotTimes.map((data) {
            final isSelected = controller.selectedTimes.contains(data.time!);
            final isToday = selectedDate.year == now.year &&
                selectedDate.month == now.month &&
                selectedDate.day == now.day;
            final isPast = isToday && controller.isPastTimeSlot(data.time!);

            return GestureDetector(
              onTap: isPast
                  ? null
                  : () {
                controller.toggleTimeSlot(data.time!);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: tileWidth,
                padding: const EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isPast
                      ? AppColors.greyColor
                      : isSelected
                      ? Colors.black
                      : AppColors.timeTileBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: isPast
                        ? Colors.grey.shade400
                        : Colors.black.withAlpha(10),
                  ),
                ),
                child: Text(
                  data.time!,
                  style: Get.textTheme.labelLarge?.copyWith(
                    color: isPast
                        ? Colors.grey.shade600
                        : isSelected
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
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
        child: Obx(() {
          final totalAmount = controller.totalAmount;
          final isLoading = controller.isLoading.value;

          return CustomButton(
            width: Get.width * 0.9,
            onTap: () async {

            if(controller.selectedTimes.isNotEmpty){
              await controller.addSelectedSlotsToCart();

              if (!controller.isLoading.value) {
                Get.to(() => CartScreen(buttonType: "true"));
              }
            }
            },
            child: isLoading
                ? const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
                : Row(
              children: [
                RichText(
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
                        text: totalAmount.toStringAsFixed(0),
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ).paddingOnly(right: Get.width * 0.3, left: Get.width * 0.05),
                Text(
                  "Book Now",
                  style: Get.textTheme.headlineMedium!.copyWith(
                    color: AppColors.whiteColor,
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
