import 'package:intl/intl.dart';

import '../../configs/routes/routes_name.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import 'booking_history_controller.dart';
import 'booking_review/booking_completed_review.dart';

class BookingHistoryUi extends StatelessWidget {
  const BookingHistoryUi({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingHistoryController controller = Get.put(BookingHistoryController());

    return Scaffold(
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text("Booking History").paddingOnly(left: Get.width * 0.02),
        context: context,
      ),
      body: Column(
        children: [
          tabBar(controller),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _tabContent(context, isCompleted: false),
                _tabContent(context, isCompleted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar(BookingHistoryController controller) {
    return Container(
      color: Colors.white,
      child: TabBar(
        dividerColor: AppColors.tabColor,
        controller: controller.tabController,
        indicatorColor: AppColors.primaryColor,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.labelBlackColor,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: "Upcoming"),
          Tab(text: "Completed"),
        ],
      ),
    );
  }

  Widget _tabContent(BuildContext context, {required bool isCompleted}) {
    final BookingHistoryController controller = Get.find();

    return Obx(() {
      final bookings = isCompleted
          ? controller.completedBookings.value?.data ?? []
          : controller.upcomingBookings.value?.data ?? [];

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (bookings.isEmpty) {
        return const Center(child: Text("No bookings found"));
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final club = booking.registerClubId;

          return GestureDetector(
            onTap: () {
              if (isCompleted) {

              } else {
                Get.toNamed(
                  RoutesName.bookingConfirmAndCancel,
                  arguments: {"bookingId": booking.sId ?? ""},
                );
              }
            },

            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              padding: EdgeInsets.only(
                left: Get.width * .03,
                right: Get.width * .03,
                top: Get.height * .01,
                bottom: Get.width * .01,
              ),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.containerBorderColor,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club?.clubName ?? "N/A",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-2, 0),
                          child: Row(
                            children: [
                              Image.asset(Assets.imagesIcLocation, scale: 2),
                              Text(
                                "${club?.city ?? ''}, ${club?.zipCode ?? ''}",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ],
                          ).paddingOnly(top: 3, bottom: 3),
                        ),
                        if (booking.slot != null && booking.slot!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.alarm, size: 15),
          Text(
          formatDate(booking.bookingDate),
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: AppColors.blackColor,
          ),
          ).paddingOnly(left: 5),
                              if (booking.slot!.first.slotTimes != null &&
                                  booking.slot!.first.slotTimes!.isNotEmpty)
                                Text(
                                  booking.slot!.first.slotTimes!.first.time ?? "",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: AppColors.blackColor,
                                  ),
                                ).paddingOnly(left: 5),
                              Text(
                                "(60m)",
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.labelBlackColor,
                                ),
                              ).paddingOnly(left: 5),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.textColor),
                ],
              ),
            ).paddingOnly(left: Get.width * .03, right: Get.width * .03, top: 10),
          );
        },
      );
    });
  }
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, dd MMMM').format(date); // e.g., Thu, 27 June
    } catch (e) {
      return dateStr;
    }
  }
}
