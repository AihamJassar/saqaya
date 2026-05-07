import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/theme_mode_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _themeModeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'وضع النظام';
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'داكن';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = userProvider.user;
    final colorScheme = Theme.of(context).colorScheme;

    return MainLayout(
      title: 'الملف الشخصي',
      currentIndex: 2,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 60,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'مستخدم',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.phone ?? 'رقم الهاتف',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            ListTile(
              leading: Icon(Icons.language, color: colorScheme.primary),
              title: const Text('اللغة'),
              trailing: const Text('العربية'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.palette_outlined, color: colorScheme.primary),
              title: const Text('المظهر'),
              subtitle: Text(_themeModeLabel(themeProvider.themeMode)),
              trailing: const ThemeModeButton(),
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: colorScheme.primary),
              title: const Text('الإشعارات'),
              trailing: Switch(
                value: true,
                onChanged: (val) {},
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: colorScheme.primary),
              title: const Text(
                'المساعدة والدعم',
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: colorScheme.primary),
              title: const Text('عن التطبيق'),
              onTap: () {},
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  userProvider.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
