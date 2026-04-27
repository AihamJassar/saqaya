import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/theme_mode_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 5;
  final double _pricePerM3 = 15.0;

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'خدمة الموقع غير مفعلة';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw 'تم رفض إذن الموقع';
    }
    return Geolocator.getCurrentPosition();
  }

  void _confirmOrder() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (userProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سجل دخولك أولاً')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final position = await _determinePosition();
      final newOrder = OrderModel(
        id: '',
        userId: userProvider.user!.id,
        driverId: orderProvider.drivers.isNotEmpty
            ? orderProvider.drivers.first.id
            : null,
        quantity: _quantity,
        price: _quantity * _pricePerM3,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        userLat: position.latitude,
        userLng: position.longitude,
      );

      await orderProvider.addOrder(newOrder);
      if (mounted) Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/driver_tracking');
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب سقاية'),
        actions: const [ThemeModeButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'اختر كمية الماء المطلوبة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _quantityButton(
                  context,
                  Icons.add,
                  () => setState(() => _quantity++),
                  colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'متر مكعب',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _quantityButton(
                  context,
                  Icons.remove,
                  () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                  colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'السعر الإجمالي: ${_quantity * _pricePerM3} ريال',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _confirmOrder,
                icon: const Icon(Icons.location_on),
                label: const Text(
                  'تأكيد الطلب ونشر موقعي',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
