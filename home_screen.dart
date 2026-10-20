import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/guards/role_guard.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/language_switcher_widget.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../providers/wishlist_provider.dart';
import 'wishlist_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final wishlistCount = ref.watch(wishlistProvider).length;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onLongPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RoleGuard(child: AdminDashboardScreen()),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium, color: AppColors.orangeAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                "PAL JEWELLERS",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: AppColors.deepBrown,
                    ),
              ),
            ],
          ),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBrown.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "PAL JEWELLERS",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: AppColors.deepBrown,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "— Since 1880 —",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "ਘੁੰਗਰਾਣੇ ਵਾਲੇ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepBrown,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.get('tagline'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.deepBrown.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.goldenYellow.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.goldenYellow, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.orangeAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      strings.get('google_rating'),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    const Text("• Verified Heritage Jeweller", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppColors.surfaceWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_outlined, size: 36, color: AppColors.deepBrown),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.get('hallmark_guarantee'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "100% 22 Carat Hallmark Pass certified gold ensuring purity and lifetime exchange guarantee.",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppColors.surfaceWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Showroom Specialties",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      Text("• Traditional & Modern Gold Jewellery"),
                      Text("• Certified & Genuine Diamond Jewellery"),
                      Text("• Elegant & Timeless Silver Jewellery"),
                      Text("• Pure Silver Utensils & Puja Coins"),
                      Text("• Certified Lucky Astrological Stones"),
                      Text("• Custom Jewellery From Your Design / Photo"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _makePhoneCall('+919876201512'),
                icon: const Icon(Icons.call, color: AppColors.deepBrown),
                label: Text(strings.get('call_us')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}