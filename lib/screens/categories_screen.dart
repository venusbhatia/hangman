import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/game_enums.dart';
import 'game_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categories),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildCategoryCard(context, l10n.random, GameCategory.random, Icons.shuffle, Colors.grey.shade100),
          _buildCategoryCard(context, l10n.music, GameCategory.music, Icons.music_note, Colors.blue.shade50),
          _buildCategoryCard(context, l10n.movies, GameCategory.movies, Icons.movie, Colors.red.shade50),
          _buildCategoryCard(context, l10n.sports, GameCategory.sports, Icons.sports_basketball, Colors.orange.shade50),
          _buildCategoryCard(context, l10n.food, GameCategory.food, Icons.restaurant, Colors.green.shade50),
          _buildCategoryCard(context, l10n.countries, GameCategory.countries, Icons.public, Colors.purple.shade50),
          _buildCategoryCard(context, l10n.technology, GameCategory.technology, Icons.computer, Colors.cyan.shade50),
          _buildCategoryCard(context, l10n.animals, GameCategory.animals, Icons.pets, Colors.brown.shade50),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, GameCategory category, IconData icon, Color backgroundColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          context.read<GameProvider>().initGame(category: category);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GameScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.black54,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 