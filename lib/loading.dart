import 'package:flutter/material.dart';
import 'treatment_start.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), _navigateToModeSelectionPage);
  }

  void _navigateToModeSelectionPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TreatmentStartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "NAMASTE!\nPLEASE ALLOW ME SOME TIME\nI'M GETTING READY TO MAKE YOUR CLIENT HAIRFREE...",
              style: TextStyle(
                fontSize: 35,
                color: Color(0xff602E84),
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}