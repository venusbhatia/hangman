import 'package:flutter/material.dart';

class HangmanGameOver extends StatelessWidget {
  final Color color;
  final double size;

  const HangmanGameOver({
    super.key,
    required this.color,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HangmanGameOverPainter(color: color),
    );
  }
}

class _HangmanGameOverPainter extends CustomPainter {
  final Color color;

  _HangmanGameOverPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw base
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.9, size.height * 0.9),
      paint,
    );

    // Draw vertical pole
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.9),
      Offset(size.width * 0.3, size.height * 0.1),
      paint,
    );

    // Draw horizontal beam
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.1),
      Offset(size.width * 0.7, size.height * 0.1),
      paint,
    );

    // Draw rope
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.7, size.height * 0.2),
      paint,
    );

    // Draw head
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      size.width * 0.1,
      paint,
    );

    // Draw body
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.6),
      paint,
    );

    // Draw left arm
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.5),
      paint,
    );

    // Draw right arm
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.45),
      Offset(size.width * 0.9, size.height * 0.5),
      paint,
    );

    // Draw left leg
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.8),
      paint,
    );

    // Draw right leg
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.8),
      paint,
    );

    // Draw X eyes
    final eyePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Left eye X
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.25),
      Offset(size.width * 0.68, size.height * 0.28),
      eyePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.25),
      Offset(size.width * 0.65, size.height * 0.28),
      eyePaint,
    );

    // Right eye X
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.28),
      eyePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width * 0.72, size.height * 0.28),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 