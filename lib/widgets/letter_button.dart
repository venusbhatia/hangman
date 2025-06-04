import 'package:flutter/material.dart';
import 'dart:ui';

class LetterButton extends StatelessWidget {
  final String letter;
  final bool isUsed;
  final VoidCallback onPressed;

  const LetterButton({
    super.key,
    required this.letter,
    required this.isUsed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isUsed
                  ? theme.colorScheme.surfaceVariant.withOpacity(0.7)
                  : theme.colorScheme.primaryContainer.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isUsed ? null : onPressed,
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: isUsed
                          ? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
                          : theme.colorScheme.onPrimaryContainer,
                    ),
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