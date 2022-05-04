import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ftg/screens/home.dart';

import './screens/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> isLoggedIn() async {
    // fake async
    return Random().nextBool();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f-Telegram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? const HomeScreen() : const LoginScreen();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
