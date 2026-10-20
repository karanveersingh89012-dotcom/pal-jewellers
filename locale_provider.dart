import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en', 'US'));

  void setLocale(Locale newLocale) {
    if (state != newLocale) {
      state = newLocale;
    }
  }

  void setByLanguageCode(String code) {
    switch (code) {
      case 'pa':
        state = const Locale('pa', 'IN');
        break;
      case 'hi':
        state = const Locale('hi', 'IN');
        break;
      case 'en':
      default:
        state = const Locale('en', 'US');
        break;
    }
  }
}