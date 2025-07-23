import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/custom_button.dart';
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
        showLeading: buttonType == "true" ? true : false,
        centerTitle: true,
        title: Text("Cart"),
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            cartList(controller),
            totalSlot(context),
            button(context),
          ],
        ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
      ),
    );
  }

  Widget cartList(CartController controller) {
    return SizedBox(
      height: buttonType == "true" ? Get.height * 0.65 : Get.height * 0.56,
      child: Scrollbar(
        thickness: 5,
        controller: controller.scrollController,
        thumbVisibility: false,
        radius: Radius.circular(8),
        child: Obx(
          ()=> ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.cartItems.length,
            itemBuilder: (BuildContext context, index) {
              final item = controller.cartItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.registerClubId!.clubName.toString(),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                      ),
                    ],
                  ).paddingOnly(bottom: Get.height * 0.01),
                  Text(
                    formatCreatedAt(item.registerClubId!.createdAt.toString()),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.slot?.length ?? 0,
                    itemBuilder: (context, int childIndex) {
                      final slot = item.slot![childIndex];
                      final timesText = slot.slotTimes!.map((e) => e.time).join(", ");
                      final amountsText = slot.slotTimes!.map((e) => "₹ ${e.amount}").join(", ");

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timesText,
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                amountsText,
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  log("data remove");
                                  await controller.removeCartItemsFromCart(
                                    slotIds: [slot.slotId!],
                                  );
                                },
                                child: Image.asset(
                                  Assets.imagesIcRemove,
                                  scale: 3,
                                ).paddingOnly(left: 10),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(bottom: Get.height * 0.01);

                    },
                  ),
                  Container(
                    height: 1,
                    width: Get.width,
                    color: AppColors.containerBorderColor,
                  ),
                ],
              ).paddingOnly(
                bottom: Get.height * 0.01,
                left: Get.width * 0.03,
                right: Get.width * 0.03,
              );
            },
          ),
        ),
      ),
    ).paddingOnly(bottom: Get.height * 0.02);
  }

  Widget totalSlot(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(() {
      return Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.payColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.blackColor.withAlpha(10)),
        ),
        child: Column(
          children: [
            // Total Slots Row
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
                  "${cartController.totalSlot.value} (${cartController.totalSlot.value}h)",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ).paddingOnly(bottom: Get.height * 0.01),

            // Total Price Row
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
                      ),
                    ),
                    Text(
                      "${cartController.totalPrice.value}",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ).paddingOnly(bottom: Get.height * 0.02);
    });
  }

  Widget button(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(() {
      final bookingData = {
        "slot": [
          {
            "slotId": "yourSlotId",
            "businessHours": [
              {"time": "6:00 AM To 10:00 PM", "day": "Thursday"}
            ]
          }
        ],
        "totalPrice": cartController.totalPrice.value,
      };

      return CustomButton(
        width: Get.width * 0.9,
        onTap: () async {
          await cartController.bookCart(data: bookingData);
        },
        child: Row(
          children: [
            Text(
              "₹ ",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                color: AppColors.whiteColor,
              ),
            ).paddingOnly(left: 30),
            Text(
              cartController.totalPrice.value.toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ).paddingOnly(right: Get.width * 0.3),
            Text(
              "Payment",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget emptyState() {
    return Center(
      child: Text("No items in cart"),
    );
  }

  // Date formatting with suffix (e.g., 1st, 2nd, 3rd)
  String formatCreatedAt(String dateStr) {

    final date = DateTime.parse(dateStr);
    final day = date.day;
    final suffix = getDaySuffix(day);
    final formatted = DateFormat("MMMM yyyy").format(date);
    return "$day$suffix $formatted";
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return "th";
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

}
