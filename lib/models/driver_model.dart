class DriverModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double rating;

  DriverModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.rating,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DriverModel(
      id: documentId,
      name: map['name'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
    };
  }

  // For Realtime Database tracking
  Map<String, dynamic> toLiveLocationMap() {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }
}
