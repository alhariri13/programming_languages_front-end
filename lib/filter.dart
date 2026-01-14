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

  final minimumPriceController = TextEditingController();
  final maximumPriceController = TextEditingController();
  final spaceController = TextEditingController();
  final numberOfRoomsController = TextEditingController();
  final numberOfBathRoomsController = TextEditingController();
  final titleController = TextEditingController();

  Governorate _selectedGovernorate = Governorate.damascus;
  String? _selectedCity;

  // Map from enum to plain English keys (used to access the cities map)
  final Map<Governorate, String> governorateKey = {
    Governorate.latakia: 'Latakia',
    Governorate.tartoos: 'Tartoos',
    Governorate.damascus: 'Damascus',
    Governorate.homs: 'Homs',
    Governorate.aleppo: 'Aleppo',
    Governorate.idlib: 'Idlib',
    Governorate.swidaa: 'Swidaa',
    Governorate.raqa: 'Raqa',
    Governorate.hasaka: 'Hasaka',
    Governorate.diralzor: 'Diralzor',
  };

  // Governorates and their cities (keys must match governorateKey values)
  final Map<String, List<String>> governorateCities = {
    'Latakia': ['Latakia (City)', 'Jableh', 'Al-Haffah', 'Slenfeh'],
    'Tartoos': ['Tartus (City)', 'Baniyas', 'Safita', 'Dreikish'],
    'Damascus': [
      'Al-Midan',
      'Baramkeh',
      'Kafar Souseh',
      'Malki',
      'Abu Rummaneh',
    ],
    'Homs': ['Homs (City)', 'Al-Qusayr', 'Tadmur', 'Al-Rastan'],
    'Aleppo': ['Aleppo (City)', 'Manbij', 'Azaz', 'Al-Bab'],
    'Idlib': ['Idlib (City)', 'Maarrat al-Numan', 'Jisr al-Shughur', 'Saraqib'],
    'Swidaa': ['Swidaa (City)', 'Al-Sanamayn', 'Daraa', 'Busra al-Sham'],
    'Raqa': ['Raqa (City)', 'Al-Thawrah', 'Al-Mansurah', 'Al-Jazrah'],
    'Hasaka': ['Hasaka (City)', 'Qamishli', 'Al-Malikiyah', 'Al-Darbasiyah'],
    'Diralzor': ['Diralzor (City)', 'Al-Mayadin', 'Al-Bukamal', 'Al-Shuhayl'],
  };

  // Translated label for enum (UI text)
  String _getTranslatedGovernorate(Governorate governorate) {
    return governorate.name.tr;
  }

  // Lookup key to fetch cities (stable key, not translated)
  String _getGovernorateKey(Governorate governorate) {
    return governorateKey[governorate]!;
  }

  InputDecoration _getInputDecoration(String labelText, {Widget? prefix}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white70),
      prefix: prefix,
      filled: true,
      fillColor: _cardColor,
      counterStyle: const TextStyle(color: Colors.white70),
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
  void dispose() {
    minimumPriceController.dispose();
    maximumPriceController.dispose();
    spaceController.dispose();
    numberOfRoomsController.dispose();
    numberOfBathRoomsController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoaredspace = MediaQuery.of(context).viewInsets.bottom;
    final currentGovKey = _getGovernorateKey(_selectedGovernorate);
    final currentCities = governorateCities[currentGovKey] ?? const <String>[];

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

              // Governorate Dropdown
              DropdownButtonFormField<Governorate>(
                value: _selectedGovernorate,
                decoration: _getInputDecoration('Governorate'.tr),
                dropdownColor: _cardColor,
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
                      _selectedCity =
                          null; // reset city when governorate changes
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // City Dropdown (depends on governorate)
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: _getInputDecoration('City'.tr),
                dropdownColor: _cardColor,
                icon: Icon(Icons.arrow_drop_down, color: _blueAccent),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                items: currentCities
                    .map(
                      (city) =>
                          DropdownMenuItem(value: city, child: Text(city.tr)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration('Title'.tr),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: minimumPriceController,
                style: const TextStyle(color: Colors.white),
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration(
                  'Minimum price'.tr,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: _blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: maximumPriceController,
                style: const TextStyle(color: Colors.white),
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration(
                  'Maximum price'.tr,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: _blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: spaceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration('Space'.tr),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: numberOfRoomsController,
                style: const TextStyle(color: Colors.white),
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration('Number of rooms'.tr),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: numberOfBathRoomsController,
                style: const TextStyle(color: Colors.white),
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration('Number of bathrooms'.tr),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'governorate': _getGovernorateKey(
                            _selectedGovernorate,
                          ), // stable key
                          'governorateLabel': _getTranslatedGovernorate(
                            _selectedGovernorate,
                          ), // translated label
                          'city': _selectedCity,
                          'title': titleController.text,
                          'minPrice': minimumPriceController.text,
                          'maxPrice': maximumPriceController.text,
                          'space': spaceController.text,
                          'rooms': numberOfRoomsController.text,
                          'bathrooms': numberOfBathRoomsController.text,
                        });
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
