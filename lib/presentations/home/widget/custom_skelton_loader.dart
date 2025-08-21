import"package:flutter/material.dart";
import "package:shimmer/shimmer.dart";
import"package:get/get.dart";
Widget bookingShimmer() {
  return SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 2, // Number of shimmer cards
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 230,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Circle shimmer (club image)
                    Container(
                      height: 34,
                      width: 34,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    // Club name + city shimmer
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: Get.width * 0.25,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: Get.width * 0.20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    // Rating & direction shimmer
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 10,
                          width: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                // Date & slot shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 10,
                      width: 80,
                      color: Colors.white,
                    ),
                    Container(
                      height: 10,
                      width: 40,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}