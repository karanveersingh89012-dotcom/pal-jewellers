import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final wishlistProvider = StateNotifierProvider<WishlistNotifier, Set<String>>((ref) {
  return WishlistNotifier();
});

class WishlistNotifier extends StateNotifier<Set<String>> {
  static const String _storageKey = 'pal_jewellers_customer_wishlist';

  WishlistNotifier() : super({}) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedList = prefs.getStringList(_storageKey);
    if (savedList != null) {
      state = savedList.toSet();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, updated.toList());
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}