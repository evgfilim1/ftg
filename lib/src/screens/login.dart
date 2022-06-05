import 'package:flutter/material.dart';

import './home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _codeSent = false;
  bool _passwordRequired = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              // no validation for you at all, sorry :(
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Phone number (with country code)',
                ),
                autofocus: true,
                keyboardType: TextInputType.phone,
                onSubmitted: (value) => setState(() => _codeSent = true),
              ),
              if (_codeSent)
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Verification code',
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) => setState(() => _passwordRequired = true),
                ),
              if (_passwordRequired)
                TextField(
                  decoration: const InputDecoration(
                    hintText: '2FA Password',
                  ),
                  autofocus: true,
                  obscureText: true,
                  onSubmitted: (value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
