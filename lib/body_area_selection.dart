import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'expert_profile_selection.dart';

class BodyAreaPage extends StatefulWidget {
  const BodyAreaPage({super.key});

  @override
  State<BodyAreaPage> createState() => _BodyAreaPageState();
}

class _BodyAreaPageState extends State<BodyAreaPage> {
  BodyParts _selectedBodyParts = const BodyParts(); // State to hold selected parts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Treatment Area"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff602E84),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BodyPartSelectorTurnable(
                bodyParts: _selectedBodyParts,
                onSelectionUpdated: (updatedParts) {
                  setState(() {
                    _selectedBodyParts = updatedParts;
                  });
                },
                labelData: const RotationStageLabelData(
                  front: 'Front',
                  left: 'Left',
                  right: 'Right',
                  back: 'Back',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _navigateToNextPage(context, _selectedBodyParts);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff602E84),
                foregroundColor: Color(0xffffffff),
                minimumSize: const Size(double.infinity, 70),
              ),
              child: const Text(
                "PROCEED",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextPage(BuildContext context, BodyParts selectedParts) {
    // Pass selected body parts to the next page or perform any desired action
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ExpertProfileSelection()),
       );
  }
}

class NextPage extends StatelessWidget {
  final BodyParts? selectedParts;

  const NextPage({super.key, required this.selectedParts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selected Body Parts"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff602E84),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Selected Parts: ${selectedParts.toString()}",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}