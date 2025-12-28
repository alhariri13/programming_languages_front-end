import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'apartment_controller.dart';
import 'add_new_appartment_screen.dart';

class MyApartmentScreen extends StatelessWidget {
  const MyApartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حل مشكلة "Controller not found" عبر وضع Get.put هنا
    final ApartmentController controller = Get.put(ApartmentController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('My Apartment'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/background_image.jpg'), fit: BoxFit.cover)),
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
          SafeArea(
            child: Obx(() => controller.myApartments.isEmpty
                ? Center(child: Text('No apartments yet'.tr, style: TextStyle(color: Colors.white70)))
                : ListView.builder(
                    itemCount: controller.myApartments.length,
                    itemBuilder: (context, index) => _buildPostCard(controller.myApartments[index], index, controller),
                  )),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> property, int index, ApartmentController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      color: const Color(0xFF282A3A).withOpacity(0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(property['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(property['price'] ?? '', style: const TextStyle(color: Colors.blueAccent)),
          ),
          AspectRatio(
            aspectRatio: 1.2,
            child: property['isLocal'] == true
                ? Image.file(File(property['image']), fit: BoxFit.cover)
                : Image.asset(property['image'], fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_note, color: Colors.greenAccent, size: 30),
                  onPressed: () => Get.to(() => AddNewAppartmentScreen(isEditing: true, apartmentData: property, index: index)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                  onPressed: () => controller.deleteApartment(index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}