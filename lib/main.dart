import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// استيراد الملف الذي أنشأته يدوياً
import 'firebase_options.dart';

import 'providers/user_provider.dart';
import 'providers/order_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_screen.dart';
import 'screens/driver_tracking_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  // التأكد من تهيئة الـ Widgets
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase باستخدام الخيارات المحددة (لحل مشكلة Unused import والشاشة الحمراء)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // تم إضافة هذا السطر هنا
    );
  } catch (e) {
    print('Firebase Initialization Error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const WaterDeliveryApp(),
    ),
  );
}

class WaterDeliveryApp extends StatelessWidget {
  const WaterDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سقيا - توصيل مياه',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      locale: const Locale('ar', 'SA'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Cairo',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/order': (context) => const OrderScreen(),
        '/tracking': (context) => const DriverTrackingScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
