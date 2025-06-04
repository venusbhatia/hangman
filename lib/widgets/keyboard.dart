import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class Keyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final Set<String> usedLetters;
  final String word;

  const Keyboard({
    super.key,
    required this.onKeyPressed,
    required this.usedLetters,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final language = gameProvider.language;
    
    List<List<String>> keyboardLayout;
    
    switch (language) {
      case 'हिंदी':
        keyboardLayout = _getHindiKeyboard();
        break;
      case '中文':
        keyboardLayout = _getChineseKeyboard();
        break;
      default:
        keyboardLayout = _getEnglishKeyboard();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: keyboardLayout.asMap().entries.map((entry) {
          int rowIndex = entry.key;
          List<String> row = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((letter) {
                return _buildKey(letter);
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<List<String>> _getEnglishKeyboard() {
    return [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];
  }

  List<List<String>> _getHindiKeyboard() {
    // Minimal Hindi keyboard - just essential consonants and vowels
    return [
      ['क', 'ग', 'च', 'त', 'न', 'प', 'म', 'र'],
      ['ल', 'स', 'ह', 'ा', 'ि', 'ी', 'े', 'ो'],
      ['ब', 'द', 'य', 'व', 'ज', 'ू', 'ै', 'ौ'],
    ];
  }

  List<List<String>> _getChineseKeyboard() {
    // Minimal Chinese keyboard - most common characters only
    return [
      ['电', '脑', '手', '机', '书', '本', '水', '天'],
      ['中', '国', '人', '大', '小', '火', '土', '木'],
      ['球', '工', '智', '能', '食', '物', '动', '音'],
    ];
  }

  Widget _buildKey(String letter) {
    final isUsed = usedLetters.contains(letter.toLowerCase());
    final isCorrect = isUsed && word.contains(letter);
    final isIncorrect = isUsed && !word.contains(letter);
    
    Color backgroundColor;
    Color textColor;
    
    if (isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.8);
      textColor = Colors.white;
    } else if (isIncorrect) {
      backgroundColor = Colors.red.withOpacity(0.8);
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.white.withOpacity(0.2);
      textColor = Colors.white;
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 45,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isUsed ? null : () => onKeyPressed(letter),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: isUsed ? null : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: textColor.withOpacity(isUsed ? 0.9 : 1.0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 