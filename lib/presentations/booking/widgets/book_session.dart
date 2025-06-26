import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/presentations/booking/booking_controller.dart';
import 'package:padel_mobile/presentations/booking/widgets/all_suggestions.dart';

import '../../../generated/assets.dart';

class BookSession extends GetView<BookingController> {
  const BookSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Get.height * .09,
        padding: const EdgeInsets.only(top: 10),
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
          child: Container(
            height: 55,
            width: Get.width * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).primaryColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: PrimaryButton(
              height: 50,

              onTap: () {
                Get.to(AllSuggestions());
              },
              text: "Book the first spot",
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -5),
                child: _buildSlotHeader(context),
              ),
              SizedBox(height: Get.height * .0009),
              _buildTimeSlots(),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Court",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              _buildMatchCard(context),
              _buildMatchCard(context),
              _buildMatchCard(context),
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
        Text("Select date", style: Get.textTheme.labelLarge),
        Obx(
          () => EasyDateTimeLinePicker.itemBuilder(
            headerOptions: HeaderOptions(
              headerBuilder: (_, context, date) => const SizedBox.shrink(),
            ),
            selectionMode: SelectionMode.alwaysFirst(),
            firstDate: DateTime(2025, 1, 1),
            lastDate: DateTime(2030, 3, 18),
            focusedDate: controller.selectedDate.value,
            itemExtent: 72,
            itemBuilder:
                (context, date, isSelected, isDisabled, isToday, onTap) {
                  final dayName = DateFormat('E').format(date);
                  final monthName = DateFormat('MMMM').format(date);

                  return GestureDetector(
                    onTap: onTap,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Container(
                        key: ValueKey(isSelected),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
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
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.darkGrey,
                              ),
                            ),
                            Text(
                              monthName,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).paddingOnly(
                    top: Get.height * .01,
                    bottom: Get.height * .01,
                  );
                },
            onDateChange: (date) {
              controller.selectedDate.value = date;
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
              'View Unavailable Slots',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.darkGrey),
            ),
            SizedBox(width: Get.width * .01),
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
    return GetBuilder<BookingController>(
      builder: (controller) {
          double spacing = Get.width*.02;
        final double tileWidth = (Get.width - spacing * 3 - 32) / 4;

        return Wrap(
          spacing: spacing,
          runSpacing: Get.height * 0.015,
          children: controller.timeSlots.map((time) {
            final isSelected = controller.selectedTime == time;

            return GestureDetector(
              onTap: () {
                controller.selectedTime = time;
                controller.update();
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
            );
          }).toList(),
        );
      },
    );
  }


  Widget _buildMatchCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.greyColor, width: 1.5),
        ),
      ),
      child: ExpansionTile(
        title: Text("Court 1", style: Get.textTheme.headlineSmall),
        leading:   CircleAvatar(radius: 23,backgroundColor: AppColors.greyColor,backgroundImage:AssetImage(Assets.imagesImgDummy2,),),
        subtitle: Text("Outdoor | wall | Double"),
        children: [],
      ),
    );
  }
}
