import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

      if (fileInfo != null && await fileInfo.file.exists()) {
        return fileInfo.file;
      }

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

  /// Share image with text
  Future<void> _shareWithImage() async {
    try {
      final imageUrl = controller.courtsData.value.courtImage?.isNotEmpty == true
          ? controller.courtsData.value.courtImage!.first
          : null;

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await Future.delayed(const Duration(milliseconds: 150));

      if (imageUrl != null && imageUrl.isNotEmpty) {
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

        Get.back();

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
        body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {

              return [
                SliverAppBar(
                  expandedHeight: Get.height * 0.20, // Slightly larger for text visibility
                  pinned: true,
                  floating: false,
                  backgroundColor: AppColors.redColor,
                  automaticallyImplyLeading: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      var top = constraints.biggest.height;
                      final isCollapsed = top <= kToolbarHeight + 50;
                      return Obx(() {
                        final clubName = controller.courtsData.value.clubName ?? '';
                        return isCollapsed && clubName.isNotEmpty
                            ? Text(
                                clubName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.whiteColor),
                              )
                            : const SizedBox.shrink();
                      });
                    },
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      var top = constraints.biggest.height;
                      double opacity = (top <= kToolbarHeight + 20) ? 1.0 : 0.0;
                      final isCollapsed = top <= kToolbarHeight + 50;
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// Background image
                            Obx(() {
                              final imageUrl =
                                  controller.courtsData.value.courtImage?.isNotEmpty == true
                                      ? controller.courtsData.value.courtImage!.first
                                      : '';
                              return imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      width: Get.width,
                                      height: double.infinity,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : const SizedBox.shrink();
                            }),
                            /// Gradient overlay
                            Container(
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
                            ),
                            // Center club name & address over image (only when expanded)
                            if (!isCollapsed)
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        final clubName = controller
                                                .courtsData.value.clubName ??
                                            'Unknown Club';
                                        return Text(
                                          clubName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: AppColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }),
                                      const SizedBox(height: 6),
                                      Obx(() {
                                        final address = controller
                                                .courtsData.value.address ??
                                            'Address not available';
                                        final city =
                                            controller.courtsData.value.city ??
                                                '';
                                        final fullAddress = city.isNotEmpty
                                            ? "$address, $city"
                                            : address;
                                        return Text(
                                          fullAddress,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 15),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            /// Top bar with back button and actions (always at the top)
                            SafeArea(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.03,
                                  vertical: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.back(),
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.whiteColor,
                                        size: 24,
                                      ),
                                    ),
                                    Row(
                                      children: [
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
                                        GestureDetector(
                                          onTap: () => Get.to(
                                                () => CartScreen(buttonType: "true"),
                                          ),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              const CircleAvatar(
                                                radius: 18,
                                                backgroundColor: AppColors.whiteColor,
                                                child: Icon(
                                                  Icons.shopping_cart_outlined,
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                              Positioned(
                                                right: -2,
                                                top: -2,
                                                child: Obx(() {
                                                  final slotCount =
                                                      Get.find<CartController>()
                                                          .totalSlot
                                                          .value;
                                                  return slotCount > 0
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets.all(4),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.red,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Text(
                                                            '$slotCount',
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Pinned TabBar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    myTabBar(controller.tabController, context),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: controller.tabController,
              children: [
                HomeContent(),
                BookSession(),
                OpenMatchesScreen(),
                AmericanoScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper class for pinned TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.whiteColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

/// TabBar widget
PreferredSizeWidget myTabBar(
    TabController tabController, BuildContext context) {
  return TabBar(
    controller: tabController,
    isScrollable: true,
    unselectedLabelStyle:
    Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: 13,
      color: AppColors.textColor,
      fontWeight: FontWeight.w600,
    ),
    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: 13,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600,
    ),
    dividerHeight: 0.5,
    dividerColor: AppColors.textColor.withOpacity(0.1),
    labelPadding: const EdgeInsets.only(left: 0, right: 30),
    automaticIndicatorColorAdjustment: true,
    indicatorWeight: 1,
    tabs: const [
      Tab(child: Text("Home")),
      Tab(child: Text("Book")),
      Tab(child: Text("Open Matches")),
      Tab(child: Text("Americano")),
    ],
  );
}