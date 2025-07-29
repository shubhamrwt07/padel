import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentations/auth/forgot_password/widgets/forgot_password_exports.dart';
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
  SystemUiOverlayStyle? systemOverlayStyle,
  Color? titleTextColor,
  Color? leadingButtonColor,
  bool showLeading = true, // NEW: control visibility of leading
}) {
  return AppBar(
    systemOverlayStyle: systemOverlayStyle,
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
              color:leadingButtonColor?? AppColors.blackColor,
              size: 22,
            ),
          ),
        )
        : null, // hide leading if showLeading is false

    title: title,
    titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
      color:titleTextColor?? AppColors.blackColor,
      fontSize: 20,
    ),
    surfaceTintColor: Colors.transparent,
    backgroundColor: backGroundColor ?? Colors.transparent,
    elevation: 3,
    actionsPadding: EdgeInsets.only(right: Get.width * 0.03),
    actions: action,
  );
}
