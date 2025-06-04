import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_enums.dart';
import '../l10n/app_localizations.dart';
import '../screens/game_screen.dart';

class CategoryButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryButton({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l10n = AppLocalizations.of(context);
    final category = _getCategoryFromName(name);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (category != null) {
            gameProvider.initGame(category: category);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
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
                name,
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

  GameCategory? _getCategoryFromName(String name) {
    switch (name.toLowerCase()) {
      case 'random':
        return GameCategory.random;
      case 'music':
        return GameCategory.music;
      case 'movies':
        return GameCategory.movies;
      case 'sports':
        return GameCategory.sports;
      case 'food':
        return GameCategory.food;
      case 'countries':
        return GameCategory.countries;
      case 'technology':
        return GameCategory.technology;
      case 'animals':
        return GameCategory.animals;
      default:
        return null;
    }
  }
}

class CategoriesDialog extends StatelessWidget {
  const CategoriesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CATEGORIES',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                CategoryButton(
                  name: 'Random',
                  icon: Icons.shuffle,
                  color: Colors.white,
                ),
                CategoryButton(
                  name: 'Music',
                  icon: Icons.music_note,
                  color: const Color(0xFFB5FFB9),
                ),
                CategoryButton(
                  name: 'Movies',
                  icon: Icons.movie,
                  color: const Color(0xFFB5DEFF),
                ),
                CategoryButton(
                  name: 'TV Series',
                  icon: Icons.tv,
                  color: Colors.grey.shade300,
                ),
                CategoryButton(
                  name: 'Video Games',
                  icon: Icons.gamepad,
                  color: Colors.grey.shade300,
                ),
                CategoryButton(
                  name: 'Books',
                  icon: Icons.book,
                  color: Colors.grey.shade300,
                ),
                CategoryButton(
                  name: 'Sports',
                  icon: Icons.sports_basketball,
                  color: const Color(0xFFB5DEFF),
                ),
                CategoryButton(
                  name: 'Food',
                  icon: Icons.fastfood,
                  color: const Color(0xFFB5DEFF),
                ),
                CategoryButton(
                  name: 'Animals',
                  icon: Icons.pets,
                  color: Colors.grey.shade300,
                ),
                CategoryButton(
                  name: 'Countries',
                  icon: Icons.flag,
                  color: const Color(0xFFB5DEFF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShopDialog extends StatelessWidget {
  const ShopDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'SHOP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Shop items will be implemented here
            const Text('Coming soon!'),
          ],
        ),
      ),
    );
  }
} 