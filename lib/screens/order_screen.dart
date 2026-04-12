import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../models/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 5;
  final double _pricePerM3 = 15.0;

  void _confirmOrder() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    if (userProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تسجيل الدخول أولاً')),
      );
      return;
    }

    // Create order object
    final newOrder = OrderModel(
      id: '', // Firestore will generate this
      userId: userProvider.user!.id,
      driverId: orderProvider.drivers.isNotEmpty ? orderProvider.drivers.first.id : null,
      quantity: _quantity,
      price: _quantity * _pricePerM3,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    
    try {
      await orderProvider.addOrder(newOrder);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/tracking');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إنشاء الطلب: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<OrderProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('اختر الكمية المطلوبة (متر مكعب)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 40, color: Colors.blue),
                  onPressed: () {
                    if (_quantity > 5) setState(() => _quantity -= 5);
                  },
                ),
                const SizedBox(width: 24),
                Text('$_quantity', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 40, color: Colors.blue),
                  onPressed: () {
                    if (_quantity < 50) setState(() => _quantity += 5);
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('السعر الإجمالي:', style: TextStyle(fontSize: 20)),
                Text('${_quantity * _pricePerM3} ريال', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isLoading ? null : _confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('تأكيد الطلب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
