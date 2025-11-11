import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/app_strings.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/configs/components/search_field.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';
import 'package:padel_mobile/presentations/home/widget/custom_skelton_loader.dart';
import 'package:padel_mobile/presentations/drawer/zoom_drawer_controller.dart';
import '../../data/request_models/home_models/get_club_name_model.dart';
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: primaryAppBar(
            showLeading: false,
            title: Row(
              children: [
                // Drawer menu icon
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    final drawerController = Get.find<CustomZoomDrawerController>();
                    drawerController.toggleDrawer();
                  },
                ),


                // Space between icon and title
                const SizedBox(width: 0),

                // Existing title widget
                Expanded(child: _buildAppBarTitle(context)),
              ],
            ),
            action: [
              InkWell(
                onTap: () => Get.toNamed(RoutesName.notification),
                child: const Icon(Icons.notifications),
              ).paddingOnly(right: 5),
            ],
            context: context,
          ),

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchField(),
                Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1.0,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: controller.showLocationAndDate.value
                      ? locationAndDateTime(context)
                      : const SizedBox.shrink(
                    key: ValueKey('empty'),
                  ),
                )),
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      color: Colors.white,
                      onRefresh: controller.retryFetch,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: controller.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Bookings Section ---
                            if (controller.isLoadingBookings.value)
                              bookingShimmer()
                            else if ((controller.bookings.value?.data ?? []).isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.yourBooking,
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ).paddingOnly(bottom: Get.width * 0.02),
                                  clubTicketList(context),
                                ],
                              ),

                            // --- Courts Section ---
                            Text(AppStrings.newBooking,
                                style: Get.textTheme.headlineMedium)
                                .paddingOnly(bottom: Get.width * 0.02,),
                            if (controller.isLoadingClub.value)
                              Column(
                                children: List.generate(5, (_) => loadingCard()),
                              )
                            else
                              _buildCourtList(),
                          ],
                        ),
                      ),
                    );
                  }),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Obx(() {
      final profile = controller.profileController.profileModel.value;
      if (controller.profileController.isLoading.value) {
        return Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.textFieldColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }

      final name = profile?.response?.name?.capitalizeFirst??"";
      final displayName =
      (name.trim().isEmpty) ? 'Guest' : name;

      return SizedBox(
        width: Get.width * 0.34,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppStrings.hello,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: displayName,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ).paddingOnly(left: 5);
    });
  }

  Widget searchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchField(
          width: Get.width * 0.8,
          suffixIcon: Image.asset(
            Assets.imagesIcSearch,
            scale: 4,
            color: AppColors.textColor,
          ),
          hintText: AppStrings.search,
          hintStyle: Get.textTheme.bodyLarge!.copyWith(
            color: AppColors.textColor,
          ),
          onChanged: controller.searchClubs,
        ),
        GestureDetector(
          onTap: () => controller.showLocationAndDate.toggle(),
          child: Obx(
                () => Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.searchBarColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                controller.showLocationAndDate.value
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down_sharp,
              ),
            ),
          ),
        ),
      ],
    ).paddingOnly(
      bottom: Get.height * 0.01,
    );
  }

  Widget locationAndDateTime(BuildContext context) {
    return Container(
      key: const ValueKey('locationDateTime'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _locationPicker(context),
          _datePicker(context),
        ],
      ).paddingOnly(
        bottom: Get.height * 0.02,
      ),
    );
  }

  Widget _locationPicker(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.showLocationPicker(context),
      child: Container(
        height: 35,
        width: Get.width * 0.61,
        decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => SizedBox(
              width: Get.width * 0.45,
              child: Text(
                controller.selectedLocation.value.isEmpty
                    ? AppStrings.location
                    : controller.selectedLocation.value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textColor),
                overflow: TextOverflow.ellipsis,
              ),
            )),
            Obx(() {
              final hasSelection = controller.selectedLocation.value.isNotEmpty;
              return GestureDetector(
                onTap: () {
                  if (hasSelection) controller.selectedLocation.value = '';
                },
                child: Icon(
                  hasSelection ? Icons.close : Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.textColor,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _datePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.selectDate(context),
      child: Container(
        height: 35,
        width: Get.width * 0.27,
        decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.018),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => Text(
                DateFormat('dd/MM/yyyy').format(controller.selectedDate.value),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12,
                  color: AppColors.textColor,
                ),
              ),
            ),
            Icon(
              Icons.calendar_month_outlined,
              size: 13,
              color: AppColors.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget clubTicketList(BuildContext context) {
    final booking = controller.bookings.value?.data ?? [];
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: booking.length,
        itemBuilder: (context, index) => _buildBookingCard(context, booking[index]),
      ),
    ).paddingOnly(bottom: Get.height * 0.01);
  }

  Widget _buildBookingCard(BuildContext context, dynamic b) {
    final club = b.registerClubId;
    return GestureDetector(
      onTap: () {
        if (b.sId != null && b.sId!.isNotEmpty) {
          Get.toNamed(RoutesName.bookingConfirmAndCancel, arguments: {"id": b.sId!});
        } else {
          Get.snackbar("Error", "Booking ID not available");
        }
      },
      child: Container(
        width: 235,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.tabColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bookingImage(club),
                _bookingInfo(context, club),
                _bookingRatingArrow(context),
              ],
            ),
            _bookingTimeInfo(context, b),
          ],
        ),
      ).paddingOnly(right: 10),
    );
  }

  Widget _bookingImage(dynamic club) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greyColor),
      ),
      child: ClipOval(
        child: (club?.courtImage != null &&
            club!.courtImage!.isNotEmpty &&
            club.courtImage![0].isNotEmpty)
            ? CachedNetworkImage(
          imageUrl: club.courtImage![0],
          fit: BoxFit.cover,
          placeholder: (_, __) =>
          LoadingWidget(color: AppColors.primaryColor,),
          errorWidget: (_, __, ___) =>
              Image.asset(Assets.imagesImgHomeLogo),
        )
            : Image.asset(
          Assets.imagesImgHomeLogo,
          fit: BoxFit.cover,
        ),
      )

    );
  }

  Widget _bookingInfo(BuildContext context, dynamic club) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: Text(
            club?.clubName ?? "N/A",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.blackColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Image.asset(Assets.imagesIcLocation, scale: 3, color: AppColors.blackColor),
            SizedBox(width: 4),
            SizedBox(
              width: Get.width * 0.3,
              child: Text(
                club?.city ?? "N/A",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.blackColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    ).paddingOnly(left: 6);
  }

  Widget _bookingRatingArrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.secondaryColor, size: 13),
            Text("4.9", style: Theme.of(context).textTheme.bodySmall),
          ],
        ).paddingOnly(bottom: 10),
        const Icon(Icons.directions, color: AppColors.secondaryColor, size: 15),
      ],
    );
  }

  Widget _bookingTimeInfo(BuildContext context, dynamic b) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              controller.formatDate(b.bookingDate),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
            if (b.slot!.first.slotTimes != null && b.slot!.first.slotTimes!.isNotEmpty)
              Text(
                b.slot!.first.slotTimes!.first.time ?? "",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.blackColor),
              ).paddingOnly(left: 5),
          ],
        ),
        GestureDetector(
          onTap: ()=>Get.toNamed(RoutesName.scoreBoard),
          child: Container(
            height: 25,
            width: 50,
            alignment: AlignmentGeometry.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.secondaryColor,
            ),
            child: Text("Play",style: Get.textTheme.headlineSmall!.copyWith(color: Colors.white),),
          ),
        )
      ],
    );
  }

  Widget _buildCourtList() {
    // Handle loading state for initial load
    if (controller.isLoadingClub.value && !controller.isInitialized.value) {
      return Column(
        children: List.generate(4, (_) => loadingCard()),
      );
    }

    // Handle error state
    if (controller.clubError.value.isNotEmpty && !controller.hasCourtsData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              controller.clubError.value,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.retryFetch,
              child: const Text('Retry'),
            ),
          ],
        ).paddingSymmetric(vertical: 50),
      );
    }

    // Get courts list
    final courts = controller.courtsList;

    // Handle empty state
    if (courts.isEmpty && controller.isInitialized.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'No courts found for "${controller.searchQuery.value}"'
                  : 'No courts available',
              textAlign: TextAlign.center,
              style: Get.textTheme.headlineMedium?.copyWith(color: Colors.grey[600]),
            ),
            if (controller.searchQuery.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.clearSearch,
                child: const Text('Clear Search'),
              ),
            ],
          ],
        ).paddingSymmetric(vertical: 200),
      );
    }

    // Build court list with load more functionality
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courts.length + (controller.isLoadingMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end when loading more
        if (index == courts.length && controller.isLoadingMore.value) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: LoadingWidget(color: AppColors.primaryColor,),
            ),
          );
        }

        // Build court card
        if (index < courts.length) {
          return _buildCourtCard(context, courts[index], index);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCourtCard(BuildContext context, Courts club, int index) {
    return GestureDetector(
      onTap: () {
        log("CLUB ID -> ${club.id}");
        if (club.id != null) {
          Get.toNamed(RoutesName.booking, arguments: {"data": club});
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.tabColor),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              height: 95,
              width: 118,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: club.courtImage != null && club.courtImage!.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: club.courtImage![0],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(child: LoadingWidget(color: AppColors.primaryColor,)),
                  errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                )
                    : const Center(child: Icon(Icons.photo, color: Colors.grey, size: 40)),
              ),
            ).paddingOnly(right: Get.width * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.clubName ?? "N/A",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(Assets.imagesIcLocation, scale: 3, color: AppColors.blackColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${club.address}, ${club.city}",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${club.courtCount ?? 0} Courts | ${club.features?.join(' | ') ?? ''}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: '₹', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.blueColor, fontSize: 17)),
                            TextSpan(
                              text: ' ${club.totalAmount ?? 00}',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.blueColor, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 15),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).paddingOnly(bottom: 5),
    );
  }

}
