import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookSession extends StatelessWidget {
   BookSession({super.key});
   final BookSessionController controller = Get.put(BookSessionController());

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
          child: CustomButton(
            width: Get.width*0.9,
              child: Row(
                children: [
                  RichText(text: TextSpan(
                    children:[
                      TextSpan(
                        text: "₹ ",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.whiteColor,fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "2000",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ]
                  )).paddingOnly(right: Get.width * 0.2, left: Get.width * 0.05,),
                  Text(
                    "Add to cart",
                    style: Theme.of(context).textTheme.headlineMedium!
                        .copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
              onTap: (){
              Get.to(()=>CartScreen(buttonType: "true"));
              }),
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
                offset: Offset(0, -Get.height*0.03),
                child: _buildSlotHeader(context),
              ),
              _buildTimeSlots(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Court",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
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
          () => Transform.translate(
            offset: Offset(0,-12),
            child: EasyDateTimeLinePicker.itemBuilder(
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
                          height: Get.height*0.08,
                          width: Get.width*0.15,
                          key: ValueKey(isSelected),
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
                                style: Get.textTheme.bodySmall!.copyWith(color: isSelected ? Colors.white : Colors.black,)
                              ),
                              Text(
                                date.day.toString(),
                                style: Get.textTheme.titleMedium!.copyWith(fontSize: 22,color: isSelected ? Colors.white :AppColors.textColor,)
                              ),
                              Text(
                                monthName,
                                style: Get.textTheme.bodySmall!.copyWith(color: isSelected ? Colors.white : Colors.black,)
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
              onDateChange: (date) {
                controller.selectedDate.value = date;
              },
            ),
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
    return Transform.translate(
      offset: Offset(0, -Get.height*0.025),
      child: GetBuilder<BookSessionController>(
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
      ),
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
