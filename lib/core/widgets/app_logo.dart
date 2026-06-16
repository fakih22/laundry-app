import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double fontSize;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showText = false,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoWidget = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );

    if (showText) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          const SizedBox(height: 12),
          Text(
            'LaundryKu',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF000666),
              letterSpacing: -0.5,
            ),
          ),
        ],
      );
    }

    return logoWidget;
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Draw background rounded rect
    final Paint bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      Radius.circular(width * 0.24),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Draw central translucent circle
    final Paint circlePaint = Paint()
      ..color = Colors.white.withAlpha(77) // 30% opacity
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), width * 0.1, circlePaint);

    // Draw wavy line path: M30 40 Q50 20 70 40 T70 60 T30 80
    // Scaling relative to viewBox (0 to 100)
    final double scaleX = width / 100.0;
    final double scaleY = height / 100.0;

    final Paint wavePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = width * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path wavePath = Path();
    wavePath.moveTo(30 * scaleX, 40 * scaleY);
    // Quadratic bezier curve from (30,40) with control point (50,20) to end point (70,40)
    wavePath.quadraticBezierTo(50 * scaleX, 20 * scaleY, 70 * scaleX, 40 * scaleY);
    // Transformed bezier segment (T70 60 -> end (70,60) reflection of control point)
    // T70 60 in SVG means a smooth cubic/quadratic curve to (70,60). Since previous is Q, T continues it.
    // In SVG, the control point is reflected from the previous curve's control point.
    // The previous control point is (50,20). End is (70,40). Reflected control point is (90,60).
    wavePath.quadraticBezierTo(90 * scaleX, 60 * scaleY, 70 * scaleX, 60 * scaleY);
    // T30 80 -> smooth curve to (30,80). Previous control point reflected (relative to 70,60) is (50,60).
    wavePath.quadraticBezierTo(50 * scaleX, 60 * scaleY, 30 * scaleX, 80 * scaleY);

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
