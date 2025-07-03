import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final int? maxLength;
  final int? maxLine;
  final int? minLine;
  final double? width,height;
  final BoxBorder? border;
  final Color? color;
  final bool? enabled;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final TextEditingController? controller;
  final  void Function(String) onChanged;   final  TapRegionCallback? onTabOutSide;
  final TextStyle? hintStyle;
  const SearchField({
    super.key,
    required this.hintText,
    this.maxLength,
    this.maxLine,
    this.minLine,
    this.width,
    this.height,
    this.border,
    this.controller,
    this.color,
    this.enabled = true,
    this.style, this.prefixIcon,
    required this.onChanged,
    this.onTabOutSide,
    this.suffixIcon,
    this.suffix,this.hintStyle
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: width ?? Get.width,

      child: TextField(
        onTapOutside: onTabOutSide,
        controller: controller,
        enabled: enabled,
        maxLength: maxLength,
        style: style ?? Theme.of(context)
            .textTheme.labelLarge!.copyWith(color: AppColors.textColor,fontSize: 12),
        keyboardType: TextInputType.text,
        maxLines: maxLine,
        minLines: minLine,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffix: suffix,
          counterText: "",
          hintText: hintText,
          hintStyle:hintStyle?? Theme.of(context)
              .textTheme.labelLarge!
              .copyWith(color: AppColors.textColor),
          filled: true,
          fillColor: color ?? Color(0XFFF6F8FF),
          contentPadding:
          EdgeInsets.symmetric(vertical: Get.height * .005, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );



  }
}