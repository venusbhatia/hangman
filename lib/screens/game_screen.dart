import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import '../widgets/hangman_drawing.dart';
import '../widgets/letter_button.dart';
import '../widgets/status_bar.dart';
import '../widgets/letter_grid.dart';
import '../widgets/hangman_game_over.dart';
import '../l10n/app_localizations.dart';
import '../models/game_enums.dart';
import '../widgets/keyboard_layout.dart';

class GameScreen extends StatefulWidget {
  final String? category;
  final bool isDailyWord;

  const GameScreen({
    super.key,
    this.category,
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
        mode: widget.isDailyWord ? GameMode.dailyChallenge : GameMode.singlePlayer,
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
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
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
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'The word was: ${context.read<GameProvider>().word}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
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
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'OH\nNO!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
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
                                      'CONGRATULATIONS!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'You guessed: ${context.read<GameProvider>().word}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
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
                                              textColor: Colors.green.shade400,
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
                                              icon: Icons.home,
                                              label: 'HOME',
                                              backgroundColor: Colors.green.shade600,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                _isShowingGameOver = false;
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
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
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'YOU\nWON!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: textColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (isAd) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.stars, color: textColor, size: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    
    return WillPopScope(
      onWillPop: () async {
        if (gameProvider.currentMode == GameMode.custom) {
          return true;
        }
        return !gameProvider.isGameWon && !gameProvider.isGameOver;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(gameProvider.currentMode == GameMode.dailyChallenge 
            ? l10n.dailyChallenge 
            : l10n.appTitle),
          centerTitle: true,
          automaticallyImplyLeading: !gameProvider.isGameWon && !gameProvider.isGameOver,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.background,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    const StatusBar(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(height: 20),
                                  const HangmanDrawing(),
                                  const SizedBox(height: 40),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      gameProvider.maskedWord,
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        letterSpacing: 8,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: screenSize.height * 0.4,
                                      ),
                                      child: const KeyboardLayout(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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

  IconData _getCategoryIcon() {
    switch (widget.category?.toLowerCase()) {
      case 'countries':
        return Icons.flag;
      case 'technology':
        return Icons.computer;
      case 'music':
        return Icons.music_note;
      case 'movies':
        return Icons.movie;
      case 'sports':
        return Icons.sports_basketball;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.shuffle;
    }
  }
} 