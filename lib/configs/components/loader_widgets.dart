import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';


class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;
  const LoadingWidget({super.key, this.size = 36.0,this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Platform.isIOS
          ?   CupertinoActivityIndicator(
        radius:14,
        color:color?? AppColors.whiteColor,
      )
          :   CircularProgressIndicator(
        strokeWidth: 3.0,
        color:color?? AppColors.whiteColor,
      ),
    );
  }
}