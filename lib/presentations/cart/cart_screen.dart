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
        title: const Text("Cart"),
        context: context,
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.cartItems.isEmpty) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.selectedClubIds.length ==
                        controller.cartItems.length) {
                      controller.unselectAll();
                    } else {
                      controller.selectAll();
                    }
                  },
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          activeColor: AppColors.secondaryColor,
                          value: controller.selectedClubIds.length ==
                              controller.cartItems.length,
                          onChanged: (val) {
                            if (val == true) {
                              controller.selectAll();
                            } else {
                              controller.unselectAll();
                            }
                          },
                        ),
                      ),
                      Text("Select All",
                          style: Get.textTheme.labelMedium!.copyWith(
                              fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await controller.deleteSelectedClubs();
                  },
                )
              ],
            ).paddingSymmetric(vertical: 10);
          }),
          Expanded(child: cartList(controller)),
        ],
      ).paddingSymmetric(horizontal: Get.width * 0.05),

      /// Bottom section
      bottomNavigationBar: Obx(() {
        if (controller.cartItems.isEmpty) return const SizedBox.shrink();
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                totalSlot(context),
                const SizedBox(height: 8),
                button(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget cartList(CartController controller) {
    return SizedBox(
      height: buttonType == "true" ? Get.height * 0.65 : Get.height * 0.56,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (controller.cartItems.isEmpty) {
          return emptyState();
        }

        final validItems = controller.cartItems.where((item) {
          return item.slot != null &&
              item.slot!.isNotEmpty &&
              item.slot!.any((s) =>
              s.slotTimes != null && s.slotTimes!.isNotEmpty);
        }).toList();

        if (validItems.isEmpty) {
          return emptyState();
        }

        return ListView.builder(
          controller: controller.scrollController,
          itemCount: validItems.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, index) {
            final item = validItems[index];

            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Club Name + Select Checkbox
                  Row(
                    children: [
                      Obx(() => Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          activeColor: AppColors.secondaryColor,
                          value: controller.selectedClubIds
                              .contains(item.registerClubId?.sId ?? ""),
                          onChanged: (val) {
                            controller.toggleSelectClub(
                                item.registerClubId?.sId ?? "");
                          },
                        ),
                      )),
                      Expanded(
                        child: Text(
                          item.registerClubId?.clubName ?? "Unknown Club",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  // 🔹 Loop through ALL slots + slotTimes
                  Column(
                    children: item.slot!.map((slotGroup) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: slotGroup.slotTimes!.length,
                        itemBuilder: (context, int childIndex) {
                          final slot = slotGroup.slotTimes![childIndex];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Date + Time + Duration
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(


                                      formatCreatedAt(slot.bookingDate ?? ""),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${slot.time ?? 'N/A'} ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                        color: AppColors.labelBlackColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "(60m)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),

                              // Price + Remove
                              GestureDetector(
                                onTap: () async {
                                  final slotTimeId = slot.slotId;

                                  if (slotTimeId == null ||
                                      slotTimeId.isEmpty) {
                                    Get.snackbar(
                                        "Error", "Invalid slot ID");
                                    return;
                                  }

                                  await controller.removeCartItemsFromCart(
                                      slotIds: [slotTimeId]);
                                },
                                child: Container(
                                  height: 40,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "₹ ${slot.amount ?? '0'}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                            fontWeight: FontWeight.w500),
                                      ).paddingOnly(right: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.red,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 12,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ).paddingOnly(bottom: Get.height * 0.01);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ).paddingOnly(
                bottom: Get.height * 0.01,
                left: Get.width * 0.03,
                right: Get.width * 0.03,
              ),
            );
          },
        );
      }),
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
                    const Text(
                      "₹ ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "${cartController.totalPrice.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.w500),
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
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textColor,
          ),
          const SizedBox(height: 16),
          Text(
            "No items in cart",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ).copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            "Add some items to get started",
            style: const TextStyle(fontSize: 14).copyWith(
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  String formatCreatedAt(String dateStr) {
    if (dateStr.isEmpty) return "Invalid Date";

    try {
      final date = DateTime.parse(dateStr);
      final day = date.day;
      final suffix = getDaySuffix(day);
      final month = DateFormat("MMMM").format(date);
      final year = date.year;
      return "$day$suffix $month $year";
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
