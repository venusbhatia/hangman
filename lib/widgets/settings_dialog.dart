import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/game_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: size.height * 0.7,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF007AFF).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.settings_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    l10n.settings,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1C1C1E),
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2F2F7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xFF8E8E93),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Content
                          Flexible(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Language section
                                    _buildSectionHeader('Language'),
                                    const SizedBox(height: 16),
                                    _buildLanguageSelector(gameProvider),
                                    
                                    const SizedBox(height: 32),
                                    
                                    // Game stats section
                                    _buildSectionHeader('Statistics'),
                                    const SizedBox(height: 16),
                                    _buildStatsCard(gameProvider),
                                    
                                    const SizedBox(height: 32),
                                    
                                    // Social section
                                    _buildSectionHeader('Connect'),
                                    const SizedBox(height: 16),
                                    _buildSocialSection(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1C1C1E),
      ),
    );
  }

  Widget _buildLanguageSelector(GameProvider gameProvider) {
    final languages = [
      {'name': 'English', 'flag': '🇺🇸'},
      {'name': 'हिंदी', 'flag': '🇮🇳'},
      {'name': '中文', 'flag': '🇨🇳'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: languages.asMap().entries.map((entry) {
          final index = entry.key;
          final lang = entry.value;
          final isSelected = lang['name'] == gameProvider.language;
          final isLast = index == languages.length - 1;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => gameProvider.setLanguage(lang['name']!),
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? const Radius.circular(16) : Radius.zero,
                bottom: isLast ? const Radius.circular(16) : Radius.zero,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: isLast ? null : Border(
                    bottom: BorderSide(
                      color: const Color(0xFFE5E5EA),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        lang['name']!,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: isSelected 
                              ? const Color(0xFF007AFF)
                              : const Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF007AFF),
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsCard(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Current Streak',
              gameProvider.streak.toString(),
              Icons.local_fire_department_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Best Streak',
              gameProvider.maxStreak.toString(),
              Icons.emoji_events_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Total Score',
              gameProvider.coins.toString(),
              Icons.stars_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    final socialItems = [
      {'name': 'Share App', 'icon': Icons.share_rounded, 'color': Color(0xFF34C759)},
      {'name': 'Rate Us', 'icon': Icons.star_rounded, 'color': Color(0xFFFF9500)},
      {'name': 'Feedback', 'icon': Icons.feedback_rounded, 'color': Color(0xFF007AFF)},
      {'name': 'Privacy', 'icon': Icons.privacy_tip_rounded, 'color': Color(0xFF8E8E93)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: socialItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == socialItems.length - 1;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle social actions
              },
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? const Radius.circular(16) : Radius.zero,
                bottom: isLast ? const Radius.circular(16) : Radius.zero,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: isLast ? null : Border(
                    bottom: BorderSide(
                      color: const Color(0xFFE5E5EA),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: item['color'] as Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: const Color(0xFF8E8E93),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}