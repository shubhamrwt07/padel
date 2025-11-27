import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/routes/routes_name.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import 'booking_history_controller.dart';

class BookingHistoryUi extends StatelessWidget {
  const BookingHistoryUi({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Use Get.put with a tag or ensure single instance
    final BookingHistoryController controller = Get.put(
      BookingHistoryController(),
      tag: 'booking_history',
    );

    return Scaffold(
      appBar: primaryAppBar(
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
                // ✅ FIX: Pass controller directly instead of using Get.find
                _tabContent(context, controller: controller, type: "upcoming"),
                _tabContent(context, controller: controller, type: "completed"),
                _tabContent(context, controller: controller, type: "cancelled"),
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
          Tab(text: "Cancelled"),
        ],
      ),
    );
  }

  // ✅ FIX: Accept controller as parameter
  Widget _tabContent(BuildContext context, {
    required BookingHistoryController controller,
    required String type,
  }) {
    return Obx(() {

      final bookings = (type == "completed")
          ? (controller.completedBookings.value?.data ?? [])
          : (type == "cancelled")
          ? (controller.cancelledBookings.value?.data ?? [])
          : (controller.upcomingBookings.value?.data ?? []);

      if (controller.isLoading.value) {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100 &&
                controller.hasMoreData(type) &&
                !controller.isLoadingMore.value) {
              controller.loadMoreBookings(type);
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: bookings.length + (controller.hasMoreData(type) ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the bottom
            if (index == bookings.length) {
              return Obx(() {
                if (controller.isLoadingMore.value) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: LoadingWidget(color: AppColors.primaryColor,)
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              });
            }

            final booking = bookings[index];
            final club = booking.registerClubId;

            return GestureDetector(
              onTap: () {
                final bookingId = booking.sId;
                if (bookingId != null && bookingId.isNotEmpty) {
                  Get.toNamed(
                    RoutesName.bookingConfirmAndCancel,
                    arguments: {
                      "id": bookingId,
                      "fromCompleted": type == "completed",
                      "fromCancelled": type == "cancelled",
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
      ),
      );
    });
  }

  Widget bookingCard(BuildContext context, dynamic booking, dynamic club) {
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
                // ✅ CRITICAL FIX: Safe slot checking
                _buildSlotInfo(context, booking),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.textColor),
        ],
      ),
    ).paddingOnly(left: Get.width * .03, right: Get.width * .03, top: 10);
  }

  // ✅ NEW: Separate method for slot info with proper null checks
  Widget _buildSlotInfo(BuildContext context, dynamic booking) {
    try {
      // Check if booking has slot data
      if (booking.slot == null) return const SizedBox.shrink();
      final courtName = booking.slot[0].courtName??"";

      // Ensure slot is a list
      final slotList = booking.slot;
      if (slotList is! List || slotList.isEmpty) return const SizedBox.shrink();

      // Get first slot
      final firstSlot = slotList[0];
      if (firstSlot == null) return const SizedBox.shrink();

      // Check if slotTimes exists
      final slotTimes = firstSlot.slotTimes;
      if (slotTimes == null) {
        // Show only date if no time available
        return Row(
          children: [
            const Icon(Icons.alarm, size: 15),
            Text(
              formatDate(booking.bookingDate),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.blackColor,
              ),
            ).paddingOnly(left: 5),
            Text(
              "($courtName)",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.labelBlackColor,
              ),
            ).paddingOnly(left: 5),
          ],
        );
      }

      if (slotTimes is! List || slotTimes.isEmpty) {
        return Row(
          children: [
            const Icon(Icons.alarm, size: 15),
            Text(
              formatDate(booking.bookingDate),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.blackColor,
              ),
            ).paddingOnly(left: 5),
            Text(
              "($courtName)",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.labelBlackColor,
              ),
            ).paddingOnly(left: 5),
          ],
        );
      }
      final firstTime = slotTimes[0];
      final timeString = firstTime?.time ?? "";

      return Row(
        children: [
          const Icon(Icons.alarm, size: 15),
          Text(
            formatDate(booking.bookingDate),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.blackColor,
            ),
          ).paddingOnly(left: 5),
          if (timeString.isNotEmpty)
            Text(
              formatTimeSlot(timeString),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.blackColor,
              ),
            ).paddingOnly(left: 5),
          Text(
            "($courtName)",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.labelBlackColor,
            ),
          ).paddingOnly(left: 5),
        ],
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error building slot info: $e");
      }
      return const SizedBox.shrink();
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, dd MMM').format(date);
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
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
                  Container(
                    height: 14,
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
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