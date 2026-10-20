class ProductModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String collection;
  final double weightInGrams;
  final String carat;
  final String material;
  final double? fixedPrice;
  final bool isPriceOnRequest;
  final List<String> mediaUrls;
  final bool isTrending;
  final bool isNewArrival;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.collection,
    required this.weightInGrams,
    required this.carat,
    required this.material,
    this.fixedPrice,
    required this.isPriceOnRequest,
    required this.mediaUrls,
    this.isTrending = false,
    this.isNewArrival = false,
    this.isActive = true,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Necklaces',
      collection: data['collection'] ?? 'Wedding',
      weightInGrams: (data['weightInGrams'] as num?)?.toDouble() ?? 0.0,
      carat: data['carat'] ?? '22K BIS Hallmarked',
      material: data['material'] ?? 'Gold',
      fixedPrice: (data['fixedPrice'] as num?)?.toDouble(),
      isPriceOnRequest: data['isPriceOnRequest'] ?? true,
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      isTrending: data['isTrending'] ?? false,
      isNewArrival: data['isNewArrival'] ?? false,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'collection': collection,
      'weightInGrams': weightInGrams,
      'carat': carat,
      'material': material,
      'fixedPrice': fixedPrice,
      'isPriceOnRequest': isPriceOnRequest,
      'mediaUrls': mediaUrls,
      'isTrending': isTrending,
      'isNewArrival': isNewArrival,
      'isActive': isActive,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}