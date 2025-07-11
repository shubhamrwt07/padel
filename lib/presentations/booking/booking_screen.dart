import 'package:cached_network_image/cached_network_image.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

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
                  child: Obx(() {
                    final imageUrl = controller.courtsData.value.courtImage?.isNotEmpty == true
                        ? controller.courtsData.value.courtImage!.first
                        : '';
                    return imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                        : SizedBox.shrink();
                  }),
                ),


                Container(
                  height: Get.height * 0.25,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(31, 65, 187, 0.4),
                        Color.fromRGBO(61, 190, 100, 0.4),
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
                              GestureDetector(
                                onTap: ()=>Get.to(()=>CartScreen(buttonType: "true")),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.whiteColor,
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(top: Get.height * 0.06),
                      Obx(() {
                        final clubName = controller.courtsData.value.clubName ?? 'Unknown Club';
                        return Text(
                          clubName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.whiteColor),
                        ).paddingOnly(top: Get.height * 0.02);
                      }),

                      Obx(() {
                        final address = controller.courtsData.value.address ?? 'Address not available';
                        final city = controller.courtsData.value.city ?? '';
                        final fullAddress = city.isNotEmpty ? "$address, $city" : address;

                        return Text(
                          fullAddress,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: AppColors.whiteColor),
                          textAlign: TextAlign.center,
                        ).paddingOnly();
                      }),


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
                        children: [
                           HomeContent(),
                           BookSession(),
                           OpenMatches(),
                           const SizedBox(
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
