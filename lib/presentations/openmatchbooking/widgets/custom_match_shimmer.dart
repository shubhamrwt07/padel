import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../configs/app_colors.dart';
class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textFieldColor,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.textFieldColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header (date + time)
            Row(
              children: [
                Container(height: 14, width: 60, color: Colors.white),
                const SizedBox(width: 8),
                Container(height: 14, width: 100, color: Colors.white),
              ],
            ),
            const SizedBox(height: 8),
            // 🔹 Sub-header (skill + gender)
            Row(
              children: [
                Container(height: 12, width: 40, color: Colors.white),
                const SizedBox(width: 6),
                Container(height: 12, width: 20, color: Colors.white),
                const SizedBox(width: 6),
                Container(height: 12, width: 40, color: Colors.white),
              ],
            ),
            const SizedBox(height: 12),
            // 🔹 Players row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                    (_) => Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(height: 10, width: 40, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(height: 12, width: 30, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 🔹 Footer (club + price)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: 100, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 10, width: 80, color: Colors.white),
                  ],
                ),
                Container(height: 14, width: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 
 