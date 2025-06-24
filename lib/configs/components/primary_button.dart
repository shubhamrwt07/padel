import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final double? width, height;
  final Widget? child;
  final String text;
  final TextStyle? textStyle;
  final Function onTap;
   const PrimaryButton({
    super.key,
    this.width,
    this.height,
     this.child,
    required this.onTap, required this.text, this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12 ),
      onTap: () {
          onTap();
      },
      child: Container(
        height:height?? 50,
        width: width??Get.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3DBE64), Color(0xFF1F41BB)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child:child?? Text(
            text,
            style:textStyle?? Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.whiteColor,fontSize: 18)
        ),
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  final double? width, height;
  final String text;
  final TextStyle? textStyle;
  final Function onTap;
  CartButton({
    super.key,
    this.width,
    this.height,
    required this.onTap, required this.text, this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12 ),
      onTap: () {
        onTap();
      },
      child: Container(
        height:height?? 60,
        width: width??Get.width,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3DBE64), Color(0xFF1F41BB)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                text,
                style:textStyle?? Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.whiteColor,fontSize: 9)
            ).paddingOnly(left: Get.width*0.02),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFF3DBE64),
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF2556DA), width: 1),
              ),
              child: const Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
