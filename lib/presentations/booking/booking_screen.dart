import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/booking/booking_controller.dart';
import 'package:padel_mobile/presentations/booking/widgets/book_session.dart';
import 'package:padel_mobile/presentations/booking/widgets/home_content.dart';
import 'package:padel_mobile/presentations/booking/widgets/open_matches.dart';
import 'package:padel_mobile/presentations/booking/widgets/tab_bar.dart';
import '../../../configs/app_colors.dart';

class BookingScreen extends GetView<BookingController> {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: Get.height * 0.25,
                  width: Get.width,
                  child: Image.asset(
                    Assets.imagesImgBookingBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: Get.height * 0.25,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(61, 190, 100, 0.4),
                        Color.fromRGBO(31, 65, 187, 0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              color: Colors.transparent,
                              height: 30,
                              width: 40,
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.whiteColor,
                                size: 24,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.whiteColor,
                                child: SvgPicture.asset(
                                  Assets.imagesIcShareBooking,
                                ),
                              ).paddingOnly(right: 15),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.whiteColor,
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(top: Get.height * 0.045),
                      Text(
                        "The Good Club",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.whiteColor),
                      ).paddingOnly(top: Get.height * 0.02),
                      Text(
                        "Sukhna Enclave, behind Rock Garden, Kaimbwala, Kansal,\nChandigarh 160001",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: AppColors.whiteColor),
                        textAlign: TextAlign.center,
                      ).paddingOnly(),
                    ],
                  ).paddingOnly(
                    left: Get.width * 0.03,
                    right: Get.width * 0.03,
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                height: Get.height * 0.73,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    myTabBar(controller.tabController, context),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: const [
                          HomeContent(),
                          BookSession(),
                          OpenMatches(),
                          SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(child: Text("Coming Soon...")),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
