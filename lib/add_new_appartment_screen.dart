import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'apartment_controller.dart';

class AddNewAppartmentScreen extends StatefulWidget {
  // هذه المتغيرات ضرورية لاستقبال البيانات عند الضغط على زر التعديل
  final bool isEditing;
  final Map<String, dynamic>? apartmentData;
  final int? index;

  const AddNewAppartmentScreen({
    super.key, 
    this.isEditing = false, 
    this.apartmentData, 
    this.index
  });

  @override
  State<AddNewAppartmentScreen> createState() => _AddNewAppartmentScreenState();
}

class _AddNewAppartmentScreenState extends State<AddNewAppartmentScreen> {
  // تعريف الكنترولر للوصول لبيانات الشقق
  final ApartmentController _controller = Get.find<ApartmentController>();
  
  // المتغيرات الخاصة بالقوائم والبيانات كما هي في تصميمك الأصلي
  String? _selectedTitleType;
  String? _selectedCity;
  String? _selectedState;

  final List<String> _titleOptions = ['Apartment', 'Villa', 'Chalet', 'Studio', 'Duplex'];
  final List<String> _cityOptions = ['Latakia', 'Tartoos', 'Homs', 'Aleppo', 'Damascus', 'Idlib', 'Swidaa', 'Raqa', 'Hasaka', 'Diralzor', ' '];
  
  final Map<String, List<String>> _stateOptionsMap = {
    'Latakia': ['Latakia (City)', 'Jableh', 'Al-Haffah', 'Slenfeh'],
    'Tartoos': ['Tartus (City)', 'Baniyas', 'Safita', 'Dreikish'],
    'Damascus': ['Al-Midan', 'Baramkeh', 'Kafar Souseh', 'Malki', 'Abu Rummaneh'],
    'Homs': ['Homs (City)', 'Al-Qusayr', 'Tadmur', 'Al-Rastan'],
    'Aleppo': ['Aleppo (City)', 'Manbij', 'Azaz', 'Al-Bab'],
    'Idlib': ['Idlib (City)', 'Maarrat al-Numan', 'Jisr al-Shughur', 'Saraqib'],
    'Swidaa': ['Swidaa (City)', 'Al-Sanamayn', 'Daraa', 'Busra al-Sham'],
    'Raqa': ['Raqa (City)', 'Al-Thawrah', 'Al-Mansurah', 'Al-Jazrah'],
    'Hasaka': ['Hasaka (City)', 'Qamishli', 'Al-Malikiyah', 'Al-Darbasiyah'],
    'Diralzor': ['Diralzor (City)', 'Al-Mayadin', 'Al-Bukamal', 'Al-Shuhayl'],
  };

  int _bedrooms = 2;
  int _bathrooms = 2;
  final List<File> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  // الكنترولرز الخاصة بحقول النص
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تعبئة البيانات تلقائياً إذا كنا في وضع التعديل
    if (widget.isEditing && widget.apartmentData != null) {
      _selectedTitleType = widget.apartmentData!['title'];
      _priceController.text = widget.apartmentData!['price']?.toString().replaceAll(' \$', '') ?? '';
      _descriptionController.text = widget.apartmentData!['description'] ?? '';
      _areaController.text = widget.apartmentData!['area'] ?? '';
      _addressController.text = widget.apartmentData!['address'] ?? '';
      _bedrooms = widget.apartmentData!['bedrooms'] ?? 2;
      _bathrooms = widget.apartmentData!['bathrooms'] ?? 2;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage(imageQuality: 70);
    if (selectedImages.isNotEmpty) {
      setState(() {
        for (var xFile in selectedImages) {
          _pickedImages.add(File(xFile.path));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1B1C27),
      appBar: _buildAppBar(context),
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, left: 18.0, right: 18.0, bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionTitle('Property Information'),
                _buildDropdownField<String>(
                  label: 'Property Type (Title)',
                  value: _selectedTitleType,
                  hint: 'Select Property Type',
                  items: _titleOptions,
                  onChanged: (newValue) => setState(() => _selectedTitleType = newValue),
                  icon: Icons.home_work,
                ),
                _buildMultiLineTextField('Description', hint: 'Detail all features and amenities', controller: _descriptionController),
                const SizedBox(height: 20),
                _buildSectionTitle('Property Photos'),
                _buildPhotosSection(),
                const SizedBox(height: 30),
                _buildSectionTitle('Location Details'),
                _buildDropdownField<String>(
                  label: 'State',
                  value: _selectedCity,
                  hint: 'Select State',
                  items: _cityOptions,
                  onChanged: (newValue) => setState(() { _selectedCity = newValue; _selectedState = null; }),
                  icon: Icons.location_city,
                ),
                _buildDropdownField<String>(
                  label: 'City',
                  value: _selectedState,
                  hint: _selectedCity == null ? 'Select State first' : 'Select City',
                  items: _selectedCity != null ? (_stateOptionsMap[_selectedCity] ?? []) : [],
                  onChanged: (newValue) => setState(() => _selectedState = newValue),
                  icon: Icons.landscape,
                  isEnabled: _selectedCity != null,
                ),
                _buildTextField('Address (Major Area)', hint: 'Enter street name or major landmark', icon: Icons.location_on, controller: _addressController),
                const SizedBox(height: 30),
                _buildSectionTitle('Features & Specs'),
                _buildFeaturesRow(),
                _buildTextField('Area (m²)', hint: 'Total area', keyboardType: TextInputType.number, controller: _areaController),
                const SizedBox(height: 30),
                _buildSectionTitle('Pricing'),
                _buildPriceField(controller: _priceController),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 23.5, top: 5.0, bottom: 8.0),
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(backgroundColor: const Color(0xFF3B609E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ),
      title: Text(widget.isEditing ? 'Edit Apartment' : 'Add new appartment', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: TextButton(
            onPressed: () {
              // حفظ البيانات وإرسالها للكنترولر
              final data = {
                'title': _selectedTitleType ?? 'Apartment',
                'price': '${_priceController.text} \$',
                'image': _pickedImages.isNotEmpty ? _pickedImages[0].path : (widget.isEditing ? widget.apartmentData!['image'] : 'assets/background_image.jpg'),
                'isLocal': _pickedImages.isNotEmpty || (widget.isEditing && widget.apartmentData!['isLocal'] == true),
                'description': _descriptionController.text,
                'address': _addressController.text,
                'bedrooms': _bedrooms,
                'bathrooms': _bathrooms,
                'area': _areaController.text,
              };

              if (widget.isEditing) {
                _controller.updateApartment(widget.index!, data);
              } else {
                _controller.addApartment(data);
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(backgroundColor: const Color(0xFF3B609E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text(widget.isEditing ? 'Update' : 'Post', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- دوال الـ UI المساعدة كما صممتها أنت ---
  Widget _buildBackground() => Container(color: const Color(0xFF1B1C27));

  Widget _buildPhotosSection() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildAddPhotoButton(),
          const SizedBox(width: 15),
          ..._pickedImages.asMap().entries.map((e) => _buildPhotoCard(e.value, e.key)).toList(),
          if (_pickedImages.isEmpty) _buildPhotoPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(File file, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        children: [
          Container(width: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: FileImage(file), fit: BoxFit.cover))),
          Positioned(top: 5, right: 5, child: InkWell(onTap: () => setState(() => _pickedImages.removeAt(index)), child: const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.close, size: 16, color: Colors.white)))),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        decoration: BoxDecoration(color: const Color(0xFF282A3A).withOpacity(0.8), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue, width: 2)),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Icon(Icons.add_a_photo, color: Colors.blue, size: 30), Text('Upload Photos', style: TextStyle(color: Colors.blue, fontSize: 13))]),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() => Container(width: 120, decoration: BoxDecoration(color: const Color(0xFF282A3A).withOpacity(0.8), borderRadius: BorderRadius.circular(15)), child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 30)));

  Widget _buildTextField(String label, {IconData? icon, String? hint, TextInputType keyboardType = TextInputType.text, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: const Color(0xFF282A3A).withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
          child: TextField(controller: controller, keyboardType: keyboardType, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none, prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null)),
        ),
      ]),
    );
  }

  Widget _buildDropdownField<T>({required String label, required T? value, required String hint, required List<T> items, required ValueChanged<T?> onChanged, required IconData icon, bool isEnabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: isEnabled ? const Color(0xFF282A3A).withOpacity(0.8) : const Color(0xFF282A3A).withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(value: value, hint: Text(hint, style: TextStyle(color: isEnabled ? Colors.grey : Colors.grey.withOpacity(0.5))), isExpanded: true, dropdownColor: const Color(0xFF282A3A), style: const TextStyle(color: Colors.white), items: items.map<DropdownMenuItem<T>>((T item) => DropdownMenuItem<T>(value: item, child: Text(item.toString()))).toList(), onChanged: isEnabled ? onChanged : null),
          ),
        ),
      ]),
    );
  }

  Widget _buildMultiLineTextField(String label, {String? hint, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: const Color(0xFF282A3A).withOpacity(0.8), borderRadius: BorderRadius.circular(12)), child: TextField(controller: controller, style: const TextStyle(color: Colors.white), maxLines: 4, decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none))),
      ]),
    );
  }

  Widget _buildFeaturesRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(children: [
        Expanded(child: _buildStepperField('Bedrooms', Icons.king_bed, _bedrooms, (val) => setState(() => _bedrooms = val))),
        const SizedBox(width: 15),
        Expanded(child: _buildStepperField('Bathrooms', Icons.bathtub, _bathrooms, (val) => setState(() => _bathrooms = val))),
      ]),
    );
  }

  Widget _buildStepperField(String label, IconData icon, int currentValue, Function(int) onChanged, {int minLimit = 1, int maxLimit = 10}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF282A3A).withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 5),
          Text('$currentValue', style: const TextStyle(color: Colors.white)),
          const Spacer(),
          InkWell(onTap: () => currentValue > minLimit ? onChanged(currentValue - 1) : null, child: const Icon(Icons.remove_circle_outline, color: Colors.redAccent)),
          const SizedBox(width: 8),
          InkWell(onTap: () => currentValue < maxLimit ? onChanged(currentValue + 1) : null, child: const Icon(Icons.add_circle_outline, color: Colors.blue)),
        ]),
      ),
    ]);
  }

  Widget _buildPriceField({required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: const Color(0xFF282A3A).withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
          child: TextField(controller: controller, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Enter daily rental price', suffixText: '\$/Day', border: InputBorder.none)),
        ),
      ]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(title, style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w900)),
    );
  }
}