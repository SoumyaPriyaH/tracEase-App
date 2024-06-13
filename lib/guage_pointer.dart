import 'package:flutter/material.dart';
import 'dart:math';

class GaugePainter extends CustomPainter {
  final double distance;
  final double maxDistance;

  GaugePainter({required this.distance, this.maxDistance = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawCircle(center, radius, paint);

    final angle = (distance / maxDistance) * pi; // Convert distance to radians
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final needleLength = radius - 10;
    final needleEnd = Offset(
      center.dx + needleLength * -cos(angle),
      center.dy + needleLength * -sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw distance text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${distance.toStringAsFixed(2)} m',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textOffset = Offset(
      needleEnd.dx - textPainter.width / 2,
      needleEnd.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
