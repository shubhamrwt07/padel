import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/auth/booking/booking_controller.dart';

import 'add_review_bottomsheet.dart';

class HomeContent extends GetView<BookingController> {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Court Information",style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: AppColors.labelBlackColor),),
                Row(
                  children: [
                    RatingBar.builder(
                      itemSize: 16,
                      initialRating: 3,
                      minRating: 0,
                      unratedColor: AppColors.starUnselectedColor,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.zero, // No padding
                      itemBuilder: (context, _) => Container(
                        width: 5.0,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          size:27.0, // Adjust the size if needed
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                      },
                    ).paddingOnly(right: Get.width*0.02),
                    Text(
                      "4.5",
                      style:  Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500,color: AppColors.labelBlackColor),
                    )
                  ],
                ),
        
              ],
            ).paddingOnly(top: Get.height*0.02,bottom: Get.height*0.005),
            Text("5 Available courts",style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.textColor),).paddingOnly(bottom: Get.height*0.02),
            Text("Facilities",style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.labelBlackColor),).paddingOnly(bottom: Get.height*0.01),
            SizedBox(
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (BuildContext context,index){
                  return facilities(context);
                },
              ),
            ).paddingOnly(bottom: Get.height*0.02),
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.transparent,
                height: Get.height * 0.1,
                width: Get.width * 0.64,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.homeOptionsList.length,
                  itemBuilder: (context, index) {
                    return Obx(() => GestureDetector(
                      onTap: () => controller.selectedIndex.value = index,
                      child: homeOptionItem(
                        context,
                        icon: controller.homeOptionsList[index]['icon'],
                        label: controller.homeOptionsList[index]['label'],
                        isSelected: controller.selectedIndex.value == index,
                      ),
                    ));
                  },
                ),
              ),
            ),
            Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: getSelectedView(controller.selectedIndex.value),
            )),
            Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Show All",style: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.primaryColor),),
                Icon(Icons.keyboard_arrow_down,size: 15,color: AppColors.primaryColor,)
              ],
            )).paddingOnly(top: Get.height*0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Opening Hours",style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.labelBlackColor),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sunday-Saturday",style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.textColor),),
                    Text("8:00am-11:00pm",style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.textColor),),
                  ],
                ),
              ],
            ).paddingOnly(top: Get.height*0.01)
        
          ],
        ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05),
      ),
    );
  }
  Widget facilities(BuildContext context){
    return  Container(
      height: Get.height*0.025,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.lightBlueColor
      ),
      child: Text("Free parking",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.primaryColor),),
    ).paddingOnly(right: 10);
  }
  Widget homeOptionItem(BuildContext context,
      {required IconData icon, required String label, required bool isSelected}) {
    return Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.labelBlackColor : AppColors.whiteColor,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
        ).paddingOnly(bottom: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.labelBlackColor : Colors.black,
          ),
        ),
      ],
    ).paddingOnly(right: Get.width * 0.06);
  }
  Widget getSelectedView(int index) {
    switch (index) {
      case 0:
        return Container(
          key: ValueKey(0),
          height: Get.height * 0.33,
          color: Colors.red,
          child: const Center(child: Text("Direction View")),
        );
      case 1:
        return Container(
          key: ValueKey(1),
          height: Get.height * 0.33,
          color: Colors.orange,
          child: const Center(child: Text("Call View")),
        );
      case 2:
        return Container(
          key: ValueKey(2),
          height: Get.height * 0.33,
          child: reviewContent(Get.context!),
        );
      case 3:
        return Container(
          key: ValueKey(3),
          height: Get.height * 0.33,
          color: Colors.green,
          child: const Center(child: Text("Photos View")),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget reviewContent(BuildContext context){
    return SizedBox(
      height: Get.height * 0.33,
      width: Get.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Customer reviews",style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.labelBlackColor),),
              GestureDetector(
                onTap: ()=>addReview(context),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(Icons.add,color: AppColors.primaryColor,size: 14,),
                      Text("Review",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.primaryColor),)
                    ],
                  ),
                ),
              )
            ],
          ).paddingOnly(bottom: Get.height*0.01),
          Container(
            height: Get.height*0.3,
            color: Colors.transparent,
            child: ListView.builder(
              itemCount: 10,
              padding: EdgeInsetsGeometry.zero,
              itemBuilder: (context,index){
                return Container(
                  height: 100,
                  width: Get.width,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: AppColors.lightBlueColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.labelBlackColor.withValues(alpha: 0.1))
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(Assets.imagesImgCustomerPicBooking),
                            ).paddingOnly(right: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Darrell Steward",style: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.labelBlackColor),),
                                Transform.translate(
                                  offset: Offset(-Get.width*0.015, 0),
                                  child: Row(
                                    children: [
                                      RatingBar.builder(
                                        itemSize: 12,
                                        initialRating: 3,
                                        minRating: 0,
                                        unratedColor: AppColors.starUnselectedColor,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.zero, // No padding
                                        itemBuilder: (context, _) => Container(
                                          width: 5.0,
                                          height: 30.0,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.star,
                                            size:27.0, // Adjust the size if needed
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                        onRatingUpdate: (rating) {
                                        },
                                      ).paddingOnly(right: Get.width*0.02),
                                      Text(
                                        "4.5",
                                        style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500,color: AppColors.labelBlackColor,fontSize: 7),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],),
                          Text(" Post Date : 22/07/2025",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500,color: AppColors.textColor),)
                        ],
                      ).paddingOnly(bottom: 5),
                      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",style: Theme.of(context).textTheme.bodyMedium,)
                    ],
                  ),
                ).paddingOnly(bottom: 10);
              },
            ),
          )
        ],
      ),
    );
  }
  void addReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddReviewBottomSheet(),
    );
  }


}