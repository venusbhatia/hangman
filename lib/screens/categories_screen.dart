import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/game_enums.dart';
import 'game_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> 
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Staggered animations for each category card
    _animations = List.generate(8, (index) {
      final start = index * 0.1;
      final end = start + 0.3;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.all(8),
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
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Challenge',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Pick a category and start guessing!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1C1C1E).withOpacity(0.6),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Expanded(
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCategoryCard(
                      l10n.random, 
                      GameCategory.random, 
                      Icons.shuffle_rounded,
                      const LinearGradient(colors: [Color(0xFF8E8E93), Color(0xFF636366)]),
                      0,
                    ),
                    _buildCategoryCard(
                      l10n.music, 
                      GameCategory.music, 
                      Icons.music_note_rounded,
                      const LinearGradient(colors: [Color(0xFF007AFF), Color(0xFF5856D6)]),
                      1,
                    ),
                    _buildCategoryCard(
                      l10n.movies, 
                      GameCategory.movies, 
                      Icons.movie_rounded,
                      const LinearGradient(colors: [Color(0xFFFF3B30), Color(0xFFFF6B35)]),
                      2,
                    ),
                    _buildCategoryCard(
                      l10n.sports, 
                      GameCategory.sports, 
                      Icons.sports_basketball_rounded,
                      const LinearGradient(colors: [Color(0xFFFF9500), Color(0xFFFFCC02)]),
                      3,
                    ),
                    _buildCategoryCard(
                      l10n.food, 
                      GameCategory.food, 
                      Icons.restaurant_rounded,
                      const LinearGradient(colors: [Color(0xFF34C759), Color(0xFF30D158)]),
                      4,
                    ),
                    _buildCategoryCard(
                      l10n.countries, 
                      GameCategory.countries, 
                      Icons.public_rounded,
                      const LinearGradient(colors: [Color(0xFF5856D6), Color(0xFFAF52DE)]),
                      5,
                    ),
                    _buildCategoryCard(
                      l10n.technology, 
                      GameCategory.technology, 
                      Icons.computer_rounded,
                      const LinearGradient(colors: [Color(0xFF00C7BE), Color(0xFF32D74B)]),
                      6,
                    ),
                    _buildCategoryCard(
                      l10n.animals, 
                      GameCategory.animals, 
                      Icons.pets_rounded,
                      const LinearGradient(colors: [Color(0xFFFF2D92), Color(0xFFBF5AF2)]),
                      7,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title, 
    GameCategory category, 
    IconData icon, 
    LinearGradient gradient,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _animations[index].value)),
          child: Opacity(
            opacity: _animations[index].value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<GameProvider>().initGame(category: category);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const GameScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(height: 4),
                            
                            Text(
                              _getCategorySubtitle(category),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getCategorySubtitle(GameCategory category) {
    switch (category) {
      case GameCategory.random:
        return 'Mixed topics';
      case GameCategory.music:
        return 'Songs & artists';
      case GameCategory.movies:
        return 'Films & shows';
      case GameCategory.sports:
        return 'Games & teams';
      case GameCategory.food:
        return 'Dishes & drinks';
      case GameCategory.countries:
        return 'Nations & cities';
      case GameCategory.technology:
        return 'Tech & gadgets';
      case GameCategory.animals:
        return 'Wildlife & pets';
    }
  }
}