import 'package:flutter/material.dart';
import 'package:get/get.dart'; // إضافة المكتبة
import 'package:home/first_sign_up_screen.dart';
import 'package:flutter/services.dart';
import 'package:home/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //  Password Visibility
  bool _isPasswordVisible = false;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _loginButton() {
    if (_phoneController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          // استخدام .tr مع نصوصك الأصلية كمفاتيح
          title: Text('Invalid Input'.tr), 
          content: Text('please make sure that you have already fill all the gaps'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'.tr),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // إزالة Directionality الثابت لكي تتغير الواجهة (يمين/يسار) تلقائياً حسب اللغة
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          _buildBackgroundImage(),

          // 2. Dark Overlay for better text visibility
          _buildOverlay(),

          // 3. Main Content (Logo, Fields, Buttons)
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(color: Colors.black.withOpacity(0.4));
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),

            // 4. App Logo/Icon (House icon)
            const Icon(Icons.home_outlined, color: Colors.white, size: 70.0),
            const SizedBox(height: 20),

            // 5. Welcome Text
            const Text(
              'TANZAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Your Swift Key to the Dream Home....'.tr, // أضفنا .tr
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300
              ),
            ),
            const SizedBox(height: 50),

            // 6. Phone Number Input Field
            _buildInputField(
              hintText: 'phone number'.tr, // أضفنا .tr
              icon: Icons.phone_outlined,
              isPhoneNumber: true,
              controller: _phoneController,
            ),
            const SizedBox(height: 15),

            _buildInputField(
              hintText: 'Password'.tr, // أضفنا .tr
              controller: _passwordController,
              icon: Icons.lock_outline,
              isPassword: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            // 8. "Forgot Password?" Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?'.tr, // أضفنا .tr
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 9. Login Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _loginButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B609E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'LOGIN'.tr, // أضفنا .tr
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // 10. Registration Link (Don't have an account?)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?".tr, // أضفنا .tr
                  style: const TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstSignUpScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Create Account'.tr, // أضفنا .tr
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function remains exactly the same
  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isPhoneNumber = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        obscuringCharacter: '•',
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.left,
        keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
        inputFormatters: isPhoneNumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}