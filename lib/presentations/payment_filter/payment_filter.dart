import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import 'payment_filter_controller.dart';

class PaymentFilterUi extends GetView<PaymentFilterController> {
  const PaymentFilterUi({super.key});

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
              color: AppColors.lightBlueColor,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20), // Add bottom padding here
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
              ),
            ),
          ),
        ),
      ),      appBar: primaryAppBar(
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
              " Clear all",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: AppColors.primaryColor),
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
              ).paddingOnly(left: Get.width*.05,right: Get.width*.05),
              Row(
                children: [
                  // First Text Field - Start Date
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        // Show date picker
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          // You can update controller or state here
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true, // Prevent keyboard from appearing
                    ),
                  ),

                  SizedBox(width: 10), // Space between fields

                  // Second Text Field - End Date
                  Expanded(
                    child: Obx(() {
                      // Get the selected date from the controller
                      final date = controller.selectedDate.value;

                      // Format the date for display
                      final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                      return TextFormField(
                        onTap: () async {
                          // Open date picker with current selected date or today as initial date
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null && pickedDate != date) {
                            // Update the controller with the new date
                            controller.updateSelectedDate(pickedDate);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: formattedDate,
                          suffixIcon: Icon(Icons.calendar_month_outlined),
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      );
                    }),
                  ),               ],
              ).paddingOnly( top: 16,left: Get.width*.05,right: Get.width*.05),

              // Status Section (Radio Buttons)
              Text(
                "Status",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(top: 10,left: Get.width*.05,right: Get.width*.05),
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
                  ).paddingOnly(left: Get.width*.03,right: Get.width*.03),
                ),
              ),

              // Payment Method Section (Single Select with Compact Checkboxes)
              Text(
                "Payment Method",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(top: 20,left: Get.width*.05,right: Get.width*.05),
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
                  ).paddingOnly(left: Get.width*.03,right: Get.width*.03),
                ),
              ),

              // Amount Section (Single Select with Compact Checkboxes)
              Text(
                "Amount",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(top: 20,left: Get.width*.05,right: Get.width*.05),
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
                  ).paddingOnly(left: Get.width*.03,right: Get.width*.03),
                ),
              ),
            ],
          ).paddingOnly(left: Get.width*.0,right: Get.width*.0),
        ),
      ),
    );
  }
}
