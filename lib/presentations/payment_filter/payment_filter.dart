import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import 'payment_filter_controller.dart';

class PaymentFilterUi extends StatelessWidget {
  PaymentFilterUi({super.key});

  final PaymentFilterController controller =
  Get.put(PaymentFilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Get.height * .09,
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
              height: 55,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).primaryColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: PrimaryButton(
                height: 50,

                onTap: () {
                  Get.back();
                },
                text: "Apply Filter",
              )
          ),
        ),
      ),
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text(
          " Filter",
          style: Theme.of(context).textTheme.titleMedium,
        ).paddingOnly(left: Get.width * 0.02),
        action: [
          GestureDetector(
            onTap: controller.clearAll,
            child: Text(
              " clear all",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: AppColors.blueColor),
            ).paddingOnly(left: Get.width * 0.02),
          ),
        ],
        context: context,
      ),
      body: Obx(
            () => SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Label
              Text(
                "Date",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ),

              // Status Section (Radio Buttons)
              Text(
                "Status",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(top: 10),
              ...['Completed', 'Failed', 'Processing'].map(
                    (status) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Radio<String>(
                          value: status,
                          groupValue: controller.selectedStatus.value,
                          onChanged: (val) =>
                              controller.selectStatus(val ?? 'Completed'),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Text(
                        status,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.labelBlackColor),
                      ),
                    ],
                  ),
                ),
              ),

              // Payment Method Section (Single Select with Compact Checkboxes)
              Text(
                "Payment Method",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(top: 20),
              ...['Gpay', 'Paypal', 'Apple pay'].map(
                    (method) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          value:
                          controller.selectedPaymentMethod.value == method,
                          onChanged: (_) =>
                              controller.selectPaymentMethod(method),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Text(
                        method,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.labelBlackColor),
                      ),
                    ],
                  ),
                ),
              ),

              // Amount Section (Single Select with Compact Checkboxes)
              Text(
                "Amount",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(top: 20),
              ...['Up to 200', '200-500', '500-2000'].map(
                    (range) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          
                          value:
                          controller.selectedAmountRange.value == range,
                          onChanged: (_) =>
                              controller.selectAmountRange(range),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Text(
                        range,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.labelBlackColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).paddingOnly(left: Get.width*.03,right: Get.width*.03),
        ),
      ),
    );
  }
}
