import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';

class PaymentFilterUi extends StatelessWidget {
  const PaymentFilterUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text(
          " Filter",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(),
        ).paddingOnly(left: Get.width * 0.02),
        action: [
          Text(
            " clear all",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: AppColors.blueColor),
          ).paddingOnly(left: Get.width * 0.02),
        ],
        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Date",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ),
            ],
          ).paddingOnly(),
          Text(
            "Status",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.labelBlackColor,
            ),
          ).paddingOnly(top: 10),
          Row(
            children: [
              Icon(Icons.radio_button_checked, size: 18),
              Text(
                "Completed",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),
          Row(
            children: [
              Icon(Icons.radio_button_checked, size: 18),
              Text(
                "Failed",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),
          Row(
            children: [
              Icon(Icons.radio_button_checked, size: 18),
              Text(
                "Processing",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.labelBlackColor,
            ),
          ).paddingOnly(top: 20),
          Row(
            children: [
              Icon(Icons.check_box_outlined, size: 18),
              Text(
                "Gpay",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10), Row(
            children: [
              Icon(Icons.check_box_outlined, size: 18),
              Text(
                "Paypal",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10), Row(
            children: [
              Icon(Icons.check_box_outlined, size: 18),
              Text(
                "Apple pay",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),
          Text(
            "Amount",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.labelBlackColor,
            ),
          ).paddingOnly(top: 20),
          Row(
            children: [
              Icon(Icons.check_box_outlined, size: 18),
              Text(
                "Up to 200",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),Row(
            children: [
              Icon(Icons.check_box_outlined, size: 18),
              Text(
                "200-500",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),Row(
            children: [
              Icon(Icons.check_box_outlined, size: 18),
              Text(
                "500-2000",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 10),


        ],
      ).paddingOnly(left: Get.width * .05, right: Get.width * .05),
    );
  }
}
