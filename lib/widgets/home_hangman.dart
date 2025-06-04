import 'package:flutter/material.dart';
import 'dart:ui';

class HomeHangman extends StatelessWidget {
  const HomeHangman({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomPaint(
      size: const Size(200, 200),
      painter: _HomeHangmanPainter(
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _HomeHangmanPainter extends CustomPainter {
  final Color color;

  _HomeHangmanPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw the complete hangman structure
    // Base
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.9, size.height * 0.9),
      paint,
    );

    // Vertical pole
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.9),
      Offset(size.width * 0.3, size.height * 0.1),
      paint,
    );

    // Horizontal beam
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.1),
      Offset(size.width * 0.7, size.height * 0.1),
      paint,
    );

    // Rope
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.7, size.height * 0.2),
      paint,
    );

    // Head
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.25),
      size.width * 0.05,
      paint,
    );

    // Body
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.5),
      paint,
    );

    // Left arm
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.4),
      paint,
    );

    // Right arm
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.4),
      paint,
    );

    // Left leg
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.6),
      paint,
    );

    // Right leg
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 