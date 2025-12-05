import 'package:flutter/material.dart';

class AddNewAppartmentScreen extends StatefulWidget {
  const AddNewAppartmentScreen({super.key});
  @override
  State<AddNewAppartmentScreen> createState() {
    return _AddNewApartmentScreenState();
  }
}

class _AddNewApartmentScreenState extends State<AddNewAppartmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Apartment', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3B609E),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }
}
