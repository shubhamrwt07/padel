import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
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
        leading: Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: Text("Booking History").paddingOnly(left: Get.width * 0.02),
        context: context,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              // Set the active tab color
              labelColor: AppColors.primaryColor,
              // Text color for the active tab
              unselectedLabelColor: AppColors.labelBlackColor,
              // Text color for inactive tabs
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container( height: Get.height ,
                        child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10), // Add spacing between items
                              height: Get.height * .11,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                border: Border.all(
                                  color: AppColors.containerBorderColor, // Border color
                                  width: 2.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(16.0), // Border radius
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Padel Haus",
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.alarm, size: 16),
                                          Text(
                                            "27June,25",
                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                          Text(
                                            "8:00am",
                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColors.blackColor,
                                            ),
                                          ).paddingOnly(left: 5),
                                          Text(
                                            "(60mins)",
                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColors.labelBlackColor,
                                            ),
                                          ).paddingOnly(left: 5),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        Assets.imagesIcLocation,
                                        scale: 2,
                                      ),
                                      Text(
                                        "Chandigarh, 160101",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                      Text(
                                        "₹",
                                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.blueColor,
                                        ),
                                      ).paddingOnly(left: Get.width * .35),
                                      Text(
                                        "1200",
                                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.blueColor,
                                        ),
                                      ).paddingOnly(left: 5),
                                    ],
                                  ).paddingOnly(top: 3, bottom: 3),
                                  Row(
                                    children: [
                                      Text(
                                        "4 Courts",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      Container(
                                        height: 13,
                                        width: 1.5,
                                        color: AppColors.labelBlackColor,
                                      ).paddingOnly(left: 2, right: 2),
                                      Text(
                                        "Free parking",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      Container(
                                        height: 13,
                                        width: 1.5,
                                        color: AppColors.labelBlackColor,
                                      ).paddingOnly(left: 2, right: 2),
                                      Text(
                                        "Shed",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: Get.height * .028,
                                        width: Get.width * .23,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              const Color(0xFF3DBE64), // #3DBE64 (30%)
                                              const Color(0xFF1F41BB), // #1F41BB (70%)
                                            ],
                                            stops: [0.1, 0.9], // 30% for first color, rest for second
                                          ),
                                        ),
                                        child: Text(
                                          "View Details",
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            color: AppColors.whiteColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ).paddingOnly(left: Get.width * .18),
                                    ],
                                  ),
                                ],
                              ).paddingOnly(
                                left: Get.width * .03,
                                right: Get.width * .03,
                                top: Get.height * .01,
                                bottom: Get.width * .01,
                              ),
                            );
                          },
                        ),
                      )                  ],
                  ).paddingOnly(
                    top: 10,
                    left: Get.width * .03,
                    right: Get.width * .03,
                  ),
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
          ),
        ],
      ),
    );
  }
}
