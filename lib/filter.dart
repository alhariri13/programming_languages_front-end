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
  Governorate _selectedGovernorate = Governorate.damascus;
  @override
  Widget build(BuildContext context) {
    final keyBoaredspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraint) {
        return Padding(
          padding: EdgeInsetsGeometry.fromLTRB(
            16,
            16,
            16,
            (keyBoaredspace + 16),
          ),
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      label: Text('City'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Text('\$'),
                      label: Text('Price'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  TextField(
                    decoration: InputDecoration(
                      label: Text('space'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text('Number of rooms'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  DropdownButton(
                    borderRadius: BorderRadius.circular(20),
                    isExpanded: true,
                    value: _selectedGovernorate,
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

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Okay'),
                        ),
                      ),

                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
