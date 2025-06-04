import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/game_provider.dart';

class HangmanDrawing extends StatefulWidget {
  const HangmanDrawing({super.key});

  @override
  State<HangmanDrawing> createState() => _HangmanDrawingState();
}

class _HangmanDrawingState extends State<HangmanDrawing> 
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late List<Animation<double>> _fadeAnimations;
  int _previousLives = 6;

  @override
  void initState() {
    super.initState();
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticOut,
      ),
    );

    // Create fade animations for each hangman part (6 parts total)
    _fadeAnimations = List.generate(6, (index) {
      final start = index / 6;
      final end = (index + 1) / 6;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final currentLives = gameProvider.lives;
        
        // Trigger animations when lives decrease
        if (currentLives < _previousLives) {
          _triggerShake();
          _fadeController.animateTo(1 - currentLives / 6);
        }
        _previousLives = currentLives;

        return AnimatedBuilder(
          animation: Listenable.merge([_shakeAnimation, _fadeController]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value * (1 - currentLives / 6), 0),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: CustomPaint(
                      painter: _HangmanPainter(
                        lives: currentLives,
                        fadeAnimations: _fadeAnimations,
                      ),
                      size: const Size(200, 200),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HangmanPainter extends CustomPainter {
  final int lives;
  final List<Animation<double>> fadeAnimations;

  _HangmanPainter({
    required this.lives,
    required this.fadeAnimations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base structure (always visible)
    _drawBase(canvas, size);
    _drawPole(canvas, size);
    _drawBeam(canvas, size);
    _drawRope(canvas, size);

    // Hangman parts (fade in as lives decrease)
    if (lives < 6) _drawHead(canvas, size, fadeAnimations[5].value);
    if (lives < 5) _drawBody(canvas, size, fadeAnimations[4].value);
    if (lives < 4) _drawLeftArm(canvas, size, fadeAnimations[3].value);
    if (lives < 3) _drawRightArm(canvas, size, fadeAnimations[2].value);
    if (lives < 2) _drawLeftLeg(canvas, size, fadeAnimations[1].value);
    if (lives < 1) _drawRightLeg(canvas, size, fadeAnimations[0].value);
  }

  void _drawBase(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.9, size.height * 0.9),
      paint,
    );
  }

  void _drawPole(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.9),
      Offset(size.width * 0.2, size.height * 0.1),
      paint,
    );
  }

  void _drawBeam(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.1),
      Offset(size.width * 0.6, size.height * 0.1),
      paint,
    );
  }

  void _drawRope(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.1),
      Offset(size.width * 0.6, size.height * 0.25),
      paint,
    );
  }

  void _drawHead(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30).withOpacity(opacity)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Head circle with gradient effect
    final center = Offset(size.width * 0.6, size.height * 0.35);
    final radius = size.width * 0.08;
    
    canvas.drawCircle(center, radius, paint);
    
    // Eyes (X marks)
    if (opacity > 0.5) {
      final eyePaint = Paint()
        ..color = const Color(0xFFFF3B30).withOpacity(opacity)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      
      // Left eye X
      canvas.drawLine(
        Offset(center.dx - radius * 0.4, center.dy - radius * 0.3),
        Offset(center.dx - radius * 0.1, center.dy - radius * 0.1),
        eyePaint,
      );
      canvas.drawLine(
        Offset(center.dx - radius * 0.1, center.dy - radius * 0.3),
        Offset(center.dx - radius * 0.4, center.dy - radius * 0.1),
        eyePaint,
      );
      
      // Right eye X
      canvas.drawLine(
        Offset(center.dx + radius * 0.1, center.dy - radius * 0.3),
        Offset(center.dx + radius * 0.4, center.dy - radius * 0.1),
        eyePaint,
      );
      canvas.drawLine(
        Offset(center.dx + radius * 0.4, center.dy - radius * 0.3),
        Offset(center.dx + radius * 0.1, center.dy - radius * 0.1),
        eyePaint,
      );
    }
  }

  void _drawBody(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30).withOpacity(opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.43),
      Offset(size.width * 0.6, size.height * 0.7),
      paint,
    );
  }

  void _drawLeftArm(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30).withOpacity(opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.45, size.height * 0.6),
      paint,
    );
  }

  void _drawRightArm(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30).withOpacity(opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.75, size.height * 0.6),
      paint,
    );
  }

  void _drawLeftLeg(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30).withOpacity(opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.7),
      Offset(size.width * 0.45, size.height * 0.85),
      paint,
    );
  }

  void _drawRightLeg(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = const Color(0xFFFF3B30).withOpacity(opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}