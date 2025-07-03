import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

AppBar primaryAppBar({
  Color? backGroundColor,
  List<Widget>? action,
  bool? centerTitle,
  Widget? leading,
  double? leadingWidth,
  required Widget title,
  required BuildContext context,
  PreferredSizeWidget? bottom,
  bool showLeading = true, // NEW: control visibility of leading
}) {
  return AppBar(
    bottom: bottom,
    toolbarHeight: 50,
    leadingWidth: leadingWidth ?? Get.width * 0.15,
    centerTitle: centerTitle ?? false,
    automaticallyImplyLeading: false,

    leading: showLeading
        ? leading ??
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            color: Colors.transparent,
            height: 30,
            width: 40,
            child: Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 22,
            ),
          ),
        )
        : null, // hide leading if showLeading is false

    title: title,
    titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
      color: AppColors.blackColor,
      fontSize: 20,
    ),
    surfaceTintColor: Colors.transparent,
    backgroundColor: backGroundColor ?? Colors.transparent,
    elevation: 3,
    actionsPadding: EdgeInsets.only(right: Get.width * 0.03),
    actions: action,
  );
}
