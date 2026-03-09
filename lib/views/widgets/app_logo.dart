import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96, this.showLabel = true});

  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final cutoutColor = Theme.of(context).scaffoldBackgroundColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _AppLogoPainter(cutoutColor: cutoutColor),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            'Ndaku',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _AppLogoPainter extends CustomPainter {
  _AppLogoPainter({required this.cutoutColor});

  final Color cutoutColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final orange = Paint()
      ..color = AppColors.logoOrange
      ..style = PaintingStyle.fill;
    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final cut = Paint()
      ..color = cutoutColor
      ..style = PaintingStyle.fill;

    final roof = Path()
      ..moveTo(w * 0.08, h * 0.46)
      ..lineTo(w * 0.50, h * 0.11)
      ..lineTo(w * 0.92, h * 0.46)
      ..quadraticBezierTo(w * 0.91, h * 0.50, w * 0.84, h * 0.50)
      ..lineTo(w * 0.80, h * 0.50)
      ..lineTo(w * 0.80, h * 0.62)
      ..lineTo(w * 0.20, h * 0.62)
      ..lineTo(w * 0.20, h * 0.50)
      ..lineTo(w * 0.16, h * 0.50)
      ..quadraticBezierTo(w * 0.09, h * 0.50, w * 0.08, h * 0.46)
      ..close();
    canvas.drawPath(roof, orange);

    final outerCenter = Offset(w * 0.50, h * 0.67);
    final outerRadius = w * 0.29;
    canvas.drawCircle(outerCenter, outerRadius, orange);

    canvas.drawCircle(outerCenter, w * 0.155, black);
    canvas.drawCircle(outerCenter, w * 0.095, orange);

    final cutoutPath = Path()
      ..moveTo(w * 0.20, h * 0.90)
      ..lineTo(w * 0.30, h * 0.82)
      ..arcToPoint(
        Offset(w * 0.38, h * 0.73),
        radius: Radius.circular(w * 0.10),
        clockwise: false,
      )
      ..lineTo(w * 0.25, h * 0.66)
      ..close();
    canvas.drawPath(cutoutPath, cut);
  }

  @override
  bool shouldRepaint(covariant _AppLogoPainter oldDelegate) {
    return oldDelegate.cutoutColor != cutoutColor;
  }
}
