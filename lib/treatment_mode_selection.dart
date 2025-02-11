import 'expert_mode.dart';
import 'fast_profile_selection.dart';
import 'footer_widget.dart';
import 'stamping_profile_selection.dart';
import 'package:flutter/material.dart';

class TreatmentModeSelectionPage extends StatelessWidget {
  const TreatmentModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: const Text(
          'SELECT MODE',
          style: TextStyle(
            color: Color(0xffffffff),
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay'
            ,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff602E84),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton(
              context,
              modeName: "EXPERT",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExpertModePage()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildModeButton(
              context,
              modeName: "STAMPING",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StampingProfileSelection()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildModeButton(
              context,
              modeName: "FAST",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FastProfileSelection()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: // Footer
          const FooterWidget(),
    );
  }

  Widget _buildModeButton(BuildContext context,
      {required String modeName, required VoidCallback onPressed}) {
    return SizedBox(
      width: 500, // Fixed width
      height: 130, // Fixed height
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(40), // Adjust padding as needed
          textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,fontFamily: 'PlayfairDisplay'),
        ),
        child: Text(modeName),
      ),
    );
  }
}
