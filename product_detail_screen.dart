import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../models/product_model.dart';
import '../widgets/wishlist_heart_button.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  Future<void> _inquireOnWhatsApp(BuildContext context) async {
    final String message = Uri.encodeComponent(
      "Sat Sri Akal / Hello Pal Jewellers,\n"
      "I am inquiring about this item from your showroom catalog:\n\n"
      "• Design: ${product.title}\n"
      "• Purity: ${product.carat}\n"
      "• Approximate Weight: ${product.weightInGrams}g\n"
      "• Price Note: ${product.isPriceOnRequest ? 'Price on Inquiry' : '₹ ${product.fixedPrice?.toStringAsFixed(0)}'}\n\n"
      "Please let me know about availability and making charges.",
    );

    final Uri url = Uri.parse("https://wa.me/919876201512?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = product.mediaUrls.isNotEmpty
        ? product.mediaUrls.first
        : "https://via.placeholder.com/600";

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          WishlistHeartButton(productId: product.id, size: 22),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Share.share(
                "Take a look at '${product.title}' (${product.carat}) at Pal Jewellers, Ghungrana!\n"
                "Showroom Contact: +91 98762-01512",
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceWhite,
                  child: const Center(
                    child: Icon(Icons.diamond_outlined, size: 64, color: AppColors.deepBrown),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppColors.deepBrown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        product.isPriceOnRequest
                            ? "Price on Inquiry"
                            : "₹ ${product.fixedPrice?.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: AppColors.orangeAccent,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.goldenYellow.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${product.carat} • ${product.weightInGrams}g",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.deepBrown,
                      ),
                    ),
                  ),
                  const Divider(height: 32, color: AppColors.subtleDivider),
                  const Text(
                    "Artisan Craftsmanship & Guarantee",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.deepBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : "Custom crafted with heritage precision by Pal Jewellers, Ghungrana (Distt. Ludhiana). Designed for heirloom durability and 100% 22 Carat BIS-certified hallmark purity standards.",
                    style: TextStyle(
                      color: AppColors.deepBrown.withValues(alpha: 0.8),
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: AppColors.surfaceWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.verified, color: Colors.green, size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "22K BIS Hallmark Pass Certified Guarantee",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldenYellow,
                      foregroundColor: AppColors.deepBrown,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _inquireOnWhatsApp(context),
                    icon: const Icon(Icons.chat, color: Color(0xFF25D366)),
                    label: const Text(
                      "Inquire on WhatsApp",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}