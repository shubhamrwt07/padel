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
              ).paddingOnly(bottom: Get.height*0.01),
              ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,index){
                  return _buildMatchCard(context);
                },
              )
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
                 child: Stack(
                   children: [
                     AnimatedSwitcher(
                       duration: const Duration(milliseconds: 1000),
                       switchInCurve: Curves.easeIn,
                       switchOutCurve: Curves.easeOut,
                       transitionBuilder: (child, animation) {
                         return FadeTransition(opacity: animation, child: child);
                       },
                       child: Container(
                         height: Get.height * 0.09,
                         width: Get.width * 0.15,
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
                               style: Get.textTheme.bodySmall!.copyWith(
                                 color: isSelected ? Colors.white : Colors.black,
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
                                 color: isSelected ? Colors.white : Colors.black,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),

                     if (isSelected)
                       Positioned(
                         top: 0,
                         right: 12,
                         child: Obx(() {
                           final selectedCount = controller.selectedTimes.length;
                           if (selectedCount == 0) return const SizedBox.shrink();

                           return Container(
                             padding: const EdgeInsets.all(4),
                             decoration: const BoxDecoration(
                               shape: BoxShape.circle,
                               color: Colors.white,
                             ),
                             child: Text(
                               '$selectedCount',
                               style: const TextStyle(
                                 color: Colors.black,
                                 fontSize: 10,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           );
                         }),
                       ),
                   ],
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
       offset: Offset(0, -Get.height*0.025),
       child: GetBuilder<BookSessionController>(
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
             ),
           );
         },
       ),
     );
   }

  Widget _buildMatchCard(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 23,backgroundColor: AppColors.greyColor,backgroundImage:AssetImage(Assets.imagesImgDummy2,),).paddingOnly(right: Get.width*0.04),
                Text("Court 1", style: Get.textTheme.headlineLarge),
              ],
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '₹',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueColor,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: ' 1200',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.blueColor,fontSize: 18
                          // Keep other styles consistent
                        ),
                      ),
                    ],
                  ),
                ).paddingOnly(right: Get.width*0.05),
                Icon(Icons.shopping_cart_outlined,size: 20,)
              ],
            )
          ],
        ),
        Divider(thickness: 0.5,color: AppColors.textColor,)
      ],
    ).paddingOnly(bottom: Get.height*0.01);
  }

  Widget _bottomButton(){
    return Container(
      height: Get.height * .12,
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
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: AppColors.whiteColor,fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "2000",
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ]
                )).paddingOnly(right: Get.width * 0.3, left: Get.width * 0.05,),
                Text(
                  "Book Now",
                  style: Get.textTheme.headlineMedium!
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
    );
  }
}
