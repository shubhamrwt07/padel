import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import '../../generated/assets.dart';

class BookingHistoryUi extends StatefulWidget {
  const BookingHistoryUi({super.key});

  @override
  _BookingHistoryUiState createState() => _BookingHistoryUiState();
}

class _BookingHistoryUiState extends State<BookingHistoryUi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text("Booking History").paddingOnly(left: Get.width * 0.02),
        context: context,
      ),
      body: Column(
        children: [
          tabBar(),
          tabBarContent()
        ],
      ),
    );
  }
  Widget tabBar(){
    return Container(
      color: Colors.white,
      child: TabBar(
        dividerColor: AppColors.tabColor,
        controller: _tabController,
        indicatorColor: AppColors.primaryColor,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.labelBlackColor,
        labelStyle: TextStyle(
          fontSize: 12, // Set your desired font size
          fontWeight: FontWeight.w500, // Make active text bold
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: "Upcoming"),
          Tab(text: "Completed"),
        ],
      ),
    );
  }
  Widget tabBarContent(){
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(RoutesName.bookingConfirmAndCancel);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(5),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.containerBorderColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Padel Haus",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-2, 0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Assets.imagesIcLocation,
                                      scale: 2,
                                    ),
                                    Text(
                                      "Chandigarh, 160101",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(

                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(top: 3, bottom: 3),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        size: 15,
                                      ),
                                      Text(
                                        "Thu,27June",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(

                                          color: AppColors.blackColor,
                                        ),
                                      ).paddingOnly(left: 5),
                                      Text(
                                        "8:00am",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(

                                          color: AppColors.blackColor,
                                        ),
                                      ).paddingOnly(left: 5),
                                      Text(
                                        "(60m)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(

                                          color: AppColors
                                              .labelBlackColor,
                                        ),
                                      ).paddingOnly(left: 5),
                                    ],
                                  ),
                                  PrimaryButton(
                                    height: 25,
                                    textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: AppColors.whiteColor,),
                                    width: Get.width * 0.17,
                                    onTap: () {
                                      Get.toNamed(
                                        RoutesName
                                            .bookingConfirmAndCancel,
                                      );
                                    },
                                    text: "View Details",
                                  ),
                                ],
                              ),
                            ],
                          ).paddingOnly(
                            left: Get.width * .03,
                            right: Get.width * .03,
                            top: Get.height * .01,
                            bottom: Get.width * .01,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ).paddingOnly(top: 10, left: Get.width * .03, right: Get.width * .03),
          ),
          // Upcoming Tab Content
          // Completed Tab Content
          Center(
            child: Text(
              "No completed bookings yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      ).paddingOnly(),
    );
  }
}