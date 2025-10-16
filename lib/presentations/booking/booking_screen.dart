import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import '../cart/cart_controller.dart';
import 'americano/americano_screen.dart';
import 'open_matches/open_match_screen.dart';
import 'widgets/booking_exports.dart';

class BookingScreen extends GetView<BookingController> {
  const BookingScreen({super.key});

  /// Try getting image file from cache or download if not available
  Future<File?> _getCachedOrDownloadImage(String imageUrl) async {
    try {
      final cacheManager = DefaultCacheManager();
      final fileInfo = await cacheManager.getFileFromCache(imageUrl);

      // ✅ Use cached image if available
      if (fileInfo != null && await fileInfo.file.exists()) {
        return fileInfo.file;
      }

      // ⬇️ Otherwise download and cache it
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = await cacheManager.putFile(
          imageUrl,
          response.bodyBytes,
          fileExtension: 'jpg',
        );
        return file;
      }
    } catch (e) {
      debugPrint('Error getting cached/downloaded image: $e');
    }
    return null;
  }

  /// Share image with text (optimized for smoother UI)
  Future<void> _shareWithImage() async {
    try {
      final imageUrl = controller.courtsData.value.courtImage?.isNotEmpty == true
          ? controller.courtsData.value.courtImage!.first
          : null;

      // Show loader immediately
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await Future.delayed(const Duration(milliseconds: 150)); // ensure loader shows

      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Run cache/download logic in background isolate
        final imagePath = await compute((url) async {
          try {
            final cacheManager = DefaultCacheManager();
            final fileInfo = await cacheManager.getFileFromCache(url);

            if (fileInfo != null && await fileInfo.file.exists()) {
              return fileInfo.file.path;
            }

            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              final file = await cacheManager.putFile(
                url,
                response.bodyBytes,
                fileExtension: 'jpg',
              );
              return file.path;
            }
          } catch (_) {}
          return null;
        }, imageUrl);

        Get.back(); // close loader

        if (imagePath != null) {
          await Share.shareXFiles(
            [XFile(imagePath)],
            text:
            'Check out this amazing club: ${controller.courtsData.value.clubName ?? 'Unknown Club'}\n${controller.courtsData.value.address ?? ''}, ${controller.courtsData.value.city ?? ''}',
            subject: 'Padel Club Details',
          );
        } else {
          _shareTextOnly();
        }
      } else {
        Get.back();
        _shareTextOnly();
      }
    } catch (e) {
      debugPrint('Error sharing: $e');
      if (Get.isDialogOpen ?? false) Get.back();
      _shareTextOnly();
    }
  }

  /// Fallback: Share text only
  void _shareTextOnly() {
    Share.share(
      'Check out this amazing club: ${controller.courtsData.value.clubName ?? 'Unknown Club'}\n${controller.courtsData.value.address ?? ''}, ${controller.courtsData.value.city ?? ''}',
      subject: 'Padel Club Details',
    );
  }

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
                                GestureDetector(
                                  onTap: _shareWithImage,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.whiteColor,
                                    child: SvgPicture.asset(
                                      Assets.imagesIcShareBooking,
                                    ),
                                  ).paddingOnly(right: 15),
                                ),

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

                                      /// 🔹 Live Badge for Total Slots in Cart
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: Obx(() {
                                          final slotCount = Get.find<CartController>().totalSlot.value;
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
                                )
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
