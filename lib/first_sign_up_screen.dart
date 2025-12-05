import 'package:flutter/material.dart';
import 'package:tanzan/second_sign_up_screen.dart';

class FirstSignUpScreen extends StatefulWidget {
  const FirstSignUpScreen({super.key});

  @override
  State<FirstSignUpScreen> createState() => _FirstSignUpScreenState();
}

class _FirstSignUpScreenState extends State<FirstSignUpScreen> {
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  void checkInput() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text(
            'please make sure that you have already fill all the gaps',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text(
            'your cofirm password is not the same password you put please correct it',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecondSignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية
          Image.asset(
            "assets/background_image.jpg", // ضع هنا صورة الخلفية
            fit: BoxFit.cover,
          ),

          // طبقة تعتيم
          Container(color: Colors.black.withOpacity(0.40)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 90),

                const Icon(Icons.home, size: 80, color: Colors.white),

                const SizedBox(height: 13),

                // عنوان التطبيق
                const Text(
                  "Smart Home Access",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // عنوان إنشاء حساب
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 35),

                // First Name
                buildInputField(
                  icon: Icons.person,
                  hint: "First Name",
                  controller: _firstNameController,
                ),
                const SizedBox(height: 15),

                // Last Name
                buildInputField(
                  icon: Icons.person,
                  hint: "Last Name",
                  controller: _lastNameController,
                ),
                const SizedBox(height: 15),

                // Password
                buildInputField(
                  icon: Icons.lock,
                  hint: "Password",
                  obscure: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 15),

                // Confirm Password
                buildInputField(
                  icon: Icons.lock_outline,
                  hint: "Confirm Password",
                  obscure: true,
                  controller: _confirmPasswordController,
                ),

                const SizedBox(height: 35),

                // زر إنشاء حساب
                SizedBox(
                  height: 50,
                  width: 165,
                  child: ElevatedButton(
                    onPressed: checkInput,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B609E),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 60,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Next  ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // نص الانتقال لتسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildInputField({
  required IconData icon,
  required String hint,
  required TextEditingController controller,
  bool obscure = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.25),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.white),
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
      ),
    ),
  );
}
