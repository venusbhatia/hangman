import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import '../widgets/status_bar.dart';
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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  bool _isShowingGameOver = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
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
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context);
    
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
      barrierColor: Colors.black26,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 32),
              child: _buildGameOverContent(won),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverContent(bool won) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: won 
                    ? [const Color(0xFF34C759), const Color(0xFF30D158)]
                    : [const Color(0xFFFF3B30), const Color(0xFFFF453A)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: won 
                      ? const Color(0xFF34C759).withOpacity(0.3)
                      : const Color(0xFFFF3B30).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              won ? Icons.check_rounded : Icons.close_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            won ? 'Fantastic!' : 'Nice Try!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            won 
                ? 'You guessed: ${context.read<GameProvider>().word}'
                : 'The word was: ${context.read<GameProvider>().word}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color(0xFF3C3C43),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              Expanded(
                child: _buildDialogButton(
                  title: 'Next Round',
                  isPrimary: true,
                  onPressed: () {
                    _isShowingGameOver = false;
                    Navigator.of(context).pop();
                    context.read<GameProvider>().initGame();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDialogButton(
                  title: won ? 'Home' : 'Keep Streak',
                  isPrimary: false,
                  onPressed: () {
                    _isShowingGameOver = false;
                    Navigator.of(context).pop();
                    if (won) {
                      Navigator.of(context).pop();
                    } else {
                      context.read<GameProvider>().keepStreak();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton({
    required String title,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary 
                ? const Color(0xFF007AFF)
                : const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isPrimary ? [
              BoxShadow(
                color: const Color(0xFF007AFF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ] : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : const Color(0xFF007AFF),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l10n = AppLocalizations.of(context);
    
    return WillPopScope(
      onWillPop: () async {
        if (gameProvider.currentMode == GameMode.custom) {
          return true;
        }
        return !gameProvider.isGameWon && !gameProvider.isGameOver;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2F2F7),
          elevation: 0,
          leading: (!gameProvider.isGameWon && !gameProvider.isGameOver) 
              ? _buildBackButton() 
              : null,
          title: Text(
            gameProvider.currentMode == GameMode.dailyChallenge 
                ? l10n.dailyChallenge 
                : l10n.appTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Status bar
                    const StatusBar(),
                    
                    const SizedBox(height: 32),
                    
                    // Word display with elegant design
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: gameProvider.isGameWon ? _pulseAnimation.value : 1.0,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  gameProvider.maskedWord,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: gameProvider.isGameWon 
                                        ? const Color(0xFF34C759)
                                        : const Color(0xFF1C1C1E),
                                    letterSpacing: 4,
                                  ),
                                ),
                                
                                if (gameProvider.isGameWon) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF34C759), Color(0xFF30D158)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Completed!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Game progress indicator
                    _buildProgressIndicator(gameProvider),
                    
                    const SizedBox(height: 32),
                    
                    // Keyboard
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const KeyboardLayout(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Confetti overlay
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
                  colors: const [
                    Color(0xFF007AFF),
                    Color(0xFF34C759),
                    Color(0xFFFF9500),
                    Color(0xFFFF3B30),
                    Color(0xFF5856D6),
                    Color(0xFFFF2D92),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF007AFF),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(GameProvider gameProvider) {
    final wrongGuesses = 6 - gameProvider.lives;
    final progressPercentage = wrongGuesses / 6;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1C1E).withOpacity(0.8),
                ),
              ),
              Text(
                '${gameProvider.lives} lives left',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: gameProvider.lives <= 2 
                      ? const Color(0xFFFF3B30)
                      : const Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressPercentage,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: progressPercentage > 0.8
                        ? [const Color(0xFFFF3B30), const Color(0xFFFF453A)]
                        : progressPercentage > 0.6
                            ? [const Color(0xFFFF9500), const Color(0xFFFFCC02)]
                            : [const Color(0xFF34C759), const Color(0xFF30D158)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}