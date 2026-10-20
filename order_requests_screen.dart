import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/firestore_service.dart';
import '../../customer/models/order_request_model.dart';

class OrderRequestsScreen extends ConsumerWidget {
  const OrderRequestsScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'NEW':
        return AppColors.orangeAccent;
      case 'CONTACTED':
        return Colors.blue;
      case 'IN_MAKING':
        return Colors.purple;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreService firestoreService = ref.watch(firestoreServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text("Customer Orders & Inquiries"),
      ),
      body: StreamBuilder<List<OrderRequestModel>>(
        stream: firestoreService.streamAllOrderRequests(),
        builder: (BuildContext context, AsyncSnapshot<List<OrderRequestModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.deepBrown));
          }
          final List<OrderRequestModel> orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text("No inquiries received yet."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final OrderRequestModel order = orders[index];
              return Card(
                elevation: 0,
                color: AppColors.surfaceWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.subtleDivider),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.productThumbnail != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                order.productThumbnail!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                              ),
                            )
                          else
                            const Icon(Icons.diamond_outlined, size: 40, color: AppColors.deepBrown),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.productTitle,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Customer: ${order.customerName}",
                                  style: const TextStyle(fontSize: 13, color: AppColors.deepBrown),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt),
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(
                                color: _getStatusColor(order.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (order.note != null && order.note!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.creamBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Note: ${order.note}",
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppColors.deepBrown),
                            onPressed: () => launchUrl(Uri.parse("tel:${order.customerPhone}")),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat, color: Colors.green),
                            onPressed: () {
                              final String text = Uri.encodeComponent(
                                "Sat Sri Akal / Hello ${order.customerName},\n"
                                "This is Sukhjinder Singh from Pal Jewellers Ghungrana regarding your inquiry for ${order.productTitle}.",
                              );
                              launchUrl(
                                Uri.parse("https://wa.me/${order.customerPhone.replaceAll('+', '')}?text=$text"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: order.status,
                            underline: const SizedBox.shrink(),
                            items: ['NEW', 'CONTACTED', 'IN_MAKING', 'COMPLETED', 'CANCELLED']
                                .map((String s) => DropdownMenuItem<String>(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (String? newStatus) {
                              if (newStatus != null) {
                                firestoreService.updateOrderStatus(order.id, newStatus);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}