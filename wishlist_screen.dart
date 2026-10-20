import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/firestore_service.dart';
import '../models/product_model.dart';
import '../providers/wishlist_provider.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> favoriteIds = ref.watch(wishlistProvider);
    final FirestoreService firestoreService = ref.watch(firestoreServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text("Shortlisted Designs"),
      ),
      body: favoriteIds.isEmpty
          ? _buildEmptyState(context)
          : StreamBuilder<List<ProductModel>>(
              stream: firestoreService.streamProducts(category: 'All'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.deepBrown));
                }

                final List<ProductModel> allProducts = snapshot.data ?? [];
                final List<ProductModel> wishlistProducts = allProducts
                    .where((product) => favoriteIds.contains(product.id))
                    .toList();

                if (wishlistProducts.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: wishlistProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ProductModel item = wishlistProducts[index];
                    return _buildWishlistItem(context, ref, item);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.goldenYellow.withValues(alpha: 0.2),
              child: const Icon(Icons.favorite_border, size: 40, color: AppColors.deepBrown),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Shortlisted Jewellery Yet",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.deepBrown),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the heart icon on any necklace, ring, or bangle to save designs you want to view in our Ghungrana showroom.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Explore Catalog"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, WidgetRef ref, ProductModel item) {
    final String imageUrl = item.mediaUrls.isNotEmpty
        ? item.mediaUrls.first
        : "https://via.placeholder.com/150";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.subtleDivider),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 76,
                  height: 76,
                  color: AppColors.creamBackground,
                  child: const Icon(Icons.diamond_outlined, color: AppColors.deepBrown),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${item.carat} • ${item.weightInGrams}g",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.isPriceOnRequest
                        ? "Price on Inquiry"
                        : "₹ ${item.fixedPrice?.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: AppColors.orangeAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              tooltip: "Remove",
              onPressed: () {
                ref.read(wishlistProvider.notifier).toggleFavorite(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}