
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../generated/assets.dart';

class PaymentWalletScreen extends StatelessWidget {
  const PaymentWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text("Payment").paddingOnly(left: Get.width * 0.02),
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0x99d5dcf1),
                    Color(0x99dbf1e3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightBlueColor.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
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
                              Image.asset(
                                Assets.imagesIcBalanceWallet,
                                scale: 5,
                              ),
                              Text(
                                "My Wallet",
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.labelBlackColor,
                                ),
                              ).paddingOnly(left: 5),
                            ],
                          ),
                          Text(
                            "Available balance",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(

                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(top: 5),
                        ],
                      ),
                      Text(
                        "₹",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.primaryColor,
                          fontFamily: "Roboto"
                        ),
                      ).paddingOnly(left: Get.width * .4),
                      Text(
                        "7000",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ).paddingOnly(left: 5),
                    ],
                  ).paddingOnly(
                    left: Get.width * .03,
                    right: Get.width * .03,
                    top: 8,
                    bottom: 8,
                  ),
                ],
              ).paddingOnly(),
            ),            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Payment",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
///////
                    color: AppColors.blackColor,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RoutesName.paymentFilter);
                  },
                  child: Container(height: 28,width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.tabSelectedColor,
                        borderRadius: BorderRadius.circular(8)

                    ),
                    child: Image.asset(
                      Assets.imagesIcFilter,
                      scale: 5,
                    ),
                  ),
                ) ,              ],
            ).paddingOnly(top: 15,bottom: 15),
            SizedBox(height: Get.height,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Padel Haus",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "29/06/2025",
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                              color: AppColors.labelBlackColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "8:00am",
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                              color: AppColors.labelBlackColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "(60min)",
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                              color: AppColors.labelBlackColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "₹",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                              fontFamily: "Roboto",

                              color: AppColors.blueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "1000",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        ],
                      ).paddingOnly(top: 5),
                      Container(
                        height: 1,
                        width: Get.width,
                        color: AppColors.containerBorderColor,
                      ).paddingOnly(bottom: 10,top: 10),
                    ],

                  );
                },
              ),
            )

            ///
          ],
        ).paddingOnly(left: Get.width * .05, right: Get.width * .05,top: Get.height*.02),
      ),
    );
  }
}
