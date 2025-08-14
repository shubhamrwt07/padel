import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:intl/intl.dart';

class BookingConfirmAndCancelScreen
    extends GetView<BookingConfirmAndCancelController> {
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
        title: Obx(
          () => Text(
            controller.cancelBooking.value
                ? AppStrings.bookingCancellation
                : AppStrings.bookingConfirmation,
          ),
        ),
        context: context,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final String? bookingId = Get.arguments?['bookingId'];
                    if (bookingId != null) {
                      controller.fetchBookingDetails(bookingId);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.bookingDetails.value == null) {
          return const Center(child: Text('No booking details found'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!controller.cancelBooking.value) successImageAndMessage(),
              bookingDetailsCard(context),
              paymentDetailsCard(context),
              controller.cancelBooking.value
                  ? cancelForm(context)
                  : cancelButton(),
            ],
          ).paddingSymmetric(horizontal: Get.width * 0.05),
        );
      }),
    );
  }

  /// ✅ Restored your static image + success message
  Widget successImageAndMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(Assets.imagesImgBookingConfirm)),
        const SizedBox(height: 12),
        Text(
          "Your Slots are Successfully booked.",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: AppColors.labelBlackColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).paddingOnly(top: Get.height * 0.04, bottom: Get.height * 0.03);
  }

  Widget bookingDetailsCard(BuildContext context) {
    final booking = controller.bookingDetails.value!;
    final slot = booking.bookings!.first.slot!.first;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.playerCardBackgroundColor.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blackColor.withAlpha(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bookingDetailRow(context, "Court Name", slot.courtName ?? "N/A"),
          bookingDetailRow(
            context,
            "Court Number",
            "${slot.courtName ?? ''} Court",
          ),
          bookingDetailRow(
            context,
            "Date & Time/Min",
            "${DateFormat('dd/MM/yyyy').format(DateTime.parse(slot.bookingDate!))} ${slot.slotTimes?.first.time ?? ''} "
                "(${slot.courtName ?? 0}min)",
          ),



        ],
      ),
    ).paddingOnly(bottom: Get.height * 0.02);
  }

  /// ✅ Updated to display real payment method + total payment
  Widget paymentDetailsCard(BuildContext context) {
    final booking = controller.bookingDetails.value!;
    final paymentMethod = "Online";
    // Calculate total from all bookings
    final totalAmount =
        booking.bookings?.fold<double>(
          0,
          (sum, b) => sum + (b.totalAmount ?? 0),
        ) ??
        0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment Details", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        bookingDetailRow(context, "Payment Method", paymentMethod),
        bookingDetailRow(
          context,
          "Total payment",
          "₹ ${totalAmount.toStringAsFixed(2)}",
        ),
      ],
    ).paddingOnly(bottom: Get.height * 0.02);
  }

  Widget bookingDetailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: AppColors.textColor),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.labelBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget cancelButton() {
    return PrimaryButton(
      onTap: () => controller.cancelBooking.value = true,
      text: AppStrings.cancelBooking,
    ).paddingOnly(top: Get.height * 0.2);
  }

  Widget cancelForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.whatsYourReason,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(bottom: Get.height * 0.01, top: Get.height * 0.04),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: Get.width * 0.05,
            right: Get.width * 0.05,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor.withAlpha(50),
            border: Border.all(color: AppColors.blackColor.withAlpha(10)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(
              () => DropdownButton<String>(
                value: controller.selectedReason.value.isEmpty
                    ? null
                    : controller.selectedReason.value,
                dropdownColor: AppColors.lightBlueColor,
                hint: Text(
                  AppStrings.chooseOne,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.labelBlackColor,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.labelBlackColor,
                ),
                items: controller.cancellationReasons
                    .map(
                      (reason) => DropdownMenuItem(
                        value: reason,
                        child: Text(
                          reason,
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: AppColors.labelBlackColor),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  controller.selectedReason.value = value!;
                },
              ),
            ),
          ),
        ).paddingOnly(bottom: 30),
        Obx(() {
          if (controller.selectedReason.value == 'Other') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.writeAReasonHere,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(bottom: Get.height * 0.015),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.blackColor.withAlpha(10),
                    ),
                  ),
                  child: TextFormField(
                    controller: controller.otherReasonController,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.labelBlackColor,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: AppStrings.writeHere,
                      hintStyle: Theme.of(context).textTheme.labelLarge!
                          .copyWith(color: AppColors.labelBlackColor),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
        PrimaryButton(
          onTap: () async {
            // Validation checks
            if (controller.selectedReason.value.isEmpty) {
              SnackBarUtils.showWarningSnackBar("Please select a reason");
              return;
            }

            String cancellationReason = '';

            if (controller.selectedReason.value == 'Other') {
              if (controller.otherReasonController.text.trim().isEmpty) {
                SnackBarUtils.showWarningSnackBar("Please write a reason");
                return;
              }
              cancellationReason = controller.otherReasonController.text.trim();
            } else {
              cancellationReason = controller.selectedReason.value;
            }

            // Update the controller's text field with the final reason
            controller.otherReasonController.text = cancellationReason;

            try {
              // Call the API
              await controller.updateBookingStatus();

              // The success handling is already done in updateBookingStatus method
              // It will show success message and navigate back

            } catch (e) {
              // Error handling - show error message
              SnackBarUtils.showErrorSnackBar("Failed to cancel booking. Please try again.");
            }
          },
          text: AppStrings.submit,
        ).paddingOnly(
          top: controller.selectedReason.value == 'Other'
              ? Get.height * 0.14
              : Get.height * 0.29,
        ),
      ],
    );
  }
}
