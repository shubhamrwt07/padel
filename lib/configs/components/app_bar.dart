import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

AppBar primaryAppBar({
  Color?backGroundColor,
  List<Widget>? action,
  bool? centerTitle,
  Widget? leading,
  double? leadingWidth,
  required Widget title,
  required BuildContext context, bottom,

}) {
  return AppBar(
    bottom: bottom,
    toolbarHeight: 50,
    leadingWidth: leadingWidth??Get.width * 0.15,

    centerTitle: centerTitle??false,
    automaticallyImplyLeading: false,
    leading: leading,

    // leading: GestureDetector(
    //     onTap: (){
    //       Navigator.pop(context);
    //     },
    //     child:  Container(color: Colors.transparent,
    //         height: 30,
    //         width: 40,
    //         child:  Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.whiteColor,size: 18,))),
    title: title,
    titleTextStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(color: AppColors.blackColor,fontSize: 20),
    surfaceTintColor: Colors.transparent,
    backgroundColor: backGroundColor??AppColors.whiteColor,
    elevation: 3,

    actionsPadding: EdgeInsets.only(right: Get.width*0.03),
    actions: action,
  );
}