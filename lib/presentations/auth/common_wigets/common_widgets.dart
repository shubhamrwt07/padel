import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';

Widget socialContainer(String imagePath){
  return Container(
      height: 44,
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            imagePath,
          ),
        ],
      )
  ).paddingOnly(right: 10);
}