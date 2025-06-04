import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/game_provider.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;
  int _previousLives = 6;
  int _previousStreak = 0;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.elasticOut,
      ),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _triggerPulseAnimation() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  void _triggerBounceAnimation() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Trigger animations when values change
        if (gameProvider.lives != _previousLives) {
          _triggerPulseAnimation();
        }
        
        if (gameProvider.streak != _previousStreak) {
          _triggerBounceAnimation();
        }
        
        _previousLives = gameProvider.lives;
        _previousStreak = gameProvider.streak;

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  // Lives indicator with heart animation
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: _buildStatusItem(
                            icon: Icons.favorite_rounded,
                            value: gameProvider.lives,
                            maxValue: 6,
                            color: const Color(0xFFFF3B30),
                            label: 'Lives',
                          ),
                        );
                      },
                    ),
                  ),
                  
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  
                  // Streak indicator with fire animation
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bounceAnimation.value,
                          child: _buildStatusItem(
                            icon: Icons.local_fire_department_rounded,
                            value: gameProvider.streak,
                            color: const Color(0xFFFF9500),
                            label: 'Streak',
                          ),
                        );
                      },
                    ),
                  ),
                  
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  
                  // Score/Coins indicator
                  Expanded(
                    child: _buildStatusItem(
                      icon: Icons.stars_rounded,
                      value: gameProvider.coins,
                      color: const Color(0xFFFFD60A),
                      label: 'Score',
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
    required int value,
    int? maxValue,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon with gradient background
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Value with progress indicator for lives
        if (maxValue != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxValue, (index) {
              final isActive = index < value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? color 
                        : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: isActive ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                ),
              );
            }),
          ),
        ] else ...[
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        
        const SizedBox(height: 4),
        
        // Label
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}