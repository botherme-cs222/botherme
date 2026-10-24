import 'package:flutter/material.dart';
import 'signup.dart';
import 'notifications.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BotherMe',
                  style: TextStyle(fontFamily: 'serif', fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone number, username, or email',
                    filled: true,
                    fillColor: Color(0xFFE5E5E5),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Color(0xFFE5E5E5),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?', style: TextStyle(color: Colors.black87, fontSize: 11)),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: const Text('Create Account', style: TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}