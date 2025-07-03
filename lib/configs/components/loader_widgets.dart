
import '../../presentations/auth/login/widgets/login_exports.dart';
import 'dart:math' as math;
class AppLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Duration duration;

  const AppLoader({
    super.key,
    this.size = 80.0,
    this.strokeWidth = 6.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: CustomPaint(
                painter: SmoothWhitePainter(
                  strokeWidth: widget.strokeWidth,
                ),
                size: Size(widget.size, widget.size),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SmoothWhitePainter extends CustomPainter {
  final double strokeWidth;

  SmoothWhitePainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create smooth gradient from transparent to white
    final gradient = SweepGradient(
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(0.1),
        Colors.white.withOpacity(0.3),
        Colors.white.withOpacity(0.6),
        Colors.white.withOpacity(0.9),
        Colors.white,
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      startAngle: 0.0,
      endAngle: math.pi * 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw complete circle with gradient
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative version with arc instead of full circle
class SmoothArcLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Duration duration;

  const SmoothArcLoader({
    super.key,
    this.size = 80.0,
    this.strokeWidth = 6.0,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<SmoothArcLoader> createState() => _SmoothArcLoaderState();
}

class _SmoothArcLoaderState extends State<SmoothArcLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: CustomPaint(
                painter: SmoothArcPainter(
                  strokeWidth: widget.strokeWidth,
                ),
                size: Size(widget.size, widget.size),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SmoothArcPainter extends CustomPainter {
  final double strokeWidth;

  SmoothArcPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create paint for main arc
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw main bright arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      math.pi * 1.2, // About 3/4 of circle
      false,
      paint,
    );

    // Add fading tail
    final fadePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + math.pi * 1.2,
      math.pi * 0.3,
      false,
      fadePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}