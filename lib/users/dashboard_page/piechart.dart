import 'dart:math';
import 'package:flutter/material.dart';

class RadialChallengesChart extends StatelessWidget {
  final Map<String, double> data;
  final double size;
  final Color centerColor;
  final List<Color>? circleColors;
  final Color arrowColor;

  const RadialChallengesChart({
    super.key,
    required this.data,
    this.size = 300,
    this.centerColor = Colors.blue,
    this.circleColors,
    this.arrowColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<double>(0, (a, b) => a + b);
    final entries = data.entries.toList();

    return Center(
      child: CustomPaint(
        size: Size(size, size / 1.6), // shorter height for semi-circle
        painter: _SemiRadialChallengesPainter(
          entries: entries,
          total: total,
          centerColor: centerColor,
          circleColors: circleColors,
          arrowColor: arrowColor,
        ),
      ),
    );
  }
}

class _SemiRadialChallengesPainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final double total;
  final Color centerColor;
  final List<Color>? circleColors;
  final Color arrowColor;

  _SemiRadialChallengesPainter({
    required this.entries,
    required this.total,
    required this.centerColor,
    required this.circleColors,
    required this.arrowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.9);
    final Paint paint = Paint()..isAntiAlias = true;

    // --- Center circle ---
    final double centerRadius = size.width * 0.15;
    paint.color = centerColor;
    canvas.drawCircle(center, centerRadius, paint);

    // --- Center text ---
    final textPainter = TextPainter(
      text: const TextSpan(
        text: "Challenges",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );

    // --- Draw semi-circle outer nodes ---
    final double outerRadius = size.width * 0.45;
    final double smallCircleRadius = size.width * 0.1;
    final double startAngle = -pi; // start from left
    final double sweep = pi; // semi-circle range

    for (int i = 0; i < entries.length; i++) {
      final double angle =
          startAngle + (sweep / (entries.length - 1)) * i; // distribute evenly
      final value = entries[i].value;
      final percent = ((value / total) * 100).toStringAsFixed(1);
      final circleColor = circleColors != null
          ? circleColors![i % circleColors!.length]
          : Colors.primaries[i % Colors.primaries.length];

      // Small circle position
      final smallCenter = Offset(
        center.dx + outerRadius * cos(angle),
        center.dy + outerRadius * sin(angle),
      );

      // Arrow start & end
      final arrowStart = Offset(
        center.dx + centerRadius * cos(angle),
        center.dy + centerRadius * sin(angle),
      );
      final arrowEnd = Offset(
        center.dx + (outerRadius - smallCircleRadius * 0.8) * cos(angle),
        center.dy + (outerRadius - smallCircleRadius * 0.8) * sin(angle),
      );

      // Arrow line
      paint
        ..color = arrowColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(arrowStart, arrowEnd, paint);

      // Arrow head
      const double arrowHeadSize = 6;
      final path = Path();
      path.moveTo(arrowEnd.dx, arrowEnd.dy);
      path.lineTo(
        arrowEnd.dx - arrowHeadSize * cos(angle - pi / 6),
        arrowEnd.dy - arrowHeadSize * sin(angle - pi / 6),
      );
      path.moveTo(arrowEnd.dx, arrowEnd.dy);
      path.lineTo(
        arrowEnd.dx - arrowHeadSize * cos(angle + pi / 6),
        arrowEnd.dy - arrowHeadSize * sin(angle + pi / 6),
      );
      canvas.drawPath(path, paint);

      // Small circle
      paint
        ..color = circleColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(smallCenter, smallCircleRadius, paint);

      // Label + percentage inside
      final labelPainter = TextPainter(
        text: TextSpan(
          text: "${entries[i].key}\n$percent%",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout(maxWidth: smallCircleRadius * 2);
      labelPainter.paint(
        canvas,
        Offset(
          smallCenter.dx - labelPainter.width / 2,
          smallCenter.dy - labelPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
