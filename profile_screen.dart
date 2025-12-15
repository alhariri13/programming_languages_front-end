import 'package:flutter/material.dart';
import 'package:bbbb/home_page.dart';
import 'package:bbbb/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _signOutButton() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign out ?'),
        content: Text('Are you sure you want to sign out ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text('Yes'),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B609E),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,

            child: Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _signOutButton,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B609E),

                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                ),
                child: Text(
                  'My Rentals',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,

            child: Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _signOutButton,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B609E),

                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                ),
                child: Text(
                  'My Apartments',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,

            child: Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _signOutButton,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B609E),

                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,

            child: Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _signOutButton,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B609E),

                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                ),
                child: Text('Sign Out', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
