import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/guards/role_guard.dart';
import '../../../core/localization/language_switcher_widget.dart';
import '../../admin/screens/admin_dashboard_screen.dart';

class VisitUsScreen extends ConsumerWidget {
  const VisitUsScreen({super.key});

  Future<void> _launchExternalUrl(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      final bool success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open link.")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unable to open: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text("Showroom & Contact"),
        actions: const [
          LanguageSwitcherAction(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.subtleDivider),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBrown.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.storefront, color: AppColors.orangeAccent, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "PAL JEWELLERS",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: AppColors.deepBrown,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Near Post Office Road, Village Ghungrana,\n"
                    "V.P.O. Ghungrana, Distt. Ludhiana,\n"
                    "Punjab – 141204, India",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.deepBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Open: Mon – Sat (10:00 AM – 7:30 PM)",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldenYellow,
                      foregroundColor: AppColors.deepBrown,
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    onPressed: () => _launchExternalUrl(
                      context,
                      "https://maps.google.com/?q=Pal+Jewellers+Ghungrana+Ludhiana+Punjab+141204",
                    ),
                    icon: const Icon(Icons.directions, size: 20),
                    label: const Text("Navigate via Google Maps"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Direct Assistance",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepBrown,
                  ),
            ),
            const SizedBox(height: 8),
            _buildContactTile(
              context,
              icon: Icons.phone_in_talk,
              title: "Call Primary",
              subtitle: "+91 98762-01512",
              iconColor: AppColors.deepBrown,
              onTap: () => _launchExternalUrl(context, "tel:+919876201512"),
            ),
            const SizedBox(height: 8),
            _buildContactTile(
              context,
              icon: Icons.phone,
              title: "Call Secondary",
              subtitle: "+91 99156-72284",
              iconColor: AppColors.deepBrown,
              onTap: () => _launchExternalUrl(context, "tel:+919915672284"),
            ),
            const SizedBox(height: 8),
            _buildContactTile(
              context,
              icon: Icons.chat,
              title: "WhatsApp Showroom",
              subtitle: "+91 98762-01512 (Instant Response)",
              iconColor: const Color(0xFF25D366),
              onTap: () => _launchExternalUrl(
                context,
                "https://wa.me/919876201512?text=Hello%20Pal%20Jewellers,%20I%20would%20like%20to%20inquire%20about%20your%20jewellery.",
              ),
            ),
            const SizedBox(height: 8),
            _buildContactTile(
              context,
              icon: Icons.mail_outline,
              title: "Email Us",
              subtitle: "paljewellers000@gmail.com",
              iconColor: AppColors.orangeAccent,
              onTap: () => _launchExternalUrl(context, "mailto:paljewellers000@gmail.com"),
            ),
            const SizedBox(height: 24),
            Text(
              "Follow Us for Latest Designs & Updates",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepBrown,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [
                _buildSocialButton(
                  context,
                  platformName: "Instagram",
                  handle: "@pal_jewellers",
                  brandColor: const Color(0xFFE4405F),
                  iconData: Icons.camera_alt_outlined,
                  url: "https://www.instagram.com/pal_jewellers/",
                ),
                _buildSocialButton(
                  context,
                  platformName: "Facebook",
                  handle: "Pal Jewellers",
                  brandColor: const Color(0xFF1877F2),
                  iconData: Icons.facebook,
                  url: "https://www.facebook.com/share/1AomZDPgDN/",
                ),
                _buildSocialButton(
                  context,
                  platformName: "YouTube",
                  handle: "@pal_jewellers",
                  brandColor: const Color(0xFFFF0000),
                  iconData: Icons.play_circle_fill,
                  url: "https://www.youtube.com/@pal_jewellers",
                ),
                _buildSocialButton(
                  context,
                  platformName: "Snapchat",
                  handle: "pal_jeweller",
                  brandColor: const Color(0xFFFFFC00),
                  iconColor: Colors.black,
                  iconData: Icons.flash_on,
                  url: "https://www.snapchat.com/add/pal_jeweller",
                ),
              ],
            ),
            const SizedBox(height: 36),
            Center(
              child: IconButton(
                tooltip: "Management",
                icon: Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: AppColors.deepBrown.withValues(alpha: 0.2),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoleGuard(child: AdminDashboardScreen()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.subtleDivider),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.12),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String platformName,
    required String handle,
    required Color brandColor,
    required IconData iconData,
    required String url,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () => _launchExternalUrl(context, url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.subtleDivider),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: brandColor.withValues(alpha: 0.15),
              child: Icon(iconData, color: iconColor ?? brandColor, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    platformName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    handle,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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