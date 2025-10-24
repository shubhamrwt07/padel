import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/routes/routes_name.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import 'booking_history_controller.dart';

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
                _tabContent(context, type: "upcoming"),
                _tabContent(context, type: "completed"),
                _tabContent(context, type: "cancelled"),
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
          Tab(text: "Cancelled"), // ✅ new
        ],
      ),
    );
  }

  Widget _tabContent(BuildContext context, {required String type}) {
    final BookingHistoryController controller = Get.find();

    return Obx(() {
      final bookings = (type == "completed")
          ? controller.completedBookings.value?.data ?? []
          : (type == "cancelled")
          ? controller.cancelledBookings.value?.data ?? []
          : controller.upcomingBookings.value?.data ?? [];

      if (controller.isLoading.value) {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context,index){
            return bookingCardShimmer(context);
          },
        );
      }

      if (bookings.isEmpty) {
        return const Center(child: Text("No bookings found"));
      }

      return RefreshIndicator(
        color: Colors.white,
        onRefresh: () async => controller.refreshBookings(),
        child: ListView.builder(
          controller: controller.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: bookings.length + (controller.hasMoreData(type) ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the bottom
            if (index == bookings.length) {
              return Obx(() {
                if (controller.isLoadingMore.value) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              });
            }

            final booking = bookings[index];
            final club = booking.registerClubId;

            return GestureDetector(
              onTap: () {
                if (booking.sId != null && booking.sId!.isNotEmpty) {
                  Get.toNamed(
                    RoutesName.bookingConfirmAndCancel,
                    arguments: {
                      "id": booking.sId!,
                      "fromCompleted": type == "completed", // ✅ pass flag
                    },
                  );
                } else {
                  Get.snackbar("Error", "Booking ID not available");
                }
              },

              child: bookingCard(context, booking, club),
            );
          },
        ),
      );
    });
  }
  Widget bookingCard(BuildContext context, booking, club) {
    return Container(
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
    ).paddingOnly(left: Get.width * .03, right: Get.width * .03, top: 10);
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
  Widget bookingCardShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
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
          border: Border.all(
            color: Colors.grey.shade50,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Club name skeleton
                  Container(
                    height: 14,
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location skeleton
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 12,
                        width: Get.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Booking info skeleton (3 inline segments)
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: Get.width * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 12,
                        width: Get.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 12,
                        width: Get.width * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow icon skeleton
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ).paddingOnly(left: Get.width * .03, right: Get.width * .03, top: 10),
    );
  }


}
