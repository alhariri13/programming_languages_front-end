import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanzan/providers/ip_provider.dart';
import 'package:tanzan/providers/token_provider.dart';

class EditApartmentScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> apartmentData;

  const EditApartmentScreen({super.key, required this.apartmentData});

  @override
  ConsumerState<EditApartmentScreen> createState() =>
      _EditApartmentScreenState();
}

class _EditApartmentScreenState extends ConsumerState<EditApartmentScreen> {
  late TextEditingController descriptionController;
  late TextEditingController addressController;
  late TextEditingController priceController;
  late TextEditingController bedroomsController;
  late TextEditingController bathroomsController;

  String? selectedTitle;
  String? selectedCity;
  String? selectedState;

  final List<String> _titleOptions = [
    'Apartment',
    'Villa',
    'Chalet',
    'Studio',
    'Duplex',
  ];

  final List<String> _cityOptions = [
    'Latakia',
    'Tartoos',
    'Homs',
    'Aleppo',
    'Damascus',
    'Idlib',
    'Swidaa',
    'Raqa',
    'Hasaka',
    'Diralzor',
  ];

  final Map<String, List<String>> _stateOptionsMap = {
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

  @override
  void initState() {
    super.initState();
    final data = widget.apartmentData;

    descriptionController = TextEditingController(
      text: data['description']?.toString() ?? '',
    );
    addressController = TextEditingController(
      text: data['address']?.toString() ?? '',
    );
    priceController = TextEditingController(
      text: data['price_per_night']?.toString() ?? '',
    );
    bedroomsController = TextEditingController(
      text: data['number_of_bedrooms']?.toString() ?? '',
    );
    bathroomsController = TextEditingController(
      text: data['number_of_bathrooms']?.toString() ?? '',
    );

    selectedTitle = data['title']?.toString();
    selectedCity = data['city']?.toString();
    selectedState = data['state']?.toString();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    addressController.dispose();
    priceController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    super.dispose();
  }

  Future<void> submitChanges() async {
    final updatedApartment = {
      "title": selectedTitle,
      "description": descriptionController.text,
      "address": addressController.text,
      "city": selectedCity,
      "state": selectedState,
      "price_per_night": double.tryParse(priceController.text) ?? 0,
      "number_of_bedrooms": int.tryParse(bedroomsController.text) ?? 0,
      "number_of_bathrooms": int.tryParse(bathroomsController.text) ?? 0,
    };

    try {
      final token = ref.read(tokenProvider);
      final ip = ref.read(ipProvider.notifier).state;
      final response = await http.put(
        Uri.parse(
          "http://$ip:8000/api/user/apartments/${widget.apartmentData['id']}",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(updatedApartment),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Apartment updated successfully")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateOptions =
        selectedCity != null && _stateOptionsMap.containsKey(selectedCity)
        ? _stateOptionsMap[selectedCity]!
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Apartment"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title Dropdown
            DropdownButtonFormField<String>(
              value: selectedTitle,
              items: _titleOptions.map((title) {
                return DropdownMenuItem<String>(
                  value: title,
                  child: Text(title),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTitle = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            _buildField("Description", descriptionController),
            _buildField("Address", addressController),

            DropdownButtonFormField<String>(
              value: selectedCity,
              items: _cityOptions.map((city) {
                return DropdownMenuItem<String>(value: city, child: Text(city));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  selectedState = null;
                });
              },
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedState,
              items: stateOptions.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),
            _buildField(
              "Price per Night",
              priceController,
              keyboardType: TextInputType.number,
            ),
            _buildField(
              "Bedrooms",
              bedroomsController,
              keyboardType: TextInputType.number,
            ),
            _buildField(
              "Bathrooms",
              bathroomsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitChanges,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
