import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';
import '../../generated/assets.dart';

class CartScreen extends GetView<CartController> {
  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: primaryAppBar(
        showLeading: false,
        centerTitle: true,
        title: const Text("Cart"),
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => Scrollbar(
                  thickness: 3,
                  radius: const Radius.circular(8),
                  child: ListView.separated(
                    itemCount: controller.cartItems.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppColors.containerBorderColor),
                    itemBuilder: (context, index) =>
                        _buildCartItem(context, controller.cartItems[index]),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(() => _buildSummaryCard(context)),
            SizedBox(height: Get.height * 0.02),
            Obx(() => _buildPaymentButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(bottom: Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Transform.translate(
                  offset: Offset(-10, 0),
                  child: Checkbox(
                    value: item.isSelected.value,
                    onChanged: (val) => item.isSelected.value = val!,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
                Transform.translate(
                  offset: Offset(-10, 0),
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${item.date} ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: item.time,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      "₹ ${item.price}",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(Assets.imagesIcRemove, scale: 3),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Get.height*.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${item.date} ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: item.time,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      "₹ ${item.price}",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(Assets.imagesIcRemove, scale: 3),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final controller = Get.find<CartController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.payColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blackColor.withAlpha(10)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            "Total Slots",
            "${controller.selectedCount}(${controller.selectedCount}h)",
          ),
          SizedBox(height: Get.height * 0.01),
          _buildSummaryRow(
            context,
            "Total Price",
            "₹ ${controller.totalPrice}",
            isPrice: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value, {
    bool isPrice = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
        isPrice
            ? Row(
                children: [
                  Text(
                    "₹",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    value.replaceAll("₹", ""),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w500),
              ),
      ],
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    final controller = Get.find<CartController>();
    return PrimaryButton(
      height: 50,
      onTap: () => Get.toNamed(RoutesName.paymentMethod),
      text: "",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "₹ ${controller.totalPrice}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: Get.width * 0.2),
              Text(
                "Payment",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
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
              color: const Color(0xFF3DBE64),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2556DA), width: 1),
            ),
            child: const Icon(
              Icons.arrow_outward,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
