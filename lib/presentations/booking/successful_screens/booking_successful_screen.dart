import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';

class BookingSuccessfulScreen extends StatelessWidget {
  const BookingSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.asset(Assets.imagesImgBookingSuccessful, scale: 9),
          ).paddingOnly(top: Get.height * 0.2),
          Text(
            AppStrings.bookingSuccessful,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(bottom: Get.height * 0.02),
          Text(
            AppStrings.yourSlotBooked,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ).paddingOnly(bottom: Get.height * 0.05),
          PrimaryButton(
            onTap: () {
              Get.offAllNamed(RoutesName.bottomNav);
            },
            text: AppStrings.continueText,
          ).paddingOnly(bottom: Get.height * 0.17),
          Text(
            AppStrings.youWillReceiveReminder,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ).paddingOnly(bottom: Get.height * 0.02),
          GestureDetector(
            onTap: () => Get.toNamed(RoutesName.bookingHistory),
            child: Container(
              color: Colors.transparent,
              child: Text(
                AppStrings.viewBookingDetails,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.primaryColor,
                ),
              ).paddingOnly(bottom: Get.height * 0.02),
            ),
          ),
        ],
      ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
    );
  }
}
