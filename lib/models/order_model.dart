import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, accepted, onTheWay, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final String? driverId;
  final int quantity; // in m3
  final double price;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    this.driverId,
    required this.quantity,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      userId: map['userId'] ?? '',
      driverId: map['driverId'],
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'driverId': driverId,
      'quantity': quantity,
      'price': price,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
