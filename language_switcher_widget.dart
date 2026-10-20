import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import 'locale_provider.dart';

class LanguageSwitcherAction extends ConsumerWidget {
  const LanguageSwitcherAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<String>(
      tooltip: "Change Language / ਭਾਸ਼ਾ ਬਦਲੋ",
      offset: const Offset(0, 48),
      color: AppColors.surfaceWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.subtleDivider),
      ),
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.goldenYellow.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.goldenYellow, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16, color: AppColors.deepBrown),
            const SizedBox(width: 4),
            Text(
              _getShortCode(currentLocale.languageCode),
              style: const TextStyle(
                color: AppColors.deepBrown,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      onSelected: (String langCode) {
        ref.read(localeProvider.notifier).setByLanguageCode(langCode);
      },
      itemBuilder: (BuildContext context) => [
        _buildMenuItem('en', 'English', 'English', currentLocale.languageCode == 'en'),
        const PopupMenuDivider(height: 1),
        _buildMenuItem('pa', 'ਪੰਜਾਬੀ', 'Punjabi', currentLocale.languageCode == 'pa'),
        const PopupMenuDivider(height: 1),
        _buildMenuItem('hi', 'हिंदी', 'Hindi', currentLocale.languageCode == 'hi'),
      ],
    );
  }

  String _getShortCode(String code) {
    switch (code) {
      case 'pa':
        return 'ਪੰ';
      case 'hi':
        return 'हि';
      default:
        return 'EN';
    }
  }

  PopupMenuItem<String> _buildMenuItem(
    String code,
    String nativeLabel,
    String engLabel,
    bool isSelected,
  ) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nativeLabel,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.orangeAccent : AppColors.deepBrown,
                  fontSize: 14,
                ),
              ),
              Text(
                engLabel,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.orangeAccent, size: 18),
        ],
      ),
    );
  }
}