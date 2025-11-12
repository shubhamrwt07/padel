import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class CourtSlotsShimmer extends StatelessWidget {
  const CourtSlotsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(2, (courtIndex) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Court Header Placeholder
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 50,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                /// Slots Grid Placeholder
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 8, // fake 8 slots
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.8,
                    ),
                    itemBuilder: (_, __) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}