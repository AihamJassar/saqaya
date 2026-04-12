import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/driver_model.dart';
import '../services/firestore_service.dart';
import '../services/realtime_service.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final RealtimeService _realtimeService = RealtimeService();

  List<OrderModel> _orders = [];
  List<DriverModel> _drivers = [];
  OrderModel? _currentOrder;
  bool _isLoading = false;
  
  // Live location for tracking
  double? _liveLat;
  double? _liveLng;

  List<OrderModel> get orders => _orders;
  List<DriverModel> get drivers => _drivers;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  double? get liveLat => _liveLat;
  double? get liveLng => _liveLng;

  void setLoading(bool value) {
    if (drivers.isEmpty) {
      // بدلاً من رمي خطأ يغلق التطبيق، استخدم تنبيه
      throw "عذراً، لا يوجد سائقون متوفرون حالياً في منطقتك.";
    }
    _isLoading = value;
    notifyListeners();
  }

  // Fetch drivers from Firestore
  Future<void> fetchDrivers() async {
    _drivers = await _firestoreService.getDrivers();
    notifyListeners();
  }

  // Fetch user orders from Firestore
  void fetchUserOrders(String userId) {
    _firestoreService.getUserOrders(userId).listen((orders) {
      _orders = orders;
      notifyListeners();
    });
  }

  // Add a new order to Firestore
  Future<void> addOrder(OrderModel order) async {
    setLoading(true);
    _currentOrder = await _firestoreService.createOrder(order);
    setLoading(false);
    notifyListeners();
  }

  // Start listening to live location of a driver
  void startTrackingDriver(String driverId) {
    _realtimeService.getDriverLiveLocation(driverId).listen((location) {
      _liveLat = location['lat'];
      _liveLng = location['lng'];
      notifyListeners();
    });
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    _liveLat = null;
    _liveLng = null;
    notifyListeners();
  }
}
