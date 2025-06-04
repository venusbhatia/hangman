import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class KeyboardLayout extends StatelessWidget {
  const KeyboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final language = gameProvider.language;

    switch (language) {
      case 'हिंदी':
        return _HindiKeyboard();
      case '中文':
        return _ChineseKeyboard();
      default:
        return _EnglishKeyboard();
    }
  }
}

class _EnglishKeyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const letters = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth = (constraints.maxWidth - 20) / 10; // 10 is max keys per row
        return Column(
          children: letters.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => _buildKey(context, letter, keyWidth)).toList(),
              ),
            );
          }).toList(),
        );
      }
    );
  }
}

class _HindiKeyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const letters = [
      ['क', 'ख', 'ग', 'घ', 'ङ', 'च', 'छ', 'ज', 'झ', 'ञ'],
      ['ट', 'ठ', 'ड', 'ढ', 'ण', 'त', 'थ', 'द', 'ध', 'न'],
      ['प', 'फ', 'ब', 'भ', 'म', 'य', 'र', 'ल', 'व', 'श'],
      ['ष', 'स', 'ह', 'अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth = (constraints.maxWidth - 20) / 10; // 10 is max keys per row
        return Column(
          children: letters.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => _buildKey(context, letter, keyWidth)).toList(),
              ),
            );
          }).toList(),
        );
      }
    );
  }
}

class _ChineseKeyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const letters = [
      ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'],
      ['月', '火', '水', '木', '金', '土', '日', '天', '地', '人'],
      ['山', '川', '海', '河', '湖', '林', '花', '草', '木', '竹'],
      ['心', '手', '口', '目', '耳', '足', '头', '身', '家', '国'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth = (constraints.maxWidth - 20) / 10; // 10 is max keys per row
        return Column(
          children: letters.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => _buildKey(context, letter, keyWidth)).toList(),
              ),
            );
          }).toList(),
        );
      }
    );
  }
}

Widget _buildKey(BuildContext context, String letter, double width) {
  final gameProvider = context.watch<GameProvider>();
  final isGuessed = gameProvider.guessedLetters.contains(letter.toLowerCase());
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.all(1),
    child: SizedBox(
      width: width,
      height: width * 1.3,
      child: ElevatedButton(
        onPressed: isGuessed ? null : () => gameProvider.makeGuess(letter),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isGuessed ? Colors.grey.shade200 : Colors.white,
          foregroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isGuessed ? Colors.grey.shade300 : theme.colorScheme.primary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          elevation: isGuessed ? 0 : 2,
          shadowColor: theme.colorScheme.primary.withOpacity(0.3),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              letter,
              style: TextStyle(
                fontSize: gameProvider.language == 'English' ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: isGuessed ? Colors.grey.shade400 : theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    ),
  );
} 