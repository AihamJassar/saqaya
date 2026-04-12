import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Start tracking driver location on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      if (orderProvider.currentOrder?.driverId != null) {
        orderProvider
            .startTrackingDriver(orderProvider.currentOrder!.driverId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final currentOrder = orderProvider.currentOrder;

    // Find driver info from the list
    final driver = orderProvider.drivers.firstWhere(
      (d) => d.id == currentOrder?.driverId,
      orElse: () => orderProvider.drivers.isNotEmpty
          ? orderProvider.drivers.first
          : throw Exception('No drivers available'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع السائق مباشر'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Map Placeholder with Live Driver Marker
          Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 100, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('خريطة تتبع السائق (Google Maps)'),
                  if (orderProvider.liveLat != null)
                    Text(
                        'موقع السائق المباشر: ${orderProvider.liveLat}, ${orderProvider.liveLng}')
                  else
                    const Text('جاري جلب موقع السائق...'),
                ],
              ),
            ),
          ),

          // Live Driver Marker on Map (Simulated)
          if (orderProvider.liveLat != null)
            Positioned(
              left: 150 + (orderProvider.liveLng! - 46.6753) * 5000,
              top: 350 + (orderProvider.liveLat! - 24.7136) * 5000,
              child:
                  const Icon(Icons.local_shipping, color: Colors.red, size: 40),
            ),

          // Driver Info Card
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child:
                              Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(driver.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  Text('${driver.rating}',
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('حالة الطلب',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text(
                                currentOrder?.status
                                        .toString()
                                        .split('.')
                                        .last ??
                                    'جاري المعالجة',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            label: const Text('اتصال'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message),
                            label: const Text('مراسلة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        orderProvider.clearCurrentOrder();
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text('العودة للرئيسية'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
