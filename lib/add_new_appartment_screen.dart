import 'package:flutter/material.dart';
import 'dart:io'; // لاستخدام File
import 'package:image_picker/image_picker.dart'; // لاستخدام image_picker

class AddNewAppartmentScreen extends StatefulWidget {
  const AddNewAppartmentScreen({super.key});

  @override
  State<AddNewAppartmentScreen> createState() => _AddNewAppartmentScreenState();
}

class _AddNewAppartmentScreenState extends State<AddNewAppartmentScreen> {
  // متغيرات الحالة
  int _bedrooms = 2;
  int _bathrooms = 1;
  
  // **التعديل الجديد:** قائمة لتخزين ملفات الصور المختارة
  final List<File> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  // **الدالة الجديدة:** لاختيار صورة واحدة أو أكثر
  Future<void> _pickImage() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage(
      imageQuality: 70, // جودة الصورة لتقليل حجم الملف
    );

    if (selectedImages.isNotEmpty) {
      setState(() {
        for (var xFile in selectedImages) {
          // نضيف الصورة كـ File إلى القائمة
          _pickedImages.add(File(xFile.path));
        }
      });
    }
  }
  
  // **دالة لحذف صورة** (لإضافة وظيفة متكاملة)
  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1B1C27),
      appBar: _buildAppBar(context),
      
      body: Stack(
        children: <Widget>[
          _buildBackgroundWithBlur(),
          
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, left: 18.0, right: 18.0, bottom: 40.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // **تحديث استدعاء قسم الصور**
                _buildPhotosSection(),
                const SizedBox(height: 30),
                _buildSectionTitle('Core Details'),
                _buildTextField('Property Title', hint: 'Enter an attractive title'),
                _buildMultiLineTextField('Description', hint: 'Detail all features and amenities'),
                _buildDropdownField(),
                _buildTextField('Location', icon: Icons.location_on, hint: 'Select address or location'),
                const SizedBox(height: 30),
                _buildSectionTitle('Features & Specs'),
                _buildFeaturesRow(),
                _buildTextField('Area (Sq.ft)', hint: 'Enter total area', keyboardType: TextInputType.number),
                const SizedBox(height: 30),
                _buildSectionTitle('Pricing'),
                _buildPriceField(),
                
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ************ الدوال المساعدة (Helper Methods) ************
  
  // 1. الشريط العلوي (AppBar)
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, 
      elevation: 0,
      leadingWidth: 100, 

      // **زر Cancel**
      leading: Padding(
        padding: const EdgeInsets.only(left:23.5, top:5.0, bottom: 8.0), 
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF3B609E), 
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), 
          ),
          child: const Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), 
        ),
      ),
      title: const Text('Add new appartment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      centerTitle: true,
      actions: <Widget>[
        // زر Post
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: TextButton(
            onPressed: () {
              // منطق نشر العقار
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF3B609E),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // خلفية مع صورة وتعتيم خفيف (Opacity)
  Widget _buildBackgroundWithBlur() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: const Color(0xAA1B1C27),
      ),
    );
  }

  // **2. قسم الصور (المحدث)**
  Widget _buildPhotosSection() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // **1. زر الإضافة (يستدعي الدالة الجديدة)**
          _buildAddPhotoButton(),
          const SizedBox(width: 15),
          
          // **2. عرض الصور المختارة**
          ..._pickedImages.asMap().entries.map((entry) {
            int index = entry.key;
            File file = entry.value;
            return _buildPhotoCard(file, index);
          }).toList(),

          // يمكن إضافة أماكن صور فارغة إضافية هنا إذا أردت
          if (_pickedImages.length < 5) ...[
            _buildPhotoPlaceholder(),
            const SizedBox(width: 15),
          ],
        ],
      ),
    );
  }

  // **البطاقة التي تعرض الصورة المختارة مع زر للحذف**
  Widget _buildPhotoCard(File file, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // عرض الصورة من الملف
              image: DecorationImage(
                image: FileImage(file),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // زر الحذف
          Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: () => _removeImage(index),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // **زر إضافة صور (يستدعي دالة اختيار الصورة)**
  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImage, // **الاستدعاء الجديد هنا**
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF282A3A).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_a_photo, color: Colors.blue, size: 30),
            SizedBox(height: 5),
            Text('Upload Photos', style: TextStyle(color: Colors.blue, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // مكان صورة فارغ
  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF282A3A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.grey, size: 30),
      ),
    );
  }

  // باقي الدوال المساعدة (بدون تغيير كبير)

  Widget _buildTextField(String label, {IconData? icon, String? hint, TextInputType keyboardType = TextInputType.text}) {
    // ... (نفس التنفيذ السابق)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF282A3A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              keyboardType: keyboardType,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
                contentPadding: icon == null ? const EdgeInsets.symmetric(vertical: 15) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiLineTextField(String label, {String? hint}) {
    // ... (نفس التنفيذ السابق)
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF282A3A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    // ... (نفس التنفيذ السابق)
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Property Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF282A3A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: 'Apartment',
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              dropdownColor: const Color(0xFF282A3A),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              items: <String>['Apartment', 'Villa', 'Office', 'Commercial']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // ...
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // حقل زيادة/نقصان الأعداد (Stepper)
  Widget _buildStepperField(String label, IconData icon, int currentValue, Function(int) onChanged) {
    // ... (نفس التنفيذ السابق)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF282A3A).withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              const SizedBox(width: 5),
              Text('$currentValue', style: const TextStyle(color: Colors.white, fontSize: 16)),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (currentValue > 0) {
                    onChanged(currentValue - 1);
                  }
                },
                child: Icon(Icons.remove_circle_outline, color: currentValue > 0 ? Colors.redAccent : Colors.grey),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  onChanged(currentValue + 1);
                },
                child: const Icon(Icons.add_circle_outline, color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // صف خصائص (غرف نوم/حمامات)
  Widget _buildFeaturesRow() {
    // ... (نفس التنفيذ السابق)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(child: _buildStepperField(
            'Bedrooms', 
            Icons.king_bed, 
            _bedrooms, 
            (newValue) { setState(() => _bedrooms = newValue); }
          )),
          const SizedBox(width: 15),
          Expanded(child: _buildStepperField(
            'Bathrooms', 
            Icons.bathtub, 
            _bathrooms, 
            (newValue) { setState(() => _bathrooms = newValue); }
          )),
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    // ... (نفس التنفيذ السابق)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF282A3A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter total price',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixText: '\$',
                suffixStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    // ... (نفس التنفيذ السابق)
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}