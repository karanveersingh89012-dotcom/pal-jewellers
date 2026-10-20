class OrderRequestModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String? note;
  final String status;
  final String productId;
  final String productTitle;
  final String? productThumbnail;
  final DateTime createdAt;

  OrderRequestModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    this.note,
    required this.status,
    required this.productId,
    required this.productTitle,
    this.productThumbnail,
    required this.createdAt,
  });

  factory OrderRequestModel.fromMap(String id, Map<String, dynamic> data) {
    return OrderRequestModel(
      id: id,
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      note: data['note'],
      status: data['status'] ?? 'NEW',
      productId: data['productId'] ?? '',
      productTitle: data['productSnapshot']?['title'] ?? '',
      productThumbnail: data['productSnapshot']?['thumbnailUrl'],
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'note': note,
      'status': status,
      'productId': productId,
      'productSnapshot': {
        'title': productTitle,
        'thumbnailUrl': productThumbnail,
      },
      'createdAt': createdAt.toIso8601String(),
    };
  }
}