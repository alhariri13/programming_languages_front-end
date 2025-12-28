import 'package:flutter/material.dart';
import 'package:get/get.dart'; // إضافة المكتبة
import 'package:home/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:home/login_screen.dart';

class SecondSignUpScreen extends StatefulWidget {
  const SecondSignUpScreen({super.key});

  @override
  State<SecondSignUpScreen> createState() => _NextPageState();
}

class _NextPageState extends State<SecondSignUpScreen> {
  File? _profileImage;
  File? _idImage;
  DateTime? _dateOfBirth;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2F66FF),
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/background_image.jpg", fit: BoxFit.cover),
          Container(color: const Color.fromARGB(100, 0, 0, 0)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 90),
                const Icon(Icons.home_outlined, size: 80, color: Colors.white),
                const SizedBox(height: 13),
                const Text(
                  "TANZAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Create Account".tr, // أضفنا .tr
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 35),

                // Email
                buildInputField(icon: Icons.email, hint: "email".tr), // أضفنا .tr
                const SizedBox(height: 15),

                // Phone
                buildInputField(icon: Icons.phone, hint: "phone number".tr), // أضفنا .tr
                const SizedBox(height: 15),

                // Date of Birth
                _buildDatePickerField(
                  icon: Icons.calendar_today,
                  hint: "Date of Birth".tr, // أضفنا .tr
                  date: _dateOfBirth,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 15),

                // Profile Picture
                _buildImagePickerField(
                  icon: Icons.image,
                  hint: "Select Profile Picture".tr, // أضفنا .tr
                  imageFile: _profileImage,
                  onTap: () => _pickImage(true),
                ),
                const SizedBox(height: 15),

                // ID Picture
                _buildImagePickerField(
                  icon: Icons.badge,
                  hint: "Select ID Picture".tr, // أضفنا .tr
                  imageFile: _idImage,
                  onTap: () => _pickImage(false),
                ),

                const SizedBox(height: 35),

                // Create Button
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Create".tr, // أضفنا .tr
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ".tr, // أضفنا .tr
                      style: const TextStyle(color: Colors.white),
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
                      child: Text(
                        "Login".tr, // أضفنا .tr
                        style: const TextStyle(
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

  Widget _buildDatePickerField({
    required IconData icon,
    required String hint,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
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
                    : "${'Image Selected'.tr}: ${imageFile.path.split('/').last}", // أضفنا ترجمة لحالة الاختيار
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