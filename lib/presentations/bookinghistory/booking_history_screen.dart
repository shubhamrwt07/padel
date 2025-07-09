import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/bookinghistory/booking_review/booking_completed_review.dart';
import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../generated/assets.dart';
import 'booking_history_controller.dart';

class BookingHistoryUi extends StatelessWidget {
  const BookingHistoryUi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingHistoryController>(
      init: BookingHistoryController(),
      builder: (controller) {
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
              )
            ],
          ),
        );
      },
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
    return ListView.builder(
      physics: const BouncingScrollPhysics(), // Smooth scrolling effect
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (isCompleted) {
              Get.to(() =>  BookingCompletedReview(),
                  transition: Transition.rightToLeft);
            } else {
              Get.toNamed(RoutesName.bookingConfirmAndCancel);
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Padel Haus",
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
                            "Chandigarh, 160101",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: AppColors.darkGrey),
                          ),
                        ],
                      ).paddingOnly(top: 3, bottom: 3),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.alarm, size: 15),
                        Text(
                          "Thu, 27 June",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: AppColors.blackColor),
                        ).paddingOnly(left: 5),
                        Text(
                          "8:00am",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: AppColors.blackColor),
                        ).paddingOnly(left: 5),
                        Text(
                          "(60m)",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: AppColors.labelBlackColor),
                        ).paddingOnly(left: 5),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 18, color: AppColors.textColor),
              ],
            ),
          ).paddingOnly(left: Get.width*.03,right: Get.width*.03,top: 10,bottom: 0),
        );
      },
    );
  }
}