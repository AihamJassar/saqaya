import 'package:firebase_database/firebase_database.dart';

class RealtimeService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Listen to live location of a specific driver
  Stream<Map<String, double>> getDriverLiveLocation(String driverId) {
    return _db.ref('drivers_live/$driverId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return {
          'lat': (data['lat'] ?? 0.0).toDouble(),
          'lng': (data['lng'] ?? 0.0).toDouble(),
        };
      }
      return {'lat': 0.0, 'lng': 0.0};
    });
  }

  // Update driver live location (for driver app side)
  Future<void> updateDriverLocation(String driverId, double lat, double lng) async {
    await _db.ref('drivers_live/$driverId').set({
      'lat': lat,
      'lng': lng,
      'timestamp': ServerValue.timestamp,
    });
  }
}
