import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';

class ConfirmCancellation extends StatelessWidget {
  const ConfirmCancellation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          confirmCancelContent(context),
          PrimaryButton(onTap: (){
            Get.toNamed(RoutesName.home);
          }, text: "Continue").paddingOnly(bottom: Get.height*0.08)
        ],
      ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05),
    );
  }
  Widget confirmCancelContent(BuildContext context){
    return Column(
      children: [
        Center(child: SvgPicture.asset(Assets.imagesImgBookingConfirm,height: 200,)).paddingOnly(top: Get.height*0.15,bottom: Get.height*0.03),
        Text("Confirm Cancellation",style: Theme.of(context).textTheme.titleMedium,).paddingOnly(bottom: Get.height*0.02),
        Text("You will receive your refund on your wallet",style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400),).paddingOnly(bottom: Get.height*0.02),
        Text("View Status",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor),).paddingOnly(bottom: Get.height*0.02),
      ],
    );
  }
}
