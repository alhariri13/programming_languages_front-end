import 'package:flutter/material.dart';
import 'package:tanzan/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tanzan/login_screen.dart';

// يتم تحويلها إلى StatefulWidget لتتمكن من تخزين حالة التاريخ والصور
class SecondSignUpScreen extends StatefulWidget {
  const SecondSignUpScreen({super.key});

  @override
  State<SecondSignUpScreen> createState() => _NextPageState();
}

class _NextPageState extends State<SecondSignUpScreen> {
  // متغيرات لتخزين مسار الصورة المختارة لكل حقل
  File? _profileImage;
  File? _idImage;
  // متغير جديد لتخزين تاريخ الميلاد
  DateTime? _dateOfBirth;

  // دالة لاختيار صورة باستخدام image_picker
  Future<void> _pickImage(bool isProfileImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
        } else {
          _idImage = File(pickedFile.path);
        }
      });
    }
  }

  // دالة جديدة لاختيار التاريخ باستخدام DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ??
          DateTime.now(), // ابدأ بالتاريخ الحالي أو التاريخ المختار مسبقاً
      firstDate: DateTime(1900), // أقدم تاريخ يمكن اختياره
      lastDate: DateTime.now(), // لا يمكن اختيار تاريخ مستقبلي
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            // تخصيص الثيم ليتناسب مع الخلفية الداكنة
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2F66FF), // لون مميز للـ DatePicker
              onPrimary: Colors.white,
              surface: Colors.black54,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black87,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية
          Image.asset("assets/background_image.jpg", fit: BoxFit.cover),

          // طبقة تعتيم
          Container(color: const Color.fromARGB(100, 0, 0, 0)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 90),

                const Icon(Icons.home, size: 80, color: Colors.white),

                const SizedBox(height: 13),

                // عنوان التطبيق
                const Text(
                  "Smart Home Access",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // عنوان إنشاء حساب
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 35),

                // Email
                buildInputField(icon: Icons.email, hint: "email"),
                const SizedBox(height: 15),

                // Phone
                buildInputField(icon: Icons.phone, hint: "phone number"),
                const SizedBox(height: 15),

                // حقل تاريخ الميلاد (الجديد)
                _buildDatePickerField(
                  icon: Icons.calendar_today,
                  hint: "Date of Birth",
                  date: _dateOfBirth,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 15),

                // حقل اختيار "picture" (صورة الملف الشخصي)
                _buildImagePickerField(
                  icon: Icons.image,
                  hint: "Select Profile Picture",
                  imageFile: _profileImage,
                  onTap: () => _pickImage(true),
                ),
                const SizedBox(height: 15),

                // حقل اختيار "ID picture" (صورة الهوية)
                _buildImagePickerField(
                  icon: Icons.badge,
                  hint: "Select ID Picture",
                  imageFile: _idImage,
                  onTap: () => _pickImage(false),
                ),

                const SizedBox(height: 35),

                // زر إنشاء حساب
                SizedBox(
                  height: 50,
                  width: 175,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B609E),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 60,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // نص الانتقال لتسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء حقل اختيار التاريخ (الجديد)
  Widget _buildDatePickerField({
    required IconData icon,
    required String hint,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    // تنسيق التاريخ للعرض
    String displayDate = date != null
        ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
        : hint;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                displayDate,
                style: TextStyle(
                  color: date == null ? Colors.white70 : Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء حقل اختيار الصورة (كما هي)
  Widget _buildImagePickerField({
    required IconData icon,
    required String hint,
    required File? imageFile,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                imageFile == null
                    ? hint
                    : "Image Selected: ${imageFile.path.split('/').last}",
                style: TextStyle(
                  color: imageFile == null ? Colors.white70 : Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (imageFile != null)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.check_circle, color: Colors.greenAccent),
              ),
          ],
        ),
      ),
    );
  }
}

// الدالة المساعدة لإنشاء حقول الإدخال النصية (كما هي)
Widget buildInputField({
  required IconData icon,
  required String hint,
  bool obscure = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.25),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.white),
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
      ),
    ),
  );
}
