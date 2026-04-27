import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/driver_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user data to Firestore
  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  // Get user data from Firestore
  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      return UserModel.fromMap(data, doc.id);
    }

    return null;
  }

  // Get all drivers from Firestore
  Future<List<DriverModel>> getDrivers() async {
    QuerySnapshot snapshot = await _db.collection('drivers').get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // بدلاً من DriverModel.fromMap(data, doc.id)
      return DriverModel.fromFirestore(doc.id, data);
    }).toList();
  }

  // Create a new order in Firestore
  Future<OrderModel?> createOrder(OrderModel order) async {
    DocumentReference docRef =
        await _db.collection('orders').add(order.toMap());

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      return OrderModel.fromMap(data, doc.id);
    }

    return null;
  }

  // Get orders for a specific user
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return OrderModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status.toString().split('.').last,
    });
  }
}
