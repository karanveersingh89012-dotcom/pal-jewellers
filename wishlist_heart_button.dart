import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/wishlist_provider.dart';

class WishlistHeartButton extends ConsumerStatefulWidget {
  final String productId;
  final double size;

  const WishlistHeartButton({
    super.key,
    required this.productId,
    this.size = 20,
  });

  @override
  ConsumerState<WishlistHeartButton> createState() => _WishlistHeartButtonState();
}

class _WishlistHeartButtonState extends ConsumerState<WishlistHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = ref.watch(wishlistProvider);
    final isLiked = wishlist.contains(widget.productId);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppColors.orangeAccent : AppColors.deepBrown,
          size: widget.size,
        ),
        onPressed: () {
          _animController.forward(from: 0.0);
          ref.read(wishlistProvider.notifier).toggleFavorite(widget.productId);

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 1400),
              backgroundColor: AppColors.deepBrown,
              content: Text(
                isLiked
                    ? "Removed from your shortlisted designs"
                    : "Saved to your shortlisted designs ❤️",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}