import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';

class BookingSuccessfulScreen extends StatelessWidget {
  const BookingSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Image.asset(Assets.imagesImgBookingSuccessful,scale: 7,)).paddingOnly(top: Get.height*0.2),
          Text("Booking Successful!",style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.w600),).paddingOnly(bottom: Get.height*0.02),
          Text("Your slot has been booked successfully.",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.w400),).paddingOnly(bottom: Get.height*0.04),
          PrimaryButton(onTap: (){}, text: "Continue").paddingOnly(bottom: Get.height*0.17),
          Text("You’ll receive a reminder before it starts.",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.w400),).paddingOnly(bottom: Get.height*0.02),
          GestureDetector(
            onTap: ()=>Get.toNamed(RoutesName.bookingConfirmAndCancel),
            child: Container(
                color: Colors.transparent,
                child: Text("View Booking Details",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor),).paddingOnly(bottom: Get.height*0.02)),
          ),

        ],
      ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05),
    );
  }
}
