import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // تعريف المتغيرات والمتحكمات
  File? _image;
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "johndoe@email.com");
  final TextEditingController _phoneController = TextEditingController(text: "+963 9xx xxx xxx");

  // دالة جلب الصورة من الاستوديو
  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          _image = File(selectedImage.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // خلفية داكنة متناسقة مع الثيم
      appBar: AppBar(
        title:  Text('Edit Profile'.tr, style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            children: [
              // قسم الصورة الشخصية مع قابلية الضغط
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF3B5998), width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey[900],
                          // تبديل بين الصورة المختارة والافتراضية
                          backgroundImage: _image != null 
                              ? FileImage(_image!) 
                              : const AssetImage('assets/tanzan.png') as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF3B5998),
                          radius: 18,
                          child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
               Text(
                "Tap to change photo".tr,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 40),

              // حقول الإدخال
              _buildTextField("Full Name".tr, Icons.person_outline, _nameController),
              const SizedBox(height: 20),
              _buildTextField("Email Address".tr, Icons.email_outlined, _emailController),
              const SizedBox(height: 20),
              _buildTextField("Phone Number".tr, Icons.phone_android_outlined, _phoneController),
              
              const SizedBox(height: 50),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B5998),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  onPressed: () {
                    // هنا نضع كود الحفظ أو الإرسال للسيرفر
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text("Changes Saved Successfully!".tr)),
                    );
                    Navigator.pop(context);
                  },
                  child:  Text(
                    "SAVE CHANGES".tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت بناء الحقل النصي بتصميم عصري
  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF3B5998)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF3B5998), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}