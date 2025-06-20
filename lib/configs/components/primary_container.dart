import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/generated/assets.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  const PrimaryContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Assets.imagesImgBackground))
      ),
      child: child,
    );
  }
}
