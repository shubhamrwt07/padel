import 'package:intl/intl.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:latlong2/latlong.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final HomeContentController controller = Get.put(HomeContentController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Court Information",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: AppColors.labelBlackColor,
                  ),
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      itemSize: 16,
                      initialRating: 3,
                      minRating: 0,
                      unratedColor: AppColors.starUnselectedColor,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.zero,
                      // No padding
                      itemBuilder: (context, _) => Container(
                        width: 5.0,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          size: 27.0, // Adjust the size if needed
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      onRatingUpdate: (rating) {},
                    ).paddingOnly(right: Get.width * 0.02),
                    Text(
                      "4.5",
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.labelBlackColor,
                          ),
                    ),
                  ],
                ),
              ],
            ).paddingOnly(top: Get.height * 0.02, bottom: Get.height * 0.005),
            Text(
              "5 Available courts",
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: AppColors.textColor),
            ).paddingOnly(bottom: Get.height * 0.02),
            Text(
              "Facilities",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.labelBlackColor,
              ),
            ).paddingOnly(bottom: Get.height * 0.01),
            SizedBox(
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (BuildContext context, index) {

                  return facilities(context, index);
                },
              ),
            ).paddingOnly(bottom: Get.height * 0.02),
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.transparent,
                height: Get.height * 0.1,
                width: Get.width * 0.7,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.homeOptionsList.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final item = controller.homeOptionsList[index];
                      final isSelected =
                          controller.selectedIndex.value == index;

                      final Widget iconWidget = item['isSvg']
                          ? SvgPicture.asset(
                              item['image'],
                              height: 24,
                              width: 24,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.labelBlackColor,
                            )
                          : Icon(
                              item['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.labelBlackColor,
                            );

                      return GestureDetector(
                        onTap: () {
                          if (index != 1) {
                            controller.selectedIndex.value = index;
                            if (index != 2) {
                              controller.isShowAllReviews.value = false;
                            }
                            if (index != 3) {
                              controller.isShowAllPhotos.value = false;
                            }
                          }
                        },
                        child: homeOptionItem(
                          context,
                          iconWidget: iconWidget,
                          label: item['label'],
                          isSelected: isSelected,
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: getSelectedView(controller.selectedIndex.value),
              ),
            ),
            Obx(() {
              if (controller.selectedIndex.value == 0) {
                return const SizedBox.shrink();
              }
              return Center(
                child: GestureDetector(
                  onTap: () {
                    if (controller.selectedIndex.value == 2) {
                      controller.isShowAllReviews.toggle();
                    } else if (controller.selectedIndex.value == 3) {
                      controller.isShowAllPhotos.toggle();
                    }
                  },
                  child: Container(
                    width: Get.width * 0.2,
                    height: 20,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.selectedIndex.value == 2
                              ? (controller.isShowAllReviews.value
                                    ? "Show Less"
                                    : "Show All")
                              : (controller.isShowAllPhotos.value
                                    ? "Show Less"
                                    : "Show All"),
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(color: AppColors.primaryColor),
                        ),
                        Icon(
                          controller.selectedIndex.value == 2
                              ? (controller.isShowAllReviews.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down)
                              : (controller.isShowAllPhotos.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down),
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).paddingOnly(top: Get.height * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Opening Hours",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColors.labelBlackColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sunday-Saturday",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      "8:00am-11:00pm",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
      ),
    );
  }

  Widget facilities(BuildContext context, index) {
    return Row(
      children: [
        Icon(
          Icons.ac_unit,
          size: 10,
          color: AppColors.primaryColor,
        ).paddingOnly(right: 5),
        Text(
          "${index + 1}. Free parking",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    ).paddingOnly(right: 10);
  }

  Widget homeOptionItem(
    BuildContext context, {
    required Widget iconWidget,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppColors.labelBlackColor
                : AppColors.whiteColor,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Center(child: iconWidget),
        ).paddingOnly(bottom: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.labelBlackColor : Colors.black,
          ),
        ),
      ],
    ).paddingOnly(right: Get.width * 0.07);
  }

  Widget getSelectedView(int index) {
    final height = Get.height * 0.33;
    switch (index) {
      case 0:
        return SizedBox(
          key: ValueKey(0),
          height: Get.height * 0.18,
          child: directionGoogleMaps(),
        );
      case 1:
        return SizedBox(
          key: ValueKey(1),
          height: height,
          child: const Center(child: Text("Call View")),
        );
      case 2:
        return Obx(
          () => Container(
            // color: AppColors.redColor,
            key: ValueKey(2),
            // height: controller.isShowAllReviews.value
            //     ? Get.height * 0.6
            //     : Get.height * 0.3,
            child: reviewContent(Get.context!),
          ),
        );
      case 3:
        return SizedBox(
          key: ValueKey(3),
          height: controller.isShowAllPhotos.value
              ? Get.height * 0.6
              : Get.height * 0.33,
          child: photoGallery(Get.context!),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget reviewContent(BuildContext context) {
    final reviewData = controller.reviewResponse.value?.data?.first;
    final reviews = reviewData?.reviews ?? [];

    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reviews.isEmpty) {
      return const Center(child: Text("No reviews available"));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer reviews",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.labelBlackColor,
              ),
            ),
            GestureDetector(
              onTap: () => addReview(context),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.add, color: AppColors.primaryColor, size: 14),
                    Text(
                      "Review",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: Get.height * 0.01),

        Container(
          // When showing all reviews, we don't fix height — let it expand
          height: controller.isShowAllReviews.value
              ? null // full height based on reviews
              : (reviews.length >= 3
              ? 3 * 85.0 // height for first 3 reviews
              : reviews.length * 85.0),
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: controller.isShowAllReviews.value
                ? reviews.length
                : reviews.length > 3
                ? 3
                : reviews.length,
            physics: controller.isShowAllReviews.value
                ? const NeverScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            shrinkWrap: true, // makes list take only the needed space
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final rating = review.reviewRating ?? 0;
              final comment = review.reviewComment ?? "";
              final userName = review.userId?.email ?? "Anonymous";
              final postDate = review.createdAt != null
                  ? DateFormat("dd/MM/yyyy").format(DateTime.parse(review.createdAt!))
                  : "N/A";

              return Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.labelBlackColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                Assets.imagesImgCustomerPicBooking,
                              ),
                            ).paddingOnly(right: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  width: Get.width*0.3,
                                  child: Text(
                                    userName,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                      color: AppColors.labelBlackColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: rating.toDouble(),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: AppColors.secondaryColor,
                                      ),
                                      itemSize: 12,
                                      unratedColor: AppColors.starUnselectedColor,
                                    ).paddingOnly(right: 5),
                                    Text(
                                      rating.toString(),
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.labelBlackColor,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "Post Date: $postDate",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ).paddingOnly(bottom: 5),

                    // Comment
                    Text(
                      comment,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 12, height: 1.1),
                    ),
                  ],
                ),
              ).paddingOnly(bottom: 10);
            },
          ),
        )
      ],
    );
  }


  void addReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReviewBottomSheet(),
    );
  }

  Widget photoGallery(BuildContext context) {
    final List<String> imageUrls = [
      Assets.imagesImgDummy1,
      Assets.imagesImgDummy2,
      Assets.imagesImgDummy3,
      Assets.imagesImgDummy4,
      Assets.imagesImgDummy5,
      Assets.imagesImgDummy1,
      Assets.imagesImgDummy2,
      Assets.imagesImgDummy3,
      Assets.imagesImgDummy4,
      Assets.imagesImgDummy5,
    ];

    final bool isExpanded = controller.isShowAllPhotos.value;

    return SizedBox(
      height: isExpanded ? Get.height * 0.6 : Get.height * 0.33,
      child: Column(
        children: [
          // First block (always shown)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildImage(imageUrls[0])),
                SizedBox(width: 10),
                Expanded(flex: 1, child: _buildImage(imageUrls[1])),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Second block (always shown)
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: _buildImage(imageUrls[2])),
                SizedBox(width: 10),
                Expanded(child: _buildImage(imageUrls[3])),
                SizedBox(width: 10),
                Expanded(child: _buildImage(imageUrls[4])),
              ],
            ),
          ),

          // Extra rows when expanded
          if (isExpanded) ...[
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(flex: 2, child: _buildImage(imageUrls[0])),
                  SizedBox(width: 10),
                  Expanded(flex: 1, child: _buildImage(imageUrls[1])),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(child: _buildImage(imageUrls[2])),
                  SizedBox(width: 10),
                  Expanded(child: _buildImage(imageUrls[3])),
                  SizedBox(width: 10),
                  Expanded(child: _buildImage(imageUrls[4])),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget directionGoogleMaps() {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(30.7333, 76.7794),
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    );
  }
}
