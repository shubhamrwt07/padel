import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/custom_button.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';

import '../../generated/assets.dart';

class CartScreen extends StatelessWidget {
  final String buttonType;
  final CartController controller = Get.put(CartController());
   CartScreen({super.key, required this.buttonType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: primaryAppBar(
        showLeading: buttonType=="true" ?true: false,
        centerTitle: true,
        title: Text("Cart"),
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            cartList(controller),
            totalSlot(context),
            button(context)
          ],
        ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
      ),
    );
  }
  Widget cartList(CartController controller){
    return SizedBox(
      height:buttonType=="true"? Get.height * 0.65:Get.height * 0.56,
      child: Scrollbar(
        thickness: 5,
        controller: controller.scrollController,
        thumbVisibility: false,
        radius: Radius.circular(8),
        child: ListView.builder(
          controller: controller.scrollController,
          itemCount: 10,
          itemBuilder: (BuildContext context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Padel Haus",
                      style: Theme.of(context).textTheme.labelLarge!
                          .copyWith(),
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
                            text: "27June 2025 ",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(fontWeight: FontWeight.w500,  color: AppColors.textColor,),
                          ),
                          TextSpan(
                            text: "8:00am (60m)",
                            style: Theme.of(context).textTheme.labelLarge!
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
                          "₹ ",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(fontWeight: FontWeight.w500,fontFamily: "Roboto"),
                        ),
                        Text(
                          "1000",
                          style: Theme.of(context).textTheme.labelLarge!
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
                            text: "30June 2025 ",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(fontWeight: FontWeight.w500,  color: AppColors.textColor,),
                          ),
                          TextSpan(
                            text: "8:00am (60m)",
                            style: Theme.of(context).textTheme.labelLarge!
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
                          "₹ ",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(fontWeight: FontWeight.w500,fontFamily: "Roboto"),
                        ),
                        Text(
                          "1000",
                          style: Theme.of(context).textTheme.labelLarge!
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
    ).paddingOnly(bottom: Get.height * 0.02);
  }
  Widget totalSlot(BuildContext context){
    return Container(
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
                    "₹ ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                      fontSize: 15,
                    )
                  ),

                  Text(
                    "7000",
                    style: Theme.of(context).textTheme.headlineMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ).paddingOnly(),
                ],
              ),
            ],
          ),
        ],
      ),
    ).paddingOnly(bottom: Get.height * 0.02);
  }
  Widget button(BuildContext context){
    return CustomButton(
        width: Get.width*0.9,
        onTap: (){
          Get.toNamed(RoutesName.paymentMethod);
        },
        child: Row(
          children: [
            Text(
              "₹ ",
              style: Theme.of(context).textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w600,fontFamily: "Roboto",
                color: AppColors.whiteColor,
              ),
            ).paddingOnly(left: 30,),
            Text(
              "7000",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.whiteColor,

                fontWeight: FontWeight.w600,
              ),
            ).paddingOnly(
              right: Get.width * 0.3,
            ),
            Text(
              "Payment",
              style: Theme.of(context).textTheme.headlineMedium!
                  .copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ));
  }
}