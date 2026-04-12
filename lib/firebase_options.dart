import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // إعدادات الويب (التي نسختها أنت للتو)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIEydxMt3cJDQpepbVs15vxsNA_8QLw5Q',
    authDomain: 'siqayah-app.firebaseapp.com',
    projectId: 'siqayah-app',
    storageBucket: 'siqayah-app.firebasestorage.app',
    messagingSenderId: '551952359148',
    appId: '1:551952359148:web:b2a5d5d5843e8e2c940fc9',
  );

  // إعدادات الأندرويد (نفس البيانات الأساسية للمشروع)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIEydxMt3cJDQpepbVs15vxsNA_8QLw5Q',
    appId:
        '1:551952359148:web:b2a5d5d5843e8e2c940fc9', // في حال لم تنشئ تطبيق أندرويد بعد، سنستخدم هذا مؤقتاً
    messagingSenderId: '551952359148',
    projectId: 'siqayah-app',
    storageBucket: 'siqayah-app.firebasestorage.app',
  );
}
