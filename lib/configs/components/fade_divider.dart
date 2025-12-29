import'package:flutter/material.dart';
Widget fadeDivider() {
  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.grey,
          Colors.transparent,
        ],
      ),
    ),
  );
}