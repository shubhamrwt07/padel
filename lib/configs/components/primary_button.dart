import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final double? width, height;
  final Widget? child;
  final String text;
   Function onTap;
   PrimaryButton({
    super.key,
    this.width,
    this.height,
     this.child,
    required this.onTap, required this.text,
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
        child:child?? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 5,width: 5,),
            Text(
                text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.whiteColor)
            ).paddingOnly(left: Get.width*0.08),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF3DBE64),
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF2556DA), width: 1),
              ),
              child: const Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
///