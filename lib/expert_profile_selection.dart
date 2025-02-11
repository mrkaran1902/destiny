import 'package:flutter/material.dart';
import 'expert_mode.dart';
import 'footer_widget.dart';

class ExpertProfileSelection extends StatefulWidget {
  const ExpertProfileSelection({super.key});

  @override
  State<ExpertProfileSelection> createState() => _TreatmentPageState();
}

class WavyHairPainter extends CustomPainter {
  final double thickness;

  WavyHairPainter({required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = Path();
    const amplitude = 5.0;
    const frequency = 6;

    for (int i = 0; i < frequency; i++) {
      path.relativeQuadraticBezierTo(
        size.width / (2 * frequency),
        amplitude * (i % 2 == 0 ? 1 : -1),
        size.width / frequency,
        0,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _TreatmentPageState extends State<ExpertProfileSelection> {
  final Map<String, String?> _selections = {
    'SKIN TYPE': null,
    'HAIR TYPE': null,
    'HAIR COLOR': null,
    'SESSION': null,
  };
  int? _customSESSION;

  final Map<String, List<String>> _options = {
    'SKIN TYPE': ['Type 1', 'Type 2', 'Type 3', 'Type 4', 'Type 5', 'Type 6'],
    'HAIR TYPE': ['Fine', 'Medium', 'Coarse'],
    'HAIR COLOR': ['Black', 'Dark Brown', 'Medium Brown', 'Light Brown'],
    'SESSION': ['1', '2', '3', '4', '5', '6', 'Custom'],
  };

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EXPERT MODE',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff602E84),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xffffffff), size: 40),
            onPressed: _canProceed()
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExpertModePage()),
                    );
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // This will space the cards evenly
          children: [
            _buildCategoryCard('SKIN TYPE', _buildSkinToneSelectors(buttonColor)),
            _buildCategoryCard('HAIR TYPE', _buildHairTypeSelectors(buttonColor)),
            _buildCategoryCard('HAIR COLOR', _buildHairColorSelectors(buttonColor)),
            _buildCategoryCard('SESSION', _buildSelector('SESSION', _options['SESSION']!, buttonColor)),
          ],
        ),
      ),
      bottomNavigationBar: // Footer
          const FooterWidget(),
    );
  }

  Widget _buildCategoryCard(String title, Widget content) {
    return Container(
      width: 364, // Ensure that the width is consistent for each card
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildHairTypeSelectors(Color color) {
    final hairTypeThickness = {
      'Fine': 1.5,
      'Medium': 2.5,
      'Coarse': 3.5,
    };

    return ListView(
      children: _options['HAIR TYPE']!.map((option) {
        final isSelected = _selections['HAIR TYPE'] == option;
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 64.0),
          child: Column(
            children: [
              CustomPaint(
                size: const Size(100, 50),
                painter: WavyHairPainter(thickness: hairTypeThickness[option]!),
              ),
              const SizedBox(height: 1),
              ChoiceChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                selected: isSelected,
                selectedColor: color,
                onSelected: (selected) {
                  setState(() {
                    _selections['HAIR TYPE'] = selected ? option : null;
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkinToneSelectors(Color buttonColor) {
    final Map<String, Color> skinToneColors = {
      'Type 1': const Color(0xFFE1AC96),
      'Type 2': const Color(0xFFD2A18C),
      'Type 3': const Color(0xFFB48A78),
      'Type 4': const Color(0xFF967264),
      'Type 5': const Color(0xFF785C50),
      'Type 6': const Color(0xFF5A453C),
    };

    return ListView(
      children: _options['SKIN TYPE']!.map((option) {
        final isSelected = _selections['SKIN TYPE'] == option;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selections['SKIN TYPE'] = option;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: skinToneColors[option],
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHairColorSelectors(Color color) {
    final hairColors = {
      'Black': Colors.black,
      'Dark Brown': Colors.brown.shade800,
      'Medium Brown': Colors.brown.shade400,
      'Light Brown': Colors.brown.shade50,
    };

    return ListView(
      children: _options['HAIR COLOR']!.map((option) {
        final isSelected = _selections['HAIR COLOR'] == option;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selections['HAIR COLOR'] = option;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: hairColors[option],
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

Widget _buildSelector(String category, List<String> options, Color color) {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal padding
    children: options.map((option) {
      final isSelected = _selections[category] == option;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 26.0), // Add vertical spacing between buttons
        child: ChoiceChip(
          label: Text(
            option,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
            ),
          ),
          selected: isSelected,
          selectedColor: color,
          onSelected: (selected) {
            setState(() {
              _selections[category] = selected ? option : null;
              if (option == "Custom" && selected) {
                _showCustomSESSIONDialog(category);
              }
            });
          },
          labelPadding: EdgeInsets.symmetric(horizontal: 30.0), // Increase the horizontal size of the chip
        ),
      );
    }).toList(),
  );
}

  void _showCustomSESSIONDialog(String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Custom SESSION'),
          content: DropdownButton<int>(
            value: _customSESSION,
            items: List.generate(
              20,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('SESSION ${index + 1}'),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _customSESSION = value;
                _selections[category] =
                    value != null ? 'Custom ($value)' : null;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  bool _canProceed() {
    return _selections.values.every((selection) => selection != null);
  }
}