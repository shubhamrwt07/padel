import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class OpenMatches extends StatelessWidget {
  OpenMatches({super.key});

  final OpenMatchesController controller = Get.put(OpenMatchesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height*0.03),
                child: _buildSlotHeader(context),
              ),

              _buildTimeSlots(),
              _buildMatchHeader(context),
              SizedBox(height: 10,),
              _buildMatchCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButton(){
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
          child: Text(
            "+ Book the first spot",
            style: Get.textTheme.headlineMedium!.copyWith(color: AppColors.whiteColor),
          ).paddingOnly(right: Get.width * 0.14),
          onTap: () {
            Get.to(
                  () => AllSuggestions(),
              transition: Transition.rightToLeft,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select date", style: Get.textTheme.labelLarge).paddingOnly(bottom: 5),
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
              final dayName = DateFormat('E').format(date);
              final monthName = DateFormat('MMM').format(date);

              return GestureDetector(
                onTap: onTap,
                child:
                    AnimatedSwitcher(
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
                                  color: isSelected ? Colors.black : AppColors.playerCardBackgroundColor,
                                  border: Border.all(
                                    color: isSelected ? Colors.transparent : AppColors.blackColor.withAlpha(10),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(dayName, style: Get.textTheme.bodySmall!.copyWith(color: isSelected ? Colors.white : Colors.black)),
                                    Text(date.day.toString(), style: Get.textTheme.titleMedium!.copyWith(fontSize: 22, color: isSelected ? Colors.white : AppColors.textColor, fontWeight: FontWeight.w600)),
                                    Text(monthName, style: Get.textTheme.bodySmall!.copyWith(color: isSelected ? Colors.white : Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 0,
                                right: -4,
                                child: Obx(() {
                                  final selectedCount = controller.selectedTimes.length;
                                  if (selectedCount == 0) return const SizedBox.shrink();
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    padding: const EdgeInsets.all(0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor,
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
                      )
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
      child: GetBuilder<OpenMatchesController>(
        builder: (controller) {
          double spacing = Get.width * .02;
          final double tileWidth = (Get.width - spacing * 3 - 32) / 4;

          return Obx(
                ()=> Wrap(
              spacing: spacing,
              runSpacing: Get.height * 0.015,
              children: controller.timeSlots.map((time) {
                final isSelected = controller.selectedTimes.contains(time);

                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      controller.selectedTimes.remove(time);
                    } else {
                      controller.selectedTimes.add(time);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Book a place in a match",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        GestureDetector(
          onTap: () => Get.to(
                () => AllSuggestions(),
            transition: Transition.rightToLeft,
          ),
          child: Container(
            height: 20,
            width: Get.width * 0.15,
            alignment: Alignment.centerRight,
            color: Colors.transparent,
            child: Text(
              "View all",
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.playerCardBackgroundColor,
        border: Border.all(color: AppColors.greyColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "21 June | 9:00am",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "The first player sets the match type",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ).paddingOnly(top: 10, bottom: 10, right: 15, left: 15),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerSlot(
                        image: Assets.imagesImgCustomerPicBooking,
                      ).paddingOnly(bottom: 6),
                      _buildPlayerSlot(
                        image: Assets.imagesImgCustomerPicBooking,
                      ).paddingOnly(bottom: 6),
                      Container(width: 1, color: AppColors.greyColor),
                      _buildPlayerSlot(
                        image: Assets.imagesImgCustomerPicBooking,
                      ).paddingOnly(bottom: 6),
                      _buildPlayerSlot(
                        image: Assets.imagesImgCustomerPicBooking,
                      ).paddingOnly(bottom: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Good Club',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesIcLocation,
                        scale: 3,
                      ),
                      Text(
                        'Chandigarh 160001',
                        style: Get.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '₹ 2000',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ).paddingOnly(top: Get.width * .02),
            ],
          ).paddingOnly(top: 5,bottom: 10, left: 15,right: 15),
        ],
      ),
    );
  }

  Widget _buildPlayerSlot({required String image}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: AppColors.greyColor,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(height: 7),
        Text(
          "Courtney",
          style: Get.textTheme.bodySmall!.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}