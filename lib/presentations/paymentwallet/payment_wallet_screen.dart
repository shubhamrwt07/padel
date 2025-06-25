import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';

class PaymentWalletScreen extends StatelessWidget {
  const PaymentWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        showLeading: true,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: Text("Payment ").paddingOnly(left: Get.width * 0.02),
        context: context,
      ),
      body: Column(
        children: [
          Container(
            height: Get.height * .08,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x99d5dcf1), // 60% opacity for fade effect - #1F41BB
                  Color(0x99dbf1e3), // 60% opacity for fade effect - #3DBE64
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payment, color: AppColors.labelBlackColor),
                            Text(
                              "My Wallet",
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.labelBlackColor,
                              ),
                            ).paddingOnly(left: 5),
                          ],
                        ),
                        Text(
                          "Available balance",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: AppColors.labelBlackColor,
                              ),
                        ).paddingOnly(top: 5),
                      ],
                    ),
                    Text(
                      "₹",
                      style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(
                            color: AppColors.blueColor,
                          ),
                    ).paddingOnly(left: Get.width*.4),
                    Text(
                      "7000",
                      style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(
                            color: AppColors.blueColor,
                          ),
                    ),
                  ],
                ).paddingOnly(
                  left: Get.width * .03,
                  right: Get.width * .03,
                  top: 8,
                  bottom: 8,
                ),

              ],
            ).paddingOnly(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All Payment", style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
                fontSize: 13
              ),),
              Icon(Icons.filter)
            ],).paddingOnly(top: 15),

        ],
      ).paddingOnly(left: Get.width * .05, right: Get.width * .05),
    );
  }
}
