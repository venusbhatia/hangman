import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/game_provider.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  int _previousLives = 6;
  int _previousStreak = 0;
  int _previousCoins = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 1.2, end: 1.0).animate(
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

  void _triggerAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Trigger animations when values change
        if (gameProvider.lives != _previousLives ||
            gameProvider.streak != _previousStreak ||
            gameProvider.coins != _previousCoins) {
          _triggerAnimation();
        }
        
        _previousLives = gameProvider.lives;
        _previousStreak = gameProvider.streak;
        _previousCoins = gameProvider.coins;

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildStatusItem(
                      icon: Icons.favorite,
                      value: gameProvider.lives.toString(),
                      color: Colors.red,
                      showTimer: true,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildStatusItem(
                      icon: Icons.local_fire_department,
                      value: '${gameProvider.streak}',
                      subtext: 'STREAK',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildStatusItem(
                      icon: Icons.monetization_on,
                      value: gameProvider.coins.toString(),
                      color: Colors.amber,
                      showAdd: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String value,
    required Color color,
    String? subtext,
    bool showTimer = false,
    bool showAdd = false,
  }) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double scale = 1.0;
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    if (subtext != null) ...[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                                height: 1,
                                fontSize: 13,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              subtext,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                letterSpacing: -0.5,
                                height: 1,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                    if (showTimer) ...[
                      const SizedBox(width: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '29:16',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (showAdd) ...[
                      const SizedBox(width: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade400.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 