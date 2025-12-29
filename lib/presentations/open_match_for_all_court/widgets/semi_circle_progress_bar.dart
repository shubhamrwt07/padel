import 'dart:math';

import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/app_colors.dart';
class BlockSemiCirclePainter extends CustomPainter {
  final double progress;

  BlockSemiCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.2;

    const int totalBlocks = 20;
    final int activeBlocks = (totalBlocks * progress).round();

    const double blockWidth = 8;
    const double blockHeight = 22;

    // Exact half-circle
    final double totalSweep = pi;

    // Angle per block including spacing
    final double angleStep = totalSweep / totalBlocks;

    // START ANGLE so arc is centered perfectly
    final double startAngle = pi + (angleStep / 2);

    final Paint activePaint = Paint()
      ..color = AppColors.primaryColor;

    final Paint inactivePaint = Paint()
      ..color = Colors.black12;

    for (int i = 0; i < totalBlocks; i++) {
      final angle = startAngle + (i * angleStep);

      final paint = i < activeBlocks ? activePaint : inactivePaint;

      canvas.save();

      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);

      canvas.translate(dx, dy);
      canvas.rotate(angle + pi / 2);

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: blockWidth,
          height: blockHeight,
        ),
        const Radius.circular(6),
      );

      canvas.drawRRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}