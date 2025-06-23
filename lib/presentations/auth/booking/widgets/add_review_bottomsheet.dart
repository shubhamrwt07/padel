import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';

class AddReviewBottomSheet extends StatelessWidget {
  const AddReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      padding:  EdgeInsets.all(25),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rate this Court", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.labelBlackColor)).paddingOnly(bottom: Get.height*0.01),
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
                itemPadding: EdgeInsets.zero, // No padding
                itemBuilder: (context, _) => Container(
                  width: 5.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.star,
                    size:27.0, // Adjust the size if needed
                    color: AppColors.secondaryColor,
                  ),
                ),
                onRatingUpdate: (rating) {
                },
              ).paddingOnly(right: Get.width*0.02),
              Text(
                "4.5",
                style:  Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500,color: AppColors.labelBlackColor),
              )
            ],
          ),
          Text(
            "Write a message",
            style:  Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600,color: AppColors.labelBlackColor),
          ).paddingOnly(bottom:Get.height*0.01),
          PrimaryTextField(
            height: Get.height*0.12,
            minLine: 5,
              hintText: "Write Here",
          ),
           SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // handle submit
                Get.back();
              },
              child:  Text("Submit"),
            ),
          )
        ],
      ),
    );
  }
}
