import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/presentations/payment/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: primaryAppBar(
        centerTitle: true,
        title: Text("Payment Method"),
        action: [
          Container(
            height: 27,
            width: 27,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.blackColor, width: 2),
            ),
            child: Icon(Icons.add),
          ).paddingOnly(right: 10),
        ],
        context: context,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "Select the payment method which you want\nto use",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ).paddingOnly(top: Get.height*0.02),
          ),
          SizedBox(
            height: Get.height * 0.75,
            child: ListView.builder(
              itemCount:controller.paymentList.length,
              itemBuilder: (context, index) {
                final payment =controller.paymentList[index];
                return paymentOptions(
                  context,
                  payment['icon']!,
                  payment['name']!,
                  payment['value']!,
                );
              },
            ),
          ),
          PrimaryButton(
              height: 50,
              width: Get.width*0.9,
              onTap: () {
              }, text: "",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₹ 7000",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.whiteColor,fontWeight: FontWeight.w500),).paddingOnly(right: Get.width*0.2,left: Get.width*0.05),
                      Text("Book Now",style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.whiteColor,fontWeight: FontWeight.w500,fontSize: 13),),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF3DBE64),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2556DA), width: 1),
                    ),
                    child: const Icon(
                      Icons.arrow_outward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ))

        ],
      ),
    );
  }
  Widget paymentOptions(
      BuildContext context,
      String iconPath,
      String title,
      String value,
      ) {
    return GestureDetector(
      onTap: (){
        controller.option.value = value;
      },
      child: Container(
        height: Get.height * 0.1,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0XFFF5F5F5),
              spreadRadius: 1.2,
              blurRadius: 3.2,
              offset: const Offset(2, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(iconPath).paddingOnly(right: Get.width * 0.05),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            ),
            Obx(
                  () => Radio<String>(
                value: value,
                groupValue: controller.option.value,
                onChanged: (val) {
                  controller.option.value = val!;
                },
              ),
            )
          ],
        ).paddingSymmetric(horizontal: Get.width * 0.05),
      ).paddingSymmetric(
        horizontal: Get.width * 0.05,
        vertical: Get.height * 0.01,
      ),
    );
  }

}

