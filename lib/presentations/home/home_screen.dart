import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/app_strings.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/search_field.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';

import '../../data/request_models/home_models/get_club_name_model.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: primaryAppBar(
          showLeading: false,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.hello,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "Jane",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ).paddingOnly(left: Get.width * 0.0),
          action: [
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.notification);
              },
              child: Icon(Icons.notifications),
            ),
          ],
          context: context,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchField(),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1.0,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: controller.showLocationAndDate.value
                    ? locationAndDateTime(context)
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: Colors.white,
                onRefresh: controller.retryFetch,
                child: Obx(() {
                  final courtsData = controller.courtsData.value;

                  if (controller.isLoadingClub.value &&
                      !controller.isInitialized.value) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [_buildLoadingState(context)],
                    );
                  }

                  if (controller.clubError.value.isNotEmpty &&
                      !controller.hasCourtsData) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [_buildErrorState(context)],
                    );
                  }

                  final courts = courtsData?.data?.courts;
                  if (courts == null || courts.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [_buildEmptyState(context)],
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        2 +
                        courts.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0) return clubTicketList(context);
                      if (index == 1) {
                        return Text(
                          AppStrings.newBooking,
                          style: Theme.of(context).textTheme.headlineMedium!,
                        ).paddingOnly(
                          bottom: Get.width * 0.02,
                          left: Get.width * 0.02,
                        );
                      }

                      final courtIndex = index - 2;
                      if (courtIndex < courts.length) {
                        return _buildCourtCard(
                          context,
                          courts[courtIndex],
                          courtIndex,
                        );
                      }

                      return _buildLoadMoreIndicator();
                    },
                  );
                }),
              ),
            ),
          ],
        ).paddingOnly(left: Get.width * .02, right: Get.width * .02),
      ),
    );
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
          onChanged: (v) {
            // Add search functionality with debouncing
            controller.searchClubs(v);
          },
        ),
        GestureDetector(
          onTap: () {
            controller.showLocationAndDate.toggle(); // Toggle visibility
          },
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
      left: Get.width * 0.02,
      right: Get.width * 0.02,
    );
  }

  Widget locationAndDateTime(BuildContext context) {
    return Container(
      key: const ValueKey('locationDateTime'),
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  final RxString searchQuery = ''.obs;
                  final scrollController = ScrollController();
                  final searchController = TextEditingController();

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).viewInsets.bottom > 0
                                  ? Get.height * 0.4
                                  : Get.height * 0.6,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    AppStrings.selectLocation,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: searchController,
                                    onChanged: (value) =>
                                        searchQuery.value = value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: AppStrings.searchLocation,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  Obx(() {
                                    final filteredList = controller
                                        .dummyLocations
                                        .where(
                                          (loc) => loc.toLowerCase().contains(
                                            searchQuery.value.toLowerCase(),
                                          ),
                                        )
                                        .toList();

                                    final displayList = [
                                      'None',
                                      ...filteredList,
                                    ];

                                    if (filteredList.isEmpty &&
                                        searchQuery.value.isNotEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 40,
                                        ),
                                        child: Center(
                                          child: Text("No locations found"),
                                        ),
                                      );
                                    }

                                    return Flexible(
                                      child: Scrollbar(
                                        controller: scrollController,
                                        thumbVisibility: true,
                                        radius: const Radius.circular(10),
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: displayList.length,
                                          itemBuilder: (context, index) {
                                            final location = displayList[index];
                                            final isNone = location == 'None';
                                            final isSelected = isNone
                                                ? controller
                                                      .selectedLocation
                                                      .value
                                                      .isEmpty
                                                : controller
                                                          .selectedLocation
                                                          .value ==
                                                      location;

                                            return RadioListTile<String>(
                                              dense: true,
                                              title: Text(
                                                isNone
                                                    ? 'None (Clear selection)'
                                                    : location,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              value: isNone ? '' : location,
                                              groupValue: controller
                                                  .selectedLocation
                                                  .value,
                                              onChanged: (value) {
                                                controller
                                                        .selectedLocation
                                                        .value =
                                                    value!;
                                                Get.back();
                                              },
                                              activeColor:
                                                  AppColors.primaryColor,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
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
                      Obx(
                        () => Container(
                          width: Get.width * 0.45,
                          color: Colors.transparent,
                          child: Text(
                            controller.selectedLocation.value.isEmpty
                                ? AppStrings.location
                                : controller.selectedLocation.value,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: AppColors.textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Obx(() {
                        final hasSelection =
                            controller.selectedLocation.value.isNotEmpty;
                        return GestureDetector(
                          onTap: () {
                            if (hasSelection) {
                              controller.selectedLocation.value = '';
                            }
                          },
                          child: Icon(
                            hasSelection
                                ? Icons.close
                                : Icons.keyboard_arrow_down,
                            size: 20,
                            color: AppColors.textColor,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.selectDate(context);
                },
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
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(controller.selectedDate.value),
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
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
              ),
            ],
          ).paddingOnly(
            left: Get.width * 0.02,
            right: Get.width * 0.02,
            bottom: Get.height * 0.02,
          ),
    );
  }

  Widget clubTicketList(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.yourBooking,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(),
        ).paddingOnly(bottom: Get.width * 0.02),
        SizedBox(
          height: 80,
          child: Scrollbar(
            thumbVisibility: false,
            radius: const Radius.circular(10),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.tabColor),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.greyColor),
                              image: DecorationImage(
                                image: AssetImage(Assets.imagesImgHomeLogo),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "The Good Club",
                                style: Theme.of(context).textTheme.labelLarge!
                                    .copyWith(color: AppColors.blackColor),
                              ).paddingOnly(right: Get.width * .08),
                              Row(
                                children: [
                                  Image.asset(
                                    Assets.imagesIcLocation,
                                    scale: 3,
                                    color: AppColors.blackColor,
                                  ),
                                  Text(
                                    "Chandigarh 160001",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: AppColors.blackColor),
                                  ).paddingOnly(left: 4),
                                ],
                              ).paddingOnly(top: 0, left: 6),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppColors.secondaryColor,
                                    size: 13,
                                  ),
                                  Text(
                                    "4.9",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ).paddingOnly(bottom: 10),
                              Icon(
                                Icons.directions,
                                color: AppColors.secondaryColor,
                                size: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "29thJune",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor,
                                        ),
                                  ),
                                  Text(
                                    "8:00am",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: AppColors.blackColor),
                                  ).paddingOnly(left: 5),
                                ],
                              ),
                              Text(
                                "(60m)",
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(color: AppColors.blackColor),
                              ).paddingOnly(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ).paddingOnly(right: 10);
              },
            ),
          ),
        ),
      ],
    ).paddingOnly(left: Get.width * 0.02, bottom: Get.height * 0.01);
  }

  Widget addToCart(BuildContext context) {
    return Obx(() {
      final courtsData = controller.courtsData.value;

      // Loading state
      if (controller.isLoadingClub.value && !controller.isInitialized.value) {
        return _buildLoadingState(context);
      }

      // Error state
      if (controller.clubError.value.isNotEmpty && !controller.hasCourtsData) {
        return _buildErrorState(context);
      }

      // Empty state - check for null data properly
      if (controller.isInitialized.value &&
          (courtsData == null ||
              courtsData.data == null ||
              courtsData.data!.courts == null ||
              courtsData.data!.courts!.isEmpty)) {
        return _buildEmptyState(context);
      }

      // Data available - show list
      return RefreshIndicator(
        onRefresh: controller.retryFetch,
        color: Colors.white,
        child: ListView.builder(
          controller: controller.scrollController,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount:
              courtsData!.data!.courts!.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the end
            if (index == courtsData.data!.courts!.length) {
              return _buildLoadMoreIndicator();
            }

            final clubs = courtsData.data!.courts![index];
            return _buildCourtCard(context, clubs, index);
          },
        ),
      );
    });
  }

  Widget _buildLoadingState(BuildContext context) {
    return SizedBox(
      height: 200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading courts...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[500]),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            controller.clubError.value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: controller.retryFetch,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    ).paddingOnly(top: Get.height * .1);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey[500]).paddingOnly(top: Get.height*.2),
            const SizedBox(height: 16),
            Text(
              'No courts available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'No courts found for "${controller.searchQuery.value}"'
                  : 'No courts available in this area',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.retryFetch,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                if (controller.searchQuery.value.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: controller.clearSearch,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Clear Search'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourtCard(BuildContext context, Courts clubs, int index) {
    return GestureDetector(
      onTap: () {
        if (clubs.id != null) {
          controller.bookingController.courtsData.value = clubs;
          Get.toNamed(RoutesName.booking, arguments: {"data": clubs});
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Club Image
            SizedBox(
              height: 95,
              width: 118,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: clubs.courtImage != null && clubs.courtImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: clubs.courtImage![0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                        fadeInDuration: Duration(milliseconds: 300),
                        memCacheHeight: 200,
                        // Optional: reduce memory usage
                        useOldImageOnUrlChange:
                            true, // Optional: keeps previous image while updating
                      )
                    : const Center(
                        child: Icon(Icons.photo, color: Colors.grey, size: 40),
                      ),
              ),
            ).paddingOnly(right: Get.width * 0.02),

            // Club Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Club Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          clubs.clubName ?? "N/A",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.secondaryColor,
                            size: 11,
                          ),
                          Text(
                            "4.9",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.imagesIcLocation,
                        scale: 3,
                        color: AppColors.blackColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatAddress(clubs.address, clubs.city),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: AppColors.blackColor,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${clubs.courtCount ?? 0} Courts | ${clubs.features?.join(' | ') ?? ''}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price and arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: '₹',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueColor,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: ' ${clubs.totalAmount ?? 00}',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blueColor,
                                    fontSize: 17,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 25,
                        child: const Icon(Icons.arrow_forward_ios, size: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).paddingOnly(left: Get.width * 0.02, right: Get.width * 0.02, bottom: 5),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  String _formatAddress(String? city, String? address) {
    final cityStr = city?.trim() ?? '';
    final addressStr = address?.trim() ?? '';

    if (cityStr.isEmpty && addressStr.isEmpty) {
      return 'Address not available';
    }

    if (cityStr.isEmpty) {
      return addressStr;
    }

    if (addressStr.isEmpty) {
      return cityStr;
    }

    return '$cityStr, $addressStr';
  }
}
