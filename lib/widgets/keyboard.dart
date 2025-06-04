import 'package:flutter/material.dart';

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
    // QWERTY layout
    const qwertyRows = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: qwertyRows.asMap().entries.map((entry) {
          int rowIndex = entry.key;
          List<String> row = entry.value;
          
          return Container(
            margin: EdgeInsets.only(
              bottom: 8,
              left: rowIndex == 1 ? 20 : (rowIndex == 2 ? 40 : 0),
              right: rowIndex == 1 ? 20 : (rowIndex == 2 ? 40 : 0),
            ),
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

  Widget _buildKey(String letter) {
    final isUsed = usedLetters.contains(letter.toLowerCase());
    final isCorrect = isUsed && word.toUpperCase().contains(letter);
    final isIncorrect = isUsed && !word.toUpperCase().contains(letter);
    
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