import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final double? width, height;
  Color? backGroundColor = Colors.red;
      Color? rippleColor;
   Function onTap;
   PrimaryButton({
    super.key,
    this.width,
    this.height,
    this.backGroundColor,
     this.rippleColor,
    required this.onTap,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12 ),
      onTap: () {
          onTap();

      },
      child: Container(
        height: height ?? Get.height * 0.055,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: child
        ),
      ),
    );
  }
}
///