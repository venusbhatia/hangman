import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class LetterGrid extends StatefulWidget {
  const LetterGrid({super.key});

  @override
  State<LetterGrid> createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  final List<String> _letters = List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _letters.length,
      itemBuilder: (context, index) {
        final letter = _letters[index];
        return _LetterButton(
          key: ValueKey(letter),
          letter: letter,
        );
      },
    );
  }
}

class _LetterButton extends StatefulWidget {
  final String letter;

  const _LetterButton({
    required Key key,
    required this.letter,
  }) : super(key: key);

  @override
  State<_LetterButton> createState() => _LetterButtonState();
}

class _LetterButtonState extends State<_LetterButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final isGuessed = gameProvider.guessedLetters.contains(widget.letter.toLowerCase());
        final isCorrect = gameProvider.word.toLowerCase().contains(widget.letter.toLowerCase());
        final isGameOver = gameProvider.isGameOver || gameProvider.isGameWon;

        return GestureDetector(
          onTapDown: isGuessed || isGameOver ? null : _handleTapDown,
          onTapUp: isGuessed || isGameOver ? null : _handleTapUp,
          onTapCancel: isGuessed || isGameOver ? null : _handleTapCancel,
          onTap: isGuessed || isGameOver ? null : () {
            gameProvider.makeGuess(widget.letter);
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double scale = _scaleAnimation.value;
              if (_controller.status == AnimationStatus.forward) {
                scale = _scaleAnimation.value;
              } else if (_controller.status == AnimationStatus.reverse) {
                scale = _bounceAnimation.value;
              }

              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isGuessed
                    ? isCorrect
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2)
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isGuessed
                      ? isCorrect
                          ? Colors.green
                          : Colors.red
                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isGuessed ? Colors.transparent : Colors.black.withOpacity(0.1)),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.letter,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isGuessed
                        ? isCorrect
                            ? Colors.green
                            : Colors.red
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CrossPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CrossPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(strokeWidth, strokeWidth),
      Offset(size.width - strokeWidth, size.height - strokeWidth),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - strokeWidth, strokeWidth),
      Offset(strokeWidth, size.height - strokeWidth),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 