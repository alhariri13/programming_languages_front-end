import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Governorate {
  tartoos,
  homs,
  aleppo,
  latakia,
  damascus,
  idlib,
  swidaa,
  raqa,
  hasaka,
  diralzor,
}

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() {
    return _FilterState();
  }
}

class _FilterState extends State<Filter> {
  final Color _darkBackground = const Color(0xFF1B1C27);
  final Color _cardColor = const Color(0xFF282A3A);
  final Color _blueAccent = Colors.blueAccent;

  Governorate _selectedGovernorate = Governorate.damascus;

  // دالة محسنة لجلب الاسم المترجم مباشرة من الـ enum
  String _getTranslatedGovernorate(Governorate governorate) {
    return governorate.name.tr; 
  }

  InputDecoration _getInputDecoration(String labelText, {Widget? prefix}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white70),
      prefix: prefix,
      filled: true,
      fillColor: _cardColor,
      counterStyle: const TextStyle(color: Colors.white70), // لتلوين عداد الحروف
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: _blueAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyBoaredspace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: _darkBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, (keyBoaredspace + 16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings / Filter'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 25),
              const SizedBox(height: 20),
              
              // قائمة المحافظات المترجمة
              InputDecorator(
                decoration: _getInputDecoration('Governorate'.tr),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Governorate>(
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: _cardColor,
                    isExpanded: true,
                    value: _selectedGovernorate,
                    icon: Icon(Icons.arrow_drop_down, color: _blueAccent),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: Governorate.values.map((governorate) {
                      return DropdownMenuItem(
                        value: governorate,
                        child: Text(_getTranslatedGovernorate(governorate)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGovernorate = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration('City'.tr),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white),
                maxLength: 10, // زدت الطول للسعر ليكون منطقي أكثر
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration(
                  'Price'.tr,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('\$', style: TextStyle(color: _blueAccent, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration('Space'.tr),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white),
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration('Number of rooms'.tr),
              ),
              
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Okay'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade600),
                        ),
                      ),
                      child: Text(
                        'Cancel'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}