import 'package:flutter/material.dart';
import 'package:tanzan/add_new_appartment_screen.dart';
import 'package:tanzan/filter.dart';
import 'package:tanzan/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  void _showFilterSheet() {
    showModalBottomSheet(context: context, builder: (ctx) => const Filter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        leading: IconButton(
          onPressed: _showFilterSheet,
          icon: Icon(Icons.filter_alt, color: Colors.white, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: Colors.white, size: 40),
          ),
        ],
        title: Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF3B609E),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home, color: Colors.white),
              iconSize: 40,
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: Colors.white),
              iconSize: 40,
            ),
            SizedBox(width: 16),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewAppartmentScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add_box_rounded, color: Colors.white),
              iconSize: 40,
            ),
            SizedBox(width: 16),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.white),
              iconSize: 40,
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              icon: Icon(Icons.account_box_rounded, color: Colors.white),
              iconSize: 40,
            ),
          ],
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background_image.jpg', fit: BoxFit.cover),
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 3 / 2,
            ),
            children: [
              Text(
                'home 1',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'home 2',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'home 3',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'home 4',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'home 5',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'home 6',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                'home 7',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
