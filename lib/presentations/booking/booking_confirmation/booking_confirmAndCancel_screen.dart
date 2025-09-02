import 'package:cached_network_image/cached_network_image.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:intl/intl.dart';

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
              controller.slotToCancel.value = null; // reset slot selection
            } else {
              Get.back();
            }
          },
        ),
        centerTitle: true,
        title: Obx(
              () => Text(
            controller.cancelBooking.value
                ? (controller.slotToCancel.value != null
                ? "Cancel Slot"
                : AppStrings.bookingCancellation)
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
                    final String? bookingId = Get.arguments?['id'];
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

        if (controller.bookingDetails.value == null ||
            controller.bookingDetails.value!.booking == null) {
          return const Center(child: Text('No booking details found'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!controller.cancelBooking.value) successImageAndMessage(),
              bookingDetailsCard(context),
              paymentDetailsCard(context),
              if (!controller.cancelBooking.value) _showCancelButtonIfAllowed(),
              if (controller.cancelBooking.value) cancelForm(context),
            ],
          ).paddingSymmetric(horizontal: Get.width * 0.05),
        );
      }),
    );
  }

  Widget successImageAndMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(Assets.imagesImgBookingConfirm)),
        const SizedBox(height: 12),
        Text(
          "",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: AppColors.labelBlackColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).paddingOnly(top: Get.height * 0.04, bottom: Get.height * 0.01);
  }

  Widget bookingDetailsCard(BuildContext context) {
    final booking = controller.bookingDetails.value!.booking!;
    final slots = booking.slot ?? [];

    if (slots.isEmpty) {
      return const Center(child: Text("No slot details available"));
    }

    // ✅ Decide the message based on status
    String bookingMessage = "Your Slots are Successfully booked.";
    if (booking.bookingStatus?.toLowerCase() == "in-progress") {
      bookingMessage = "You will receive your refund within 7 days.";
    } else if (booking.bookingStatus?.toLowerCase() == "refunded") {
      bookingMessage = "Your refund successfully credited.";
    } else if (booking.bookingStatus?.toLowerCase() == "completed") {
      bookingMessage = "Your booking has been successfully completed.";
    }

    return Column(
      children: slots.map((slot) {
        final slotTimes = slot.slotTimes ?? [];
        final String date = booking.bookingDate != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(booking.bookingDate!))
            : "N/A";

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.playerCardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrace),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Top logo + dynamic success/refund message
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: booking.userId?.profilePic ?? "",
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                        placeholder: (context, url) => SvgPicture.asset(
                          Assets.imagesImgBookingConfirm,
                          height: 20,
                          color: Colors.white,
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          Assets.imagesImgBookingConfirm,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bookingMessage,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelBlackColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              bookingDetailRow(context, "Court Name", slot.courtName ?? "N/A"),
              bookingDetailRow(context, "Date", date),

              if (slotTimes.isNotEmpty)
                ...slotTimes.map((st) {
                  final amount = st.amount != null ? "₹${st.amount}" : "₹0";

                  return Column(
                    children: [
                      bookingDetailRow(context, "Time", st.time ?? "N/A"),
                      bookingDetailRow(context, "Amount", amount),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),

              // ✅ Show booking status
              bookingDetailRow(
                context,
                "Booking Status" ,
                booking.bookingStatus?.capitalizeFirst ?? "N/A",
              ),

              const SizedBox(height: 8),
            ],
          ).paddingOnly(left: 10, right: 10, top: 15),
        );
      }).toList(),
    );
  }
  Widget paymentDetailsCard(BuildContext context) {
    final booking = controller.bookingDetails.value!.booking!;
    final status = booking.bookingStatus?.toLowerCase();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.playerCardBackgroundColor.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrace),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Details", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          bookingDetailRow(
            context,
            "Total Payment",
            "₹ ${(booking.totalAmount ?? 0).toStringAsFixed(2)}",
          ),

          // ✅ Show refunded amount if status is refunded
          if (status == "refunded" || status == "in-progress")
            bookingDetailRow(
              context,
              "Refunded Amount",
              "₹ ${(booking.refundAmount  ?? 0).toStringAsFixed(2)}",
            ),
        ],
      ),
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
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.textColor,
            ),
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

  Widget _showCancelButtonIfAllowed() {
    final booking = controller.bookingDetails.value?.booking;
    if (booking == null) return const SizedBox.shrink();

    // ✅ check if came from completed tab
    final bool fromCompleted = Get.arguments?['fromCompleted'] ?? false;
    if (fromCompleted) {
      return const SizedBox.shrink();
    }

    final status = booking.bookingStatus?.toLowerCase();

    // ❌ Hide if refunded, already cancelled, or completed
    if (status == "refunded" || status == "completed" || status == "cancelled") {
      return const SizedBox.shrink();
    }

    // ✅ Show "Cancel Booking" only if single slot exists
    if ((booking.slot?.length ?? 0) == 1) {
      return cancelButton();
    }

    return const SizedBox.shrink();
  }

  Widget cancelButton() {
    return PrimaryButton(
      onTap: () {
        controller.cancelBooking.value = true;
        controller.slotToCancel.value = null; // whole booking
      },
      text: AppStrings.cancelBooking,
    ).paddingOnly(top: Get.height * 0.1, bottom: 10);
  }

  Widget cancelForm(BuildContext context) {
    final booking = controller.bookingDetails.value?.booking;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.slotToCancel.value != null
              ? "Why are you cancelling this slot?"
              : AppStrings.whatsYourReason,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(bottom: Get.height * 0.01, top: Get.height * 0.04),

        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
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
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.labelBlackColor,
                      ),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  controller.selectedReason.value = value ?? '';
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
                      hintStyle:
                      Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.labelBlackColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        // ✅ Submit button
        PrimaryButton(
          onTap: () async {
            if (controller.selectedReason.value.isEmpty) {
              SnackBarUtils.showWarningSnackBar("Please select a reason");
              return;
            }

            String cancellationReason = controller.selectedReason.value;

            if (cancellationReason == 'Other') {
              if (controller.otherReasonController.text.trim().isEmpty) {
                SnackBarUtils.showWarningSnackBar("Please write a reason");
                return;
              }
              cancellationReason = controller.otherReasonController.text.trim();
            }

            controller.otherReasonController.text = cancellationReason;

            try {
              await controller.updateBookingStatus();
            } catch (e) {
              SnackBarUtils.showErrorSnackBar(
                "Failed to cancel booking. Please try again.",
              );
            }
          },
          text: AppStrings.submit,
        ).paddingOnly(
          top: controller.selectedReason.value == 'Other'
              ? Get.height * 0.14
              : Get.height * 0.2,
        ),
      ],
    );
  }
}
