import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import '../widgets/keyboard.dart';
import '../widgets/hangman_game_over.dart';
import '../models/game_enums.dart';
import '../l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  final String? category;
  final bool isMultiplayer;
  final bool isDailyWord;

  const GameScreen({
    super.key,
    this.category,
    this.isMultiplayer = false,
    this.isDailyWord = false,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isShowingGameOver = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.initGame(
        category: _getCategoryFromString(widget.category),
      );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context);
    
    // Check for game over conditions
    if ((gameProvider.isGameWon || gameProvider.isGameOver) && !_isShowingGameOver) {
      _isShowingGameOver = true;
      if (gameProvider.isGameWon) {
        _confettiController.play();
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showGameOverDialog(gameProvider.isGameWon);
        }
      });
    }
  }

  GameCategory? _getCategoryFromString(String? category) {
    if (category == null) return null;
    try {
      return GameCategory.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == category.toLowerCase()
      );
    } catch (_) {
      return null;
    }
  }

  void _showGameOverDialog(bool won) {
    _animationController.forward(from: 0.0);
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => PopScope(
        canPop: false,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!won) ...[
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 80),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30),
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 40),
                                HangmanGameOver(
                                  color: Colors.white,
                                  size: 120,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'OHH... YOU LOST',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'The word was: ${context.read<GameProvider>().word}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildGameOverButton(
                                          icon: Icons.refresh,
                                          label: 'NEXT ROUND',
                                          backgroundColor: Colors.white,
                                          textColor: Colors.red.shade400,
                                          onPressed: () {
                                            _isShowingGameOver = false;
                                            Navigator.of(context).pop();
                                            context.read<GameProvider>().initGame();
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildGameOverButton(
                                          icon: Icons.favorite,
                                          label: 'KEEP STREAK',
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          isAd: true,
                                          onPressed: () {
                                            _isShowingGameOver = false;
                                            Navigator.of(context).pop();
                                            context.read<GameProvider>().keepStreak();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                'OH\nNO!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 80),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30),
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'WELL DONE!',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.stars_rounded,
                                      color: Colors.amber.shade300,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '+${context.read<GameProvider>().streak * 10}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildGameOverButton(
                                  icon: Icons.play_arrow,
                                  label: 'NEXT WORD',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.green.shade400,
                                  onPressed: () {
                                    _isShowingGameOver = false;
                                    Navigator.of(context).pop();
                                    context.read<GameProvider>().initGame();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emoji_events_rounded,
                                color: Colors.amber,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    bool isAd = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isAd) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'AD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Game?'),
            content: const Text('Are you sure you want to quit this game?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('QUIT'),
              ),
            ],
          ),
        );
        
        if (shouldPop ?? false) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade800,
                Colors.blue.shade700,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Floating back button
                Positioned(
                  top: 16,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
                          onPressed: () async {
                            final shouldPop = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Exit Game?'),
                                content: const Text('Are you sure you want to quit this game?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('QUIT'),
                                  ),
                                ],
                              ),
                            );
                            if (mounted && (shouldPop ?? false)) {
                              Navigator.of(context).pop();
                            }
                          },
                          tooltip: 'Back',
                        ),
                      ),
                    ),
                  ),
                ),
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 70), // More space for back button
                    _buildStatusBar(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHangmanDrawing(),
                          const SizedBox(height: 40),
                          _buildWordDisplay(),
                        ],
                      ),
                    ),
                    // Fixed keyboard at bottom
                    Consumer<GameProvider>(
                      builder: (context, gameProvider, _) => Keyboard(
                        onKeyPressed: gameProvider.makeGuess,
                        usedLetters: gameProvider.guessedLetters.toSet(),
                        word: gameProvider.word,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Consumer<GameProvider>(
        builder: (context, gameProvider, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusItem(
              icon: Icons.favorite,
              value: gameProvider.lives.toString(),
              label: AppLocalizations.of(context).lives,
              color: Colors.redAccent,
            ),
            Container(
              width: 1,
              height: 32,
              color: Colors.white.withOpacity(0.2),
            ),
            _buildStatusItem(
              icon: Icons.local_fire_department,
              value: gameProvider.streak.toString(),
              label: AppLocalizations.of(context).streak,
              color: Colors.orangeAccent,
            ),
            Container(
              width: 1,
              height: 32,
              color: Colors.white.withOpacity(0.2),
            ),
            _buildStatusItem(
              icon: Icons.star,
              value: gameProvider.coins.toString(),
              label: 'Score',
              color: Colors.yellowAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHangmanDrawing() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        // Calculate wrong guesses from lives (starting from 6 lives)
        final wrongGuesses = 6 - gameProvider.lives;
        return Container(
          height: 250,
          width: 200,
          child: CustomPaint(
            size: const Size(200, 250),
            painter: HangmanPainter(
              wrongGuesses: wrongGuesses,
              color: Colors.white,
              strokeWidth: 4,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordDisplay() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final displayText = gameProvider.maskedWord.isEmpty ? '_ _ _ _ _ _' : gameProvider.maskedWord;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            displayText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class HangmanPainter extends CustomPainter {
  final int wrongGuesses;
  final Color color;
  final double strokeWidth;

  HangmanPainter({
    required this.wrongGuesses,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;
    
    // Base (1st wrong guess)
    if (wrongGuesses >= 1) {
      canvas.drawLine(
        Offset(width * 0.1, height * 0.9),
        Offset(width * 0.9, height * 0.9),
        paint,
      );
    }

    // Vertical pole (2nd wrong guess)
    if (wrongGuesses >= 2) {
      canvas.drawLine(
        Offset(width * 0.5, height * 0.9),
        Offset(width * 0.5, height * 0.1),
        paint,
      );
    }

    // Top horizontal and rope (3rd wrong guess)
    if (wrongGuesses >= 3) {
      canvas.drawLine(
        Offset(width * 0.5, height * 0.1),
        Offset(width * 0.65, height * 0.1),
        paint,
      );
      // Rope
      canvas.drawLine(
        Offset(width * 0.65, height * 0.1),
        Offset(width * 0.65, height * 0.2),
        paint,
      );
    }

    // Head (4th wrong guess)
    if (wrongGuesses >= 4) {
      canvas.drawCircle(
        Offset(width * 0.65, height * 0.25),
        width * 0.07,
        paint,
      );
    }

    // Body (5th wrong guess)
    if (wrongGuesses >= 5) {
      canvas.drawLine(
        Offset(width * 0.65, height * 0.32),
        Offset(width * 0.65, height * 0.5),
        paint,
      );
    }

    // Arms and legs (6th wrong guess - final)
    if (wrongGuesses >= 6) {
      // Left arm
      canvas.drawLine(
        Offset(width * 0.65, height * 0.35),
        Offset(width * 0.55, height * 0.45),
        paint,
      );
      // Right arm
      canvas.drawLine(
        Offset(width * 0.65, height * 0.35),
        Offset(width * 0.75, height * 0.45),
        paint,
      );
      // Left leg
      canvas.drawLine(
        Offset(width * 0.65, height * 0.5),
        Offset(width * 0.55, height * 0.65),
        paint,
      );
      // Right leg
      canvas.drawLine(
        Offset(width * 0.65, height * 0.5),
        Offset(width * 0.75, height * 0.65),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}