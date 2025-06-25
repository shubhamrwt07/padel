import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/booking/booking_confirmation/booking_confirmAndCancel_controller.dart';
import 'package:padel_mobile/presentations/booking/successful_screens/confirm_cancellation.dart';

import '../../../configs/components/app_bar.dart';

class BookingConfirmAndCancelScreen extends GetView<BookingConfirmAndCancelController> {
  const BookingConfirmAndCancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (controller.cancelBooking.value) {
              controller.cancelBooking.value = false;
            } else {
              Get.back();
            }
          },
        ),
        centerTitle: true,
        title: Obx(() => Text(controller.cancelBooking.value
            ? "Booking Cancellation"
            : "Booking Confirmation")),
        context: context,
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!controller.cancelBooking.value) successImage(),
              slotDetails(context),
              paymentDetails(context),
              controller.cancelBooking.value
                  ? cancelForm(context)
                  : cancelButton()
            ],
          ).paddingSymmetric(horizontal: Get.width * 0.05);
        }),
      ),
    );
  }

  Widget successImage() {
    return Center(
      child: SvgPicture.asset(Assets.imagesImgBookingConfirm),
    ).paddingOnly(top: Get.height * 0.04, bottom: Get.height * 0.03);
  }

  Widget slotDetails(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlueColor.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blackColor.withAlpha(10)),
      ),
      child: Column(
        children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Assets.imagesIcDummyIcon),
                ).paddingOnly(right: 10),
                Expanded(
                  child: Obx(
                    ()=> Text(
                    controller.cancelBooking.value?"Cancel your booking":  "Your Slots are Successfully booked.",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ).paddingOnly(bottom: Get.height * 0.01),
          infoRow("Court Name", "Padel Haus", context),
          infoRow("Court Number", "2 Court", context),
          infoRow("Date & Time/ Min", "29/06/2025  8:00am (60min)", context),
        ],
      ),
    ).paddingOnly(bottom: Get.height * 0.02);
  }

  Widget infoRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: AppColors.textColor)),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColors.labelBlackColor)),
      ],
    ).paddingOnly(bottom: Get.height * 0.01);
  }

  Widget paymentDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment Details",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.labelBlackColor))
            .paddingOnly(bottom: Get.height * 0.01),
        infoRow("Payment Method", "Gpay", context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total payment",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500)),
            Text("₹ 1200",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget cancelButton() {
    return PrimaryButton(
      onTap: () => controller.cancelBooking.value = true,
      text: "Cancel Booking",
    ).paddingOnly(top:Get.height*0.2);
  }

  Widget cancelForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("what’s your reason to cancel this slot",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.labelBlackColor))
            .paddingOnly(bottom: Get.height*0.01, top: Get.height*0.04),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor.withAlpha(50),
            border: Border.all(color: AppColors.blackColor.withAlpha(10)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedReason.value.isEmpty
                  ? null
                  : controller.selectedReason.value,
              dropdownColor: AppColors.lightBlueColor,
              hint: Text(
                "Choose One",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.labelBlackColor),
              ),
              items: controller.cancellationReasons
                  .map((reason) => DropdownMenuItem(
                value: reason,
                child: Text(reason,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: AppColors.labelBlackColor)),
              ))
                  .toList(),
              onChanged: (value) {
                controller.selectedReason.value = value!;
              },
            ),
          ),
        ).paddingOnly(bottom: 30),
        if (controller.selectedReason.value == 'Other') ...[
          Text(
            "write a reason here",
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: AppColors.labelBlackColor),
          ).paddingOnly(bottom: Get.height*0.015),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.lightBlueColor.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blackColor.withAlpha(10)),
            ),
            child: TextFormField(
              controller: controller.otherReasonController,
              maxLines: 5,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.labelBlackColor),
              decoration: InputDecoration.collapsed(
                hintText: "Write here",
                hintStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.labelBlackColor),
              ),
            ),
          ),
        ],

        PrimaryButton(
            onTap: () {
              if (controller.selectedReason.value.isEmpty) {
                Get.snackbar("Error", "Please select a reason",
                    snackPosition: SnackPosition.TOP);
              } else if (controller.selectedReason.value == 'Other' &&
                  controller.otherReasonController.text.trim().isEmpty) {
                Get.snackbar("Error", "Please write a reason",
                    snackPosition: SnackPosition.TOP);
              } else {
                Get.to(()=>ConfirmCancellation());
                Get.snackbar("Cancelled", "Your booking has been cancelled",
                    snackPosition: SnackPosition.TOP);
              }
            },
            text: "Submit",
          ).paddingOnly(top:controller.selectedReason.value == 'Other'?Get.height*0.155:Get.height*0.29),
      ],
    );
  }
}
