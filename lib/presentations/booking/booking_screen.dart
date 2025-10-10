import 'package:cached_network_image/cached_network_image.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import '../cart/cart_controller.dart';
import 'americano/americano_screen.dart';
import 'open_matches/open_match_screen.dart';

class BookingScreen extends GetView<BookingController> {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  /// Background image
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
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                          : const SizedBox.shrink();
                    }),
                  ),

                  /// Overlay and top bar
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
                        /// Top row (Back + Share + Cart)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 40,
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.whiteColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                /// Share button
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.whiteColor,
                                  child: SvgPicture.asset(
                                    Assets.imagesIcShareBooking,
                                  ),
                                ).paddingOnly(right: 15),

                                /// Cart with badge
                                GestureDetector(
                                  onTap: () => Get.to(() => CartScreen(buttonType: "true")),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.whiteColor,
                                        child: const Icon(
                                          Icons.shopping_cart_outlined,
                                          color: AppColors.blackColor,
                                        ),
                                      ),

                                      /// 🔹 Badge showing total slots in cart
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: Obx(() {
                                          final slotCount = CartController().totalSlot.value; // use totalSlot
                                          return slotCount > 0
                                              ? Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$slotCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                              : const SizedBox.shrink();
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).paddingOnly(top: Get.height * 0.06),

                        /// Club name
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

                        /// Club address
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
                          );
                        }),
                      ],
                    ).paddingSymmetric(horizontal: Get.width * 0.03),
                  ),
                ],
              ),

              /// Main content
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
                            OpenMatchesScreen(),
                            AmericanoScreen(),
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
      ),
    );
  }
}
