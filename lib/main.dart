import 'package:flutter/material.dart';
import 'logo.dart';

void main() {
  runApp(const PhotodiodeApp());
}

class PhotodiodeApp extends StatelessWidget {
  const PhotodiodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photodiode UI',
      theme: ThemeData(
        fontFamily: 'PlayfairDisplay',
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: const LogoPage(),
    );
  }
}