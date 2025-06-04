import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class HangmanDrawing extends StatefulWidget {
  const HangmanDrawing({super.key});

  @override
  State<HangmanDrawing> createState() => _HangmanDrawingState();
}

class _HangmanDrawingState extends State<HangmanDrawing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  int _previousLives = 6;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create animations for each part of the hangman
    _animations = List.generate(6, (index) {
      final start = index / 6;
      final end = (index + 1) / 6;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final currentLives = gameProvider.lives;
        
        // Trigger animation when lives decrease
        if (currentLives < _previousLives) {
          _controller.animateTo(1 - currentLives / 6);
        }
        _previousLives = currentLives;

        return SizedBox(
          height: 200,
          width: 200,
          child: Stack(
            children: [
              // Base
              Positioned(
                bottom: 10,
                left: 20,
                right: 20,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Pole
              Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width * 0.2,
                child: Container(
                  width: 4,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Top beam
              Positioned(
                top: 10,
                left: MediaQuery.of(context).size.width * 0.2,
                child: Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Rope
              Positioned(
                top: 10,
                left: MediaQuery.of(context).size.width * 0.2 + 96,
                child: Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Head
              if (currentLives < 6)
                Stack(
                  children: [
                    Positioned(
                      top: 40,
                      left: MediaQuery.of(context).size.width * 0.2 + 78,
                      child: FadeTransition(
                        opacity: _animations[5],
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              // Body
              if (currentLives < 5)
                Stack(
                  children: [
                    Positioned(
                      top: 80,
                      left: MediaQuery.of(context).size.width * 0.2 + 96,
                      child: FadeTransition(
                        opacity: _animations[4],
                        child: Container(
                          width: 4,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              // Left arm
              if (currentLives < 4)
                Stack(
                  children: [
                    Positioned(
                      top: 90,
                      left: MediaQuery.of(context).size.width * 0.2 + 96,
                      child: FadeTransition(
                        opacity: _animations[3],
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              // Right arm
              if (currentLives < 3)
                Stack(
                  children: [
                    Positioned(
                      top: 90,
                      left: MediaQuery.of(context).size.width * 0.2 + 60,
                      child: FadeTransition(
                        opacity: _animations[2],
                        child: Transform.rotate(
                          angle: 0.5,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              // Left leg
              if (currentLives < 2)
                Stack(
                  children: [
                    Positioned(
                      top: 140,
                      left: MediaQuery.of(context).size.width * 0.2 + 96,
                      child: FadeTransition(
                        opacity: _animations[1],
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              // Right leg
              if (currentLives < 1)
                Stack(
                  children: [
                    Positioned(
                      top: 140,
                      left: MediaQuery.of(context).size.width * 0.2 + 60,
                      child: FadeTransition(
                        opacity: _animations[0],
                        child: Transform.rotate(
                          angle: 0.5,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
} 