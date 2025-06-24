import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';

class AddReviewBottomSheet extends StatelessWidget {
  const AddReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Container(
        height: Get.height * 0.35,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    itemSize: 30,
                    initialRating: 3,
                    minRating: 0,
                    unratedColor: AppColors.starUnselectedColor,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.zero,
                    itemBuilder: (context, _) => Container(
                      width: 5.0,
                      height: 30.0,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.star,
                        size: 27.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    onRatingUpdate: (rating) {},
                  ).paddingOnly(right: Get.width * 0.02),
                  Text(
                    "4.5",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlackColor,
                    ),
                  )
                ],
              ),
              Text(
                "Write a message",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(bottom: Get.height * 0.01),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 6,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textFieldColor,
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textColor),
                    hintText: 'Write Here',
                  ),
                ),
              ).paddingOnly(bottom: Get.height*0.02),
              Center(
                child: PrimaryButton(
                    height: Get.height*0.05,
                    width: Get.width*0.6,
                    onTap: ()=>Get.back(), text: "Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}