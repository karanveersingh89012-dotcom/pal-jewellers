import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/customer/models/product_model.dart';
import '../../features/customer/models/order_request_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});

class FirestoreService {
  final FirebaseFirestore _db;
  FirestoreService(this._db);

  Stream<List<ProductModel>> streamProducts({String? category}) {
    Query query = _db.collection('products').where('isActive', isEqualTo: true);
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> submitOrderRequest(OrderRequestModel request) async {
    await _db.collection('order_requests').add(request.toMap());
  }

  Stream<List<OrderRequestModel>> streamAllOrderRequests() {
    return _db
        .collection('order_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderRequestModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _db.collection('order_requests').doc(orderId).update({
      'status': newStatus,
    });
  }

  Future<void> upsertProduct(ProductModel product) async {
    final docRef = product.id.isEmpty
        ? _db.collection('products').doc()
        : _db.collection('products').doc(product.id);
    await docRef.set(product.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
  }
}