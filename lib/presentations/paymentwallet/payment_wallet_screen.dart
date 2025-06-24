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
            height: Get.height * .1,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  ],
                ).paddingOnly(
                  left: Get.width * .03,
                  right: Get.width * .03,
                  top: 7,
                  bottom: 7,
                ),
              ],
            ),
          ),
        ],
      ).paddingOnly(left: Get.width * .05, right: Get.width * .05),
    );
  }
}
