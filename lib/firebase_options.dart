import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// إعدادات Firebase الافتراضية لمنصات الويب والأندرويد.
/// تم تعديل الـ databaseURL ليتوافق مع سيرفر المشروع (europe-west1).
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

  // إعدادات الويب
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIEydxMt3cJDQpepbVs15vxsNA_8QLw5Q',
    authDomain: 'siqayah-app.firebaseapp.com',
    projectId: 'siqayah-app',
    storageBucket: 'siqayah-app.firebasestorage.app',
    messagingSenderId: '551952359148',
    appId: '1:551952359148:web:b2a5d5d5843e8e2c940fc9',
    // الرابط المصحح ليعمل مع Realtime Database في بلجيكا
    databaseURL:
        'https://siqayah-app-default-rtdb.europe-west1.firebasedatabase.app',
  );

  // إعدادات الأندرويد
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIEydxMt3cJDQpepbVs15vxsNA_8QLw5Q',
    // ملاحظة: تأكد من نسخ الـ App ID الحقيقي للأندرويد من Firebase Console
    // بدلاً من الرقم الموجود بالأسفل إذا كان مختلفاً.
    appId: '1:551952359148:android:b2a5d5d5843e8e2c940fc9',
    messagingSenderId: '551952359148',
    projectId: 'siqayah-app',
    storageBucket: 'siqayah-app.firebasestorage.app',
    // الرابط المصحح للأندرويد
    databaseURL:
        'https://siqayah-app-default-rtdb.europe-west1.firebasedatabase.app',
  );
}
