import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

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
            ? AppStrings.bookingCancellation
            : AppStrings.bookingConfirmation)),
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
        color: AppColors.playerCardBackgroundColor.withAlpha(50),
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
                    controller.cancelBooking.value ? AppStrings.cancelYourBooking :  AppStrings.slotSuccessfullyBooked,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ).paddingOnly(bottom: Get.height * 0.01),
          infoRow(AppStrings.courtName, "Padel Haus", context),
          infoRow(AppStrings.courtNumber, "2 Court", context),
          infoRow(AppStrings.dateAndTime, "29/06/2025  8:00am (60min)", context),
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
                .headlineSmall!
                .copyWith(color: AppColors.textColor)),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColors.labelBlackColor,fontWeight: FontWeight.w600)),
      ],
    ).paddingOnly(bottom: Get.height * 0.01);
  }

  Widget paymentDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.paymentDetails,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.labelBlackColor))
            .paddingOnly(bottom: Get.height * 0.01),
        infoRow(AppStrings.paymentMethod, "Gpay", context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.totalPayment,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500)),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '₹',
                    style: TextStyle(
                      fontFamily: "Roboto",
                    ),
                  ),
                  TextSpan(
                    text: ' 1200',
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget cancelButton() {
    return PrimaryButton(
      onTap: () => controller.cancelBooking.value = true,
      text: AppStrings.cancelBooking,
    ).paddingOnly(top:Get.height*0.2);
  }

  Widget cancelForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.whatsYourReason,
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
                AppStrings.chooseOne,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.labelBlackColor),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.labelBlackColor,
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
            AppStrings.writeAReasonHere,
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
                hintText: AppStrings.writeHere,
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
                SnackBarUtils.showErrorSnackBar("Please select a reason");
              } else if (controller.selectedReason.value == 'Other' &&
                  controller.otherReasonController.text.trim().isEmpty) {
                SnackBarUtils.showErrorSnackBar("Please write a reason");
              } else {
                Get.to(()=>ConfirmCancellation());
                SnackBarUtils.showSuccessSnackBar("Your booking has been cancelled");
              }
            },
            text: AppStrings.submit,
          ).paddingOnly(top:controller.selectedReason.value == 'Other'?Get.height*0.14:Get.height*0.29),
      ],
    );
  }
}
