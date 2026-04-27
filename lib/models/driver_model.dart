class DriverModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String phone; // حقل الهاتف للتواصل
  final double rating; // حقل التقييم

  DriverModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.rating,
  });

  // لتحويل البيانات القادمة من Firestore إلى كائن (Object) في فلاتر
  factory DriverModel.fromFirestore(String id, Map<String, dynamic> data) {
    return DriverModel(
      id: id,
      name: data['name'] ?? '',
      // استخدام (as num).toDouble() يحل مشكلة تعليق النوع في Firebase
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      phone: data['phone'] ?? '',
      // قراءة التقييم مع معالجة القيم الفارغة (null)
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }

  // لتحويل الكائن إلى Map عند الرغبة في تحديث بيانات السائق بالكامل في Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'rating': rating,
    };
  }

  // مخصص لتتبع الموقع المباشر (Realtime Database)
  Map<String, dynamic> toLiveLocationMap() {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }
}
