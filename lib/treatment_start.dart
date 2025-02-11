// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'footer_widget.dart';
import 'mqtt.dart';
import 'settings.dart';
import 'treatment_mode_selection.dart';

class TreatmentStartPage extends StatefulWidget {
  const TreatmentStartPage({super.key});

  @override
  State<TreatmentStartPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<TreatmentStartPage> {
  late Mqttconn mqttconn;
  bool isLedOn = false;

  @override
  void initState() {
    super.initState();
    mqttconn = Mqttconn();
    mqttconn.connectToMqtt();
  }

  @override
  void dispose() {
    mqttconn.disconnect();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff3E1E68),  // Deep purple
            Color(0xff9B72CF),  // Soft lavender
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // AppBar
          AppBar(
            title: const Text(
              'DESTINY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xff602E84),
            actions: [
              GestureDetector(
                onLongPressStart: (_) async {
                  bool isPressed = true;
                  await Future.delayed(const Duration(seconds: 1), () {
                    if (isPressed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPage()),
                      );
                    }
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.settings,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.3,
              horizontal: screenSize.width * 0.3,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context,
                  'START TREATMENT',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TreatmentModeSelectionPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Footer
          const FooterWidget(),
        ],
      ),
    ),
  );
}

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(70),
        textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,fontFamily:'PlayfairDisplay'),
      ),
      child: Text(text),
    );
  }
}