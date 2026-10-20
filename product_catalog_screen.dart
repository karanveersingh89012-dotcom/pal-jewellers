import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/language_switcher_widget.dart';
import '../../../core/services/firestore_service.dart';
import '../models/order_request_model.dart';
import '../models/product_model.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/wishlist_heart_button.dart';
import 'product_detail_screen.dart';
import 'wishlist_screen.dart';

class ProductCatalogScreen extends ConsumerStatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  ConsumerState<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends ConsumerState<ProductCatalogScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Necklaces',
    'Rings',
    'Earrings',
    'Bangles',
    'Wedding',
  ];

  void _openOrderSheet(BuildContext context, ProductModel product) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final strings = AppStrings.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.get('request_to_order'),
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.orangeAccent),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(hintText: strings.get('customer_name')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: strings.get('phone_number')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 2,
              decoration: InputDecoration(hintText: strings.get('customization_note')),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please provide your name and phone number.")),
                  );
                  return;
                }

                final order = OrderRequestModel(
                  id: '',
                  customerName: nameCtrl.text.trim(),
                  customerPhone: phoneCtrl.text.trim(),
                  note: noteCtrl.text.trim(),
                  status: 'NEW',
                  productId: product.id,
                  productTitle: product.title,
                  productThumbnail: product.mediaUrls.isNotEmpty ? product.mediaUrls.first : null,
                  createdAt: DateTime.now(),
                );

                await ref.read(firestoreServiceProvider).submitOrderRequest(order);

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.deepBrown,
                      content: Text(strings.get('request_success')),
                    ),
                  );
                }
              },
              child: Text(strings.get('submit_request')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final firestoreService = ref.watch(firestoreServiceProvider);
    final wishlistCount = ref.watch(wishlistProvider).length;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(strings.get('catalog')),
        actions: [
          const LanguageSwitcherAction(),
          Badge(
            isLabelVisible: wishlistCount > 0,
            label: Text(wishlistCount.toString()),
            backgroundColor: AppColors.orangeAccent,
            child: IconButton(
              icon: const Icon(Icons.favorite_border),
              tooltip: "Shortlisted Designs",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.goldenYellow,
                    backgroundColor: AppColors.surfaceWhite,
                    labelStyle: TextStyle(
                      color: AppColors.deepBrown,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: firestoreService.streamProducts(category: _selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.deepBrown));
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "No jewellery items currently displayed in this category.",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl = product.mediaUrls.isNotEmpty
                        ? product.mediaUrls.first
                        : "https://via.placeholder.com/300";

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.subtleDivider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        const BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: AppColors.creamBackground,
                                        child: const Icon(
                                          Icons.diamond_outlined,
                                          color: AppColors.deepBrown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                                          child: WishlistHeartButton(
                                            productId: product.id,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.share,
                                              size: 16,
                                              color: AppColors.deepBrown,
                                            ),
                                            onPressed: () {
                                              Share.share(
                                                "Explore ${product.title} (${product.carat}) from Pal Jewellers, Ghungrana!\nPhone: +91 98762-01512",
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${product.carat} • ${product.weightInGrams}g",
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.isPriceOnRequest
                                        ? strings.get('inquire_price')
                                        : "₹ ${product.fixedPrice?.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: AppColors.orangeAccent,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 34,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: AppColors.goldenYellow,
                                      ),
                                      onPressed: () => _openOrderSheet(context, product),
                                      child: Text(
                                        strings.get('request_to_order'),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}