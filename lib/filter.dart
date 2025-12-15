import 'package:flutter/material.dart';

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

  String _getGovernorateName(Governorate governorate) {
    return governorate.name[0].toUpperCase() + governorate.name.substring(1);
  }

  InputDecoration _getInputDecoration(String labelText, {Widget? prefix}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white70),
      prefix: prefix,
      filled: true,
      fillColor: _cardColor,
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
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          (keyBoaredspace + 16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Settings / Filter',
                    style: TextStyle(
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

              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration('City'),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white),
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration(
                  'Price',
                  prefix: Text('\$', style: TextStyle(color: _blueAccent)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration('Space'),
              ),
              const SizedBox(height: 20),
              
              TextField(
                style: const TextStyle(color: Colors.white),
                maxLength: 1,
                keyboardType: TextInputType.number,
                decoration: _getInputDecoration('Number of rooms'),
              ),
              const SizedBox(height: 20),

              InputDecorator(
                decoration: _getInputDecoration('Governorate'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Governorate>(
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: _cardColor,
                    isExpanded: true,
                    value: _selectedGovernorate,
                    icon: Icon(Icons.arrow_drop_down, color: _blueAccent),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: Governorate.values
                        .map(
                          (governorate) => DropdownMenuItem(
                            value: governorate,
                            child: Text(governorate.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedGovernorate = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Okay',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade600),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
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