import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:home/languge.dart';
import 'package:home/login_screen.dart';
import 'package:home/edit_screen.dart';
import 'package:home/myapartment_screen.dart';
import 'package:home/booking_history.dart';
import 'package:home/wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // قائمة الخيارات
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.edit_outlined, 
        'title': 'Edit Profile'.tr, 
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditScreen()))
      },
      {
        'icon': Icons.apartment_outlined, 
        'title': 'My Apartment'.tr, 
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApartmentScreen()))
      },
      {
        'icon': Icons.history_rounded, 
        'title': 'Booking History'.tr, 
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingHistoryScreen()))
      },
      {
        'icon': Icons.language_outlined, 
        'title': 'Language'.tr, 
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageScreen()))
      },
      {
        'icon': Icons.wallet_outlined, 
        'title': 'wallet'.tr, 
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MiniWalletSheet()))
      },
      {
        'icon': Icons.logout_rounded, 
        'title': 'Log Out'.tr, 
        'onTap': () => _showLogoutDialog(context)
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.maybePop(context),
        ),
        // تم استبدال Row بـ title و actions لضمان توزيع العناصر بشكل صحيح
        title: Text(
          'Profile'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white, size: 30),
            onPressed: () {
              Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            },
          ),
          const SizedBox(width: 10), // مسافة بسيطة من جهة اليمين
        ],
      ),
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // الصورة الشخصية
                  Center(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: const Color(0xFF3B5998),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: profileImageUrl != null ? AssetImage(profileImageUrl!) : null,
                        child: profileImageUrl == null 
                            ? const Icon(Icons.person, size: 80, color: Colors.white54) 
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(userEmail, style: const TextStyle(fontSize: 16, color: Colors.white60)),
                  const SizedBox(height: 30),

                  // الشبكة (Grid)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildSquareMenuItem(
                        icon: menuItems[index]['icon'],
                        title: menuItems[index]['title'],
                        onTap: menuItems[index]['onTap'],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3B5998).withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 35),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out".tr),
          content: Text("Are you sure you want to log out?".tr),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel".tr)),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: Text("OK".tr),
            ),
          ],
        );
      },
    );
  }
}