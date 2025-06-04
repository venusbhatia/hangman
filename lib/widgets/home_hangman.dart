import 'package:flutter/material.dart';

class HomeHangman extends StatelessWidget {
  const HomeHangman({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 250),
      painter: _HomeHangmanPainter(),
    );
  }
}

class _HomeHangmanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF4D6D)  // Match your app's theme color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Calculate dimensions
    final double width = size.width;
    final double height = size.height;
    final double baseWidth = width * 0.8;
    final double poleHeight = height * 0.7;
    final double crossBeamWidth = width * 0.6;
    final double ropeLength = height * 0.15;

    // Draw base line with decorative support
    final basePath = Path()
      ..moveTo((width - baseWidth) / 2, height)
      ..lineTo((width + baseWidth) / 2, height);
    
    // Add decorative support at the base
    final supportPath = Path()
      ..moveTo(width * 0.3 - 15, height)
      ..lineTo(width * 0.3, height - 20)
      ..lineTo(width * 0.3 + 15, height);
    
    canvas.drawPath(basePath, paint);
    canvas.drawPath(supportPath, paint);

    // Draw vertical pole
    canvas.drawLine(
      Offset(width * 0.3, height),
      Offset(width * 0.3, height - poleHeight),
      paint,
    );

    // Draw cross beam
    canvas.drawLine(
      Offset(width * 0.3, height - poleHeight),
      Offset(width * 0.3 + crossBeamWidth, height - poleHeight),
      paint,
    );

    // Draw rope
    canvas.drawLine(
      Offset(width * 0.3 + crossBeamWidth * 0.8, height - poleHeight),
      Offset(width * 0.3 + crossBeamWidth * 0.8, height - poleHeight + ropeLength),
      paint,
    );

    // Draw stick figure
    final centerX = width * 0.3 + crossBeamWidth * 0.8;
    final headTop = height - poleHeight + ropeLength;
    final headRadius = width * 0.08;
    
    // Head
    canvas.drawCircle(
      Offset(centerX, headTop + headRadius),
      headRadius,
      paint,
    );

    // Body
    final bodyStart = headTop + headRadius * 2;
    final bodyLength = height * 0.2;
    canvas.drawLine(
      Offset(centerX, bodyStart),
      Offset(centerX, bodyStart + bodyLength),
      paint,
    );

    // Arms
    final armsY = bodyStart + bodyLength * 0.2;
    final armLength = width * 0.12;
    canvas.drawLine(
      Offset(centerX - armLength, armsY),
      Offset(centerX + armLength, armsY),
      paint,
    );

    // Legs
    final legsStart = bodyStart + bodyLength;
    final legLength = height * 0.15;
    canvas.drawLine(
      Offset(centerX, legsStart),
      Offset(centerX - armLength, legsStart + legLength),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, legsStart),
      Offset(centerX + armLength, legsStart + legLength),
      paint,
    );

    // Add small decorative element at the top joint
    final jointRadius = paint.strokeWidth / 2;
    canvas.drawCircle(
      Offset(width * 0.3 + crossBeamWidth * 0.8, height - poleHeight),
      jointRadius,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 