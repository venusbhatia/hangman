import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
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
        final keyWidth = (constraints.maxWidth - 40) / 10; // Account for spacing
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: letters.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: rowIndex == 1 ? keyWidth * 0.5 : (rowIndex == 2 ? keyWidth * 1.5 : 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildKey(context, letter, keyWidth - 4),
                  )
                ).toList(),
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
      ['क', 'ख', 'ग', 'घ', 'ङ', 'च', 'छ', 'ज'],
      ['झ', 'ञ', 'ट', 'ठ', 'ड', 'ढ', 'ण', 'त'],
      ['थ', 'द', 'ध', 'न', 'प', 'फ', 'ब', 'भ'],
      ['म', 'य', 'र', 'ल', 'व', 'श', 'ष', 'स'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth = (constraints.maxWidth - 32) / 8; // 8 keys per row
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: letters.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildKey(context, letter, keyWidth - 4),
                  )
                ).toList(),
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
      ['一', '二', '三', '四', '五', '六', '七', '八'],
      ['九', '十', '月', '火', '水', '木', '金', '土'],
      ['日', '天', '地', '人', '山', '川', '海', '河'],
      ['心', '手', '口', '目', '耳', '足', '头', '身'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth = (constraints.maxWidth - 32) / 8; // 8 keys per row
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: letters.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildKey(context, letter, keyWidth - 4),
                  )
                ).toList(),
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
  final isCorrect = gameProvider.word.toLowerCase().contains(letter.toLowerCase()) && isGuessed;
  final isWrong = !gameProvider.word.toLowerCase().contains(letter.toLowerCase()) && isGuessed;

  return SizedBox(
    width: width,
    height: width * 1.1,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isGuessed ? null : () => gameProvider.makeGuess(letter),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _getKeyColor(isGuessed, isCorrect, isWrong),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isGuessed ? null : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: gameProvider.language == 'English' ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: _getKeyTextColor(isGuessed, isCorrect, isWrong),
              ),
              child: Text(letter),
            ),
          ),
        ),
      ),
    ),
  );
}

Color _getKeyColor(bool isGuessed, bool isCorrect, bool isWrong) {
  if (!isGuessed) {
    return const Color(0xFFF2F2F7);
  }
  
  if (isCorrect) {
    return const Color(0xFF34C759);
  }
  
  if (isWrong) {
    return const Color(0xFFFF3B30);
  }
  
  return const Color(0xFFE5E5EA);
}

Color _getKeyTextColor(bool isGuessed, bool isCorrect, bool isWrong) {
  if (!isGuessed) {
    return const Color(0xFF1C1C1E);
  }
  
  if (isCorrect || isWrong) {
    return Colors.white;
  }
  
  return const Color(0xFF8E8E93);
}