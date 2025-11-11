import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class AddReviewBottomSheet extends StatelessWidget {
  final HomeContentController controller = Get.put(HomeContentController());
  AddReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Container(
        // height: Get.height * 0.35,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rate this Court", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.labelBlackColor))
                  .paddingOnly(bottom: Get.height * 0.01),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KeyedSubtree(
                key: ValueKey(controller.reviewRating.value),
                child: RatingBar.builder(
                  itemSize: 30,
                  initialRating: controller.reviewRating.value,
                  minRating: 0,
                  unratedColor: AppColors.starUnselectedColor,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.zero,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 27.0,
                    color: AppColors.secondaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    controller.reviewRating.value = rating;
                  },
                ),
              ).paddingOnly(right: Get.width * 0.02),

              Text(
                controller.reviewRating.value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelBlackColor,
                ),
              ),
            ],
          )),
          Text(
                "Write a message",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(bottom: Get.height * 0.01),
              PrimaryTextField(
                hintText: "Write here",
                maxLine: 4,
                controller: controller.reviewController,
              ).paddingOnly(bottom: Get.height*0.02),
              Center(
                child: PrimaryButton(
                    height: Get.height*0.05,
                    width: Get.width*0.6,
                    onTap: (){
                      Get.back();
                      controller.createReview();
                    },
                    text: "Submit",
                  // child: controller.isLoading.value
                  //     ? AppLoader(size: 35, strokeWidth: 4)
                  //     : null,
                ),
              )
            ],
          ).paddingOnly(bottom: 10),
        ),
      ),
    );
  }
}