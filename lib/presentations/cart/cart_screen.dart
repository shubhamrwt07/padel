import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../generated/assets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: primaryAppBar(
        showLeading: false,
        centerTitle: true,
        title: Text("Cart"),
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.67,
              child: Scrollbar(
                thickness: 5,
                radius: Radius.circular(8),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Padel Haus",
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ).paddingOnly(
                          bottom: Get.height * 0.01,
                          left: Get.width * 0.03,
                          right: Get.width * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "27June, 2025 ",
                                    style: Theme.of(context).textTheme.bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: "8:00am (60m)",
                                    style: Theme.of(context).textTheme.bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "₹ 1000",
                                  style: Theme.of(context).textTheme.labelMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Image.asset(
                                  Assets.imagesIcRemove,
                                  scale: 3,
                                ).paddingOnly(left: 10),
                              ],
                            ),
                          ],
                        ).paddingOnly(
                          bottom: Get.height * 0.01,
                          left: Get.width * 0.03,
                          right: Get.width * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "27June, 2025 ",
                                    style: Theme.of(context).textTheme.bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: "8:00am (60m)",
                                    style: Theme.of(context).textTheme.bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "₹ 1000",
                                  style: Theme.of(context).textTheme.labelMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Image.asset(
                                  Assets.imagesIcRemove,
                                  scale: 3,
                                ).paddingOnly(left: 10),
                              ],
                            ),
                          ],
                        ).paddingOnly(
                          bottom: Get.height * 0.01,
                          left: Get.width * 0.03,
                          right: Get.width * 0.03,
                        ),
                        Container(
                          height: 1,
                          width: Get.width,
                          color: AppColors.containerBorderColor,
                        ),
                      ],
                    ).paddingOnly(bottom: Get.height * 0.01);
                  },
                ),
              ),
            ).paddingOnly(bottom: Get.height * 0.02),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.payColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.blackColor.withAlpha(10)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Slots",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "8(8h)",
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: Get.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
        
                      Row(
                        children: [
                          Text(
                            "₹",
                            style: Theme.of(context).textTheme.headlineMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
        
                          Text(
                            "7000",
                            style: Theme.of(context).textTheme.headlineMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ).paddingOnly(left: 3),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ).paddingOnly(bottom: Get.height * 0.02),
            PrimaryButton(
              height: 50,
              onTap: () => Get.toNamed(RoutesName.payment),
              text: "",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ 7000",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ).paddingOnly(
                        right: Get.width * 0.2,
                        left: Get.width * 0.05,
                      ),
                      Text(
                        "Payment",
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                      ),
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
              ),
            ),
          ],
        ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
      ),
    );
  }
}
