import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/custom_button.dart';
import 'package:padel_mobile/presentations/payment/payment_method_controller.dart';
import '../booking/successful_screens/booking_successful_screen.dart';

class PaymentMethodScreen extends GetView<PaymentMethodController> {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: primaryAppBar(
        centerTitle: true,
        title: Text("Payment Method"),
        action: [
          Container(
            alignment: Alignment.center,
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.blackColor, width: 2),
            ),
            child: Icon(Icons.add, size: 20),
          ).paddingOnly(right: 10),
        ],
        context: context,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "Select the payment method which you want\nto use",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ).paddingOnly(top: Get.height * 0.02),
          ),
          SizedBox(
            height: Get.height * 0.72,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.paymentList.length,
              itemBuilder: (context, index) {
                final payment = controller.paymentList[index];
                return paymentOptions(
                  context,
                  payment['icon']!,
                  payment['name']!,
                  payment['value']!,
                );
              },
            ),
          ),
          CustomButton(
              width: Get.width * 0.9,
              onTap: () {
                Get.to(() => BookingSuccessfulScreen(), transition: Transition.rightToLeft);
              },
              child: Row(
                children: [
                  Text(
                    "₹",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.whiteColor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingOnly(left: 30, right: 5),
                  Text(
                    "7000",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingOnly(
                    right: Get.width * 0.2,
                  ),
                  Text(
                    "Payment",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              )),
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
      onTap: () {
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
              color: const Color(0xFFF5F5F5),
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
                // Increase only Apple image size
                if (title == "ApplePay")
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset(iconPath),
                  ).paddingOnly(right: Get.width * 0.03)
                else
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(iconPath),
                  ).paddingOnly(right: Get.width * 0.05),
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
                activeColor: AppColors.primaryColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                focusColor: AppColors.primaryColor,
                overlayColor: MaterialStateProperty.all(AppColors.primaryColor),
                fillColor: MaterialStateProperty.all(AppColors.primaryColor),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: Get.width * 0.05),
      ).paddingSymmetric(
        horizontal: Get.width * 0.05,
        vertical: Get.height * 0.01,
      ),
    );
  }
}