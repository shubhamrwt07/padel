import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import '../questions/create_question_screen.dart';
import 'create_match_controller.dart';

class CreateOpenMatchesScreen extends GetView<CreateOpenMatchesController> {
  const CreateOpenMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
          centerTitle: true,
          title: Text("Create creatematch"), context: context),
      bottomNavigationBar: bottomBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePicker(context),
            _buildSlotHeader(context),
            _buildTimeSlots(),
            _buildAvailableCourt()
          ],
        ).paddingOnly(left: Get.width*0.0,right: Get.width*0.0),
      ),

    );
  }
  Widget bottomBar(BuildContext context) {
    return Container(
      height: Get.height * .12,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: 55,
          width: Get.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child:PrimaryButton(
            height: 50,
            onTap: () {
              // Get.back();
              showGeneralDialog(
                context: context,
                barrierColor: AppColors.whiteColor,
                barrierDismissible: false,
                barrierLabel: '',
                pageBuilder: (_, __, ___) {
                  return  CreateQuestionsScreen();
                },
                transitionDuration: const Duration(milliseconds: 300),
                transitionBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );

            },
            text:"Next Step",
            // child: controller.isLoading.value
            //     ? AppLoader(size: 30, strokeWidth: 5)
            //     : null,
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
      ),
    );
  }
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Slots", style: Get.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500,color: AppColors.blackColor)),
            GestureDetector(
              onTap: (){
                controller.openDatePicker(context);
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.calendar_month_outlined, color: Color(0xFF2F3542)),
                ),
              ),
            )
          ],
        ).paddingOnly(bottom: 5),
        Obx(
              () => EasyDateTimeLinePicker.itemBuilder(
            controller: controller.dateTimelineController,
            headerOptions: HeaderOptions(
              headerBuilder: (_, context, date) => const SizedBox.shrink(),
            ),
            selectionMode: SelectionMode.alwaysFirst(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030, 3, 18),
            focusedDate: controller.selectedDate.value,
            itemExtent: 65,
            itemBuilder:
                (context, date, isSelected, isDisabled, isToday, onTap) {
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
                            height: 80,
                            width: Get.width * 0.15,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.textFieldColor.withAlpha(100),
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
                                  style: Get.textTheme.titleMedium!
                                      .copyWith(
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
                              if (selectedCount == 0) {
                                return const SizedBox.shrink();
                              }
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

              // Scroll to the selected date
              controller.dateTimelineController.animateToDate(date);
            },

          ),
        ),
      ],
    );
  }
  Widget _buildSlotHeader(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -Get.height*0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Available Slots', style: Theme.of(context).textTheme.headlineMedium),
          Row(
            children: [
              Text(
                'Show Unavailable Slots',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textColor),
              ),
              Transform.scale(
                scale: 0.7,
                child: Obx(
                      () => CupertinoSwitch(
                    value: controller.viewUnavailableSlots.value,
                    activeTrackColor: AppColors.secondaryColor,
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
      ),
    );
  }
  Widget _buildTimeSlots() {
    return Transform.translate(
      offset: Offset(0, -Get.height*0.01),
      child: GetBuilder<CreateOpenMatchesController>(
        builder: (controller) {
          double spacing = Get.width * 0.02;
          final double tileWidth = (Get.width - spacing * 3 - 32) / 4;
          return Obx(
                ()=> Wrap(
              spacing: spacing,
              runSpacing: Get.height * 0.015,
              children: controller.timeSlots.map((time) {
                final isSelected = controller.selectedTimes.contains(time);
                return GestureDetector(
                  onTap: () {
                    controller.toggleTimeSlot(time); // Toggle selection
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
                            : AppColors.textFieldColor,
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
            ),
          );
        },
      ),
    );
  }
  Widget _buildAvailableCourt(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Court",
          style: Get.textTheme.headlineMedium,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: controller.images.length,
          itemBuilder: (context,index){
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.blackColor.withAlpha(60), width: 0.5),
                ),
              ),
              child: ExpansionTile(
                title: Text("Court 1", style: Get.textTheme.headlineSmall),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(controller.images[index]),
                ),
                subtitle: Text("Outdoor | wall | Double"),
                children: [
                ],
              ),
            );
          },
        )
      ],
    ).paddingOnly(top: Get.height*0.01);
  }
}
