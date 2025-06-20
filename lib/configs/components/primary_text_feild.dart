import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final int? maxLength;
  final int? maxLine;
  final int? minLine;
  final double? width,height;
  final BoxBorder? border;
  final Color? color;
  final bool? enabled;
  final TextStyle? style;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? action;
  final List<TextInputFormatter>?formatter;
  final Function(String)? onChanged;
  final String? prefixText;
  final Widget? prefix;
  final Widget? prefixIcon;
  final EdgeInsets? scrollPadding;
  const PrimaryTextField({
    super.key,
    this.action,
    this.onFieldSubmitted,
    required this.hintText,
    this.maxLength,
    this.maxLine,
    this.minLine,
    this.width,
    this.formatter,
    this.focusNode,
    this.height,
    this.border,
    this.color,
    this.enabled = true,
    this.style,
    this.suffixIcon,
    this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.onChanged,
    this.prefixText,
    this.prefix,this.prefixIcon, this.scrollPadding
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??50,
      width: width?? Get.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:border??Border.all(color: AppColors.blackColor,),
        shape: BoxShape.rectangle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          scrollPadding: scrollPadding?? const EdgeInsets.all(0),
          inputFormatters: formatter,
          onSubmitted:onFieldSubmitted ,
          readOnly: readOnly??false,
          controller: controller,
          enabled: enabled,
          maxLength: maxLength,
          style:style?? Theme.of(context)
              .textTheme.labelSmall!.copyWith(color: AppColors.blackColor),
          keyboardType: keyboardType??TextInputType.text,
          maxLines: maxLine,
          minLines: minLine,
          onChanged:  onChanged,
          textInputAction:action,
          decoration: InputDecoration(
            suffixIcon:suffixIcon,
            prefixText:prefixText,
            prefix:prefix ,
            prefixIcon: prefixIcon,
            contentPadding: EdgeInsets.only(left: Get.width*0.02),
            counterText: "",
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.blackColor),
            border: InputBorder.none,
            fillColor: color??AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}