import 'package:flutter/material.dart';
import 'homepage.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                const SizedBox(height: 10),
                const Text(
                  'Sign up to see when your\nfriends are free.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 24),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number or Email',
                    filled: true,
                    fillColor: Color(0xFFE5E5E5),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    filled: true,
                    fillColor: Color(0xFFE5E5E5),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Username',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Log In', style: TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }