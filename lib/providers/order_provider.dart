import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math; // استيراد مكتبة الرياضيات للحسابات الجغرافية
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

  double? _liveLat;
  double? _liveLng;

  StreamSubscription? _ordersSubscription;
  StreamSubscription? _locationSubscription;

  // Getters
  List<OrderModel> get orders => _orders;
  List<DriverModel> get drivers => _drivers;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  double? get liveLat => _liveLat;
  double? get liveLng => _liveLng;

  // --- الإضافات الجديدة للنقطة الخامسة ---

  // 1. دالة حساب المسافة بين نقطتين بالكيلومتر (Haversine Formula)
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R (قطر الأرض بالكيلومتر)
  }

  // 2. Getter لحساب المسافة الحالية بين السائق والعميل
  double get distanceToUser {
    if (_liveLat == null || _liveLng == null || _currentOrder == null)
      return 0.0;
    // نفترض أن OrderModel يحتوي على userLat و userLng (موقع العميل)
    return _calculateDistance(
        _liveLat!, _liveLng!, _currentOrder!.userLat, _currentOrder!.userLng);
  }

  // 3. Getter لحساب الوقت المتوقع للوصول (ETA)
  String get estimatedArrivalTime {
    double distance = distanceToUser;
    if (distance == 0.0) return "جاري الحساب...";

    // تقدير السرعة المتوسطة لوايت الماء في شوارع تعز (مثلاً 20 كم/ساعة بسبب الزحام)
    double speedKmH = 20.0;
    double timeInHours = distance / speedKmH;
    int timeInMinutes = (timeInHours * 60).round();

    if (timeInMinutes < 1) return "وصل الآن أو قريب جداً";
    if (timeInMinutes > 60) {
      return "${(timeInMinutes / 60).toStringAsFixed(1)} ساعة";
    }
    return "$timeInMinutes دقيقة";
  }

  // --- نهاية الإضافات الجديدة ---

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchDrivers() async {
    try {
      _drivers = await _firestoreService.getDrivers();
      notifyListeners();
    } catch (e) {
      print("خطأ في جلب السائقين: $e");
    }
  }

  void fetchUserOrders(String userId) {
    _ordersSubscription?.cancel();
    _ordersSubscription =
        _firestoreService.getUserOrders(userId).listen((orders) {
      _orders = orders;
      notifyListeners();
    });
  }

  Future<void> addOrder(OrderModel order) async {
    if (order.driverId == null) {
      throw "يجب اختيار سائق أولاً";
    }

    setLoading(true);
    try {
      _currentOrder = await _firestoreService.createOrder(order);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void startTrackingDriver(String driverId) {
    _locationSubscription?.cancel();
    _locationSubscription =
        _realtimeService.getDriverLiveLocation(driverId).listen((location) {
      _liveLat = location['lat'];
      _liveLng = location['lng'];
      // بمجرد تحديث الموقع، سيتم إعادة حساب المسافة والوقت تلقائياً في الواجهة
      notifyListeners();
    }, onError: (error) {
      print("خطأ في تتبع الموقع: $error");
    });
  }

  void clearCurrentOrder() {
    _locationSubscription?.cancel();
    _currentOrder = null;
    _liveLat = null;
    _liveLng = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }
}
