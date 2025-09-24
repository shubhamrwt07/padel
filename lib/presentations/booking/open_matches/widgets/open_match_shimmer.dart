import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
Widget buildMatchCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: Colors.white,
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10, right: 15, left: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 12,
                            width: 60,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 16,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 10,
                            width: 40,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Players shimmer row
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Team A placeholders
                  _circleShimmer(),
                  _circleShimmer(),

                  // Divider
                  VerticalDivider(
                    color: AppColors.greyColor,
                    thickness: 1.5,
                    width: 0,
                  ),

                  // Team B placeholders
                  _circleShimmer(),
                  _circleShimmer(),
                ],
              ),
            ),
          ),

          Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),

          // Footer shimmer
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 12, left: 15, right: 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 100,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 120,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: Get.width * .22,
                  height: 30,
                  color: Colors.grey,
                ).paddingOnly(right: 10),
              ],
            ),
          ),
        ],
      ),
    ),
  ).paddingOnly(bottom: 12);
}

Widget _circleShimmer() {
  return Column(
    children: [
      Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 14,
        width: 60,
        color: Colors.grey,
      ),
    ],
  );
}
