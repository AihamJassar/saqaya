import '../models/order_model.dart';
import '../models/driver_model.dart';

class OrderService {
  // TODO: Integrate Firebase Firestore later

  Future<OrderModel?> createOrder(
      String userId, int quantity, double price) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

   
   // Mock successful order creation
    return OrderModel(
      id: 'o1',
      userId: userId,
      driverId: 'd1', // Assigning a mock driver
      quantity: quantity,
      price: price,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      // أضف السطرين التاليين هنا لإصلاح الخطأ:
      userLat: 13.5783, // إحداثيات تجريبية (تعز)
      userLng: 44.0139,
    );
    
  }

  Future<List<DriverModel>> getDrivers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock drivers data
    return [
      DriverModel(
          id: 'd1',
          name: 'أحمد محمد',
          latitude: 24.7136,
          longitude: 46.6753,
          phone: '777111222', // أضفنا هذا
          rating: 4.8),
      DriverModel(
          id: 'd2',
          name: 'خالد علي',
          latitude: 24.7236,
          longitude: 46.6853,
          phone: '777333444', // أضفنا هذا
          rating: 4.5),
      DriverModel(
          id: 'd3',
          name: 'سعيد حسن',
          latitude: 24.7036,
          longitude: 46.6653,
          phone: '777555666', // أضفنا هذا
          rating: 4.9),
    ];
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }
}
