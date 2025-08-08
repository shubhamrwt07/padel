import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/custom_button.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';

import '../../configs/routes/routes_name.dart';
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
      child: Obx(
            () => controller.cartItems.isEmpty
            ? emptyState()
            : ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.cartItems.length,
          itemBuilder: (BuildContext context, index) {
            final item = controller.cartItems[index];

            // Add null safety checks here
            if (item.slot == null || item.slot!.isEmpty) {
              return SizedBox.shrink(); // Return empty widget if no slots
            }

            final firstSlot = item.slot!.first;
            if (firstSlot.slotTimes == null || firstSlot.slotTimes!.isEmpty) {
              return SizedBox.shrink(); // Return empty widget if no slot times
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Club Name
                Text(
                  item.registerClubId?.clubName ?? "Unknown Club",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingOnly(bottom: Get.height * 0.01),

                // Slot List
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: firstSlot.slotTimes!.length,
                  itemBuilder: (context, int childIndex) {
                    final slot = firstSlot.slotTimes![childIndex];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Date + Time + Duration
                        Row(
                          children: [
                            Text(
                              formatCreatedAt(slot.bookingDate ?? ""),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${slot.time ?? 'N/A'} ",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "(60m)",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        // Price + Remove Icon
                        Row(
                          children: [
                            Text(
                              "₹ ${slot.amount ?? '0'}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final slotTimeId = slot.slotId;

                                if (slotTimeId == null) {
                                  Get.snackbar("Error", "Invalid slot ID");
                                  return;
                                }

                                await controller.removeCartItemsFromCart(slotIds: [slotTimeId]);
                              },
                              child: Image.asset(
                                Assets.imagesIcRemove,
                                scale: 2,
                              ).paddingOnly(left: 10),
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(bottom: Get.height * 0.015);
                  },
                ),

                Divider(
                  thickness: 1,
                  color: AppColors.containerBorderColor,
                ).paddingOnly(top: Get.height * 0.015),
              ],
            ).paddingOnly(
              bottom: Get.height * 0.01,
              left: Get.width * 0.03,
              right: Get.width * 0.03,
            );
          },
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
                  "Total Slots (${cartController.totalSlot.value})",
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
      return CustomButton(
        width: Get.width * 0.9,
        onTap: () async {
          final cartItems = cartController.cartItems;

          if (cartItems.isEmpty) {
            Get.snackbar("Empty Cart", "Please add items to cart.");
            return;
          }

          // Simply navigate to payment screen without booking
          Get.toNamed(RoutesName.paymentMethod);
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
            ).paddingOnly(right: Get.width * 0.1),
            Text(
              "Proceed to Payment",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      );
    });
  }  Widget emptyState() {
    return Center(
      child: Text("No items in cart"),
    );
  }

  // Date formatting with suffix (e.g., 1st, 2nd, 3rd)
  // ✅ Updated date formatter to: 28th June' 2025
  String formatCreatedAt(String dateStr) {
    if (dateStr.isEmpty) return "Invalid Date";

    try {
      final date = DateTime.parse(dateStr);
      final day = date.day;
      final suffix = getDaySuffix(day);
      final month = DateFormat("MMMM").format(date);
      final year = date.year;
      return "$day$suffix $month' $year";
    } catch (e) {
      return "Invalid Date";
    }
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