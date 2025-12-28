import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'localization_service.dart'; // تأكد أن الاسم صحيح

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_language'.tr), // كلمة مترجمة
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language, size: 100, color: Color(0xFF3B609E)),
            const SizedBox(height: 40),
            
            // خيار اللغة الإنجليزية
            _buildLanguageCard(
              title: 'English',
              subtitle: 'Select English as your language',
              icon: '🇺🇸',
              onTap: () {
                Get.updateLocale(const Locale('en'));
                LocalizationService().saveLocale(false);
                Get.back(); // العودة للواجهة السابقة
              },
            ),
            
            const SizedBox(height: 20),
            
            // خيار اللغة العربية
            _buildLanguageCard(
              title: 'العربية',
              subtitle: 'اختر اللغة العربية لغة افتراضية',
              icon: '🇸🇦',
              onTap: () {
                Get.updateLocale(const Locale('ar'));
                LocalizationService().saveLocale(true);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Text(icon, style: const TextStyle(fontSize: 30)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}