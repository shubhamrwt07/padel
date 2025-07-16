import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/data/request_models/home_models/get_available_court.dart';
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Available Court",
              //       style: Theme.of(context).textTheme.headlineLarge,
              //     ),
              //   ],
              // ).paddingOnly(bottom: Get.height * 0.01),
              // Obx(() {
              //   if (controller.isLoadingCourts.value) {
              //     return Center(child: CircularProgressIndicator());
              //   }
              //
              //   if (controller.courtErrorMessage.isNotEmpty) {
              //     return Center(
              //       child: Text("Error: ${controller.courtErrorMessage.value}"),
              //     );
              //   }
              //
              //   final courts = controller.availableCourtData.value?.data;
              //
              //   if (courts == null || courts.isEmpty) {
              //     return Center(child: Text("No available courts"));
              //   }
              //
              //   return ListView.builder(
              //     itemCount: courts.length,
              //     shrinkWrap: true,
              //     padding: EdgeInsets.zero,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemBuilder: (BuildContext context, int index) {
              //       final court = courts[index];
              //       // return _buildMatchCard(
              //       //   context,
              //       //   court,
              //       // ); // Pass court to the card
              //     },
              //   );
              // }),
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
            firstDate: DateTime.now(), // Start from today
            lastDate: DateTime(2030, 3, 18), // End date
            focusedDate: controller.selectedDate.value,
            itemExtent: 70,
            itemBuilder:
                (context, date, isSelected, isDisabled, isToday, onTap) {
              // Hide past dates manually (just in case plugin does not respect firstDate properly)
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final currentDate = DateTime(date.year, date.month, date.day);
              if (currentDate.isBefore(today)) {
                return const SizedBox.shrink(); // Don’t show past dates
              }

              final dayName = DateFormat('E').format(date);
              final monthName = DateFormat('MMM').format(date);

              return GestureDetector(
                onTap: onTap,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
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
                                padding: const EdgeInsets.all(0),
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
            onDateChange: (date) {
              controller.selectedDate.value = date;
              controller.selectedTimes.clear();
            },
          ),
        ),
      ],
    );
  }
///
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
      child: GetBuilder<BookSessionController>(
        builder: (controller) {
          double spacing = Get.width * 0.02;
          final double tileWidth = (Get.width - spacing * 3 - 32) / 4;
          return Obx(
                () => Wrap(
              spacing: spacing,
              runSpacing: Get.height * 0.015,
              children: controller.timeSlots.map((time) {
                final isSelected = controller.selectedTimes.contains(time);
                final isPast = controller.isPastTimeSlot(time);

                return Opacity(
                  opacity: isPast ? 0.4 : 1.0,
                  child: GestureDetector(
                    onTap: isPast
                        ? null
                        : () {
                      controller.toggleTimeSlot(time);
                      controller.getAvailableCourtsById(
                        controller.argument.id!,
                        time,
                      );
                    },

                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Container(
                        key: ValueKey(isSelected),
                        width: tileWidth,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black
                              : AppColors.timeTileBackgroundColor,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: AppColors.blackColor.withAlpha(10),
                          ),
                        ),
                        child: Text(
                          time,
                          style: Get.textTheme.labelLarge?.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }


  // Widget _buildMatchCard(BuildContext context, AvailableCourtsData court) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             court.name ?? 'Court Name',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 8),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 court.courtType ?? '',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               Text(
  //                 "Price: ${court.slotTimes != null && court.slotTimes!.isNotEmpty ?
  //                 (court.slotTimes!.first.amount?.toString() ?? 'Unavailable') :
  //                 'Unavailable'}",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: AppColors
  //                       .primaryColor, // Replace with your desired color
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
          return CustomButton(
            width: Get.width * 0.9,
            child: Row(
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
            onTap: () {
              Get.to(() => CartScreen(buttonType: "true"));
            },
          );
        }),
      ),
    );
  }
}
