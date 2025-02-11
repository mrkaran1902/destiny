import 'fast_mode.dart';
import 'package:flutter/material.dart';
import 'footer_widget.dart';

class FastProfileSelection extends StatefulWidget {
  const FastProfileSelection({super.key});

  @override
  State<FastProfileSelection> createState() => _TreatmentPageState();
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

class _TreatmentPageState extends State<FastProfileSelection> {
  final Map<String, String?> _selections = {
    'AREA': null,
    'SKIN TYPE': null,
    'HAIR DENSITY': null,
    'HAIR COLOR': null,
    'SESSION': null, 
  };
  int? _customSESSION;

  final Map<String, List<String>> _options = {
    'AREA': ['Chest', 'Back', 'Arms', 'Axilla', 'Bikini', 'Legs' ],
    'SKIN TYPE': ['Type 1', 'Type 2', 'Type 3', 'Type 4', 'Type 5', 'Type 6'],
    'HAIR DENSITY': ['Fine', 'Medium', 'Coarse'],
    'HAIR COLOR': ['Black', 'Dark Brown', 'Medium Brown', 'Light Brown'],
    'SESSION': ['1', '2', '3', '4', '5', 'Custom'],
  };

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PATIENT PROFILE',
          style: TextStyle(
            color: Color(0xffffffff),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
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
                        builder: (context) => FastModePage(
                          selections: _selections, // Pass selections
                          customSession: _customSESSION, // Pass custom session
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // This will space the cards evenly
          children: [
            _buildCategoryCard(
                'AREA', _areabuildSelector('AREA', _options['AREA']!, buttonColor)),
            _buildCategoryCard(
                'SKIN TYPE', _buildSkinToneSelectors(buttonColor)),
            _buildCategoryCard(
                'HAIR DENSITY', _buildHairTypeSelectors(buttonColor)),
            _buildCategoryCard(
                'HAIR COLOR', _buildHairColorSelectors(buttonColor)),
            _buildCategoryCard('SESSION',
                _buildSelector('SESSION', _options['SESSION']!, buttonColor)),
          ],
        ),
      ),
      bottomNavigationBar: // Footer
          const FooterWidget(),
    );
  }

Widget _buildCategoryCard(String title, Widget content) {
  return Container(
    width: 300, // Slightly increased width for better spacing
    margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 3.5),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          spreadRadius: 3,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      gradient: LinearGradient(
        colors: [Colors.white, Colors.grey.shade100], 
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xff602E84),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: content,
          ),
        ),
      ],
    ),
  );
}

Widget _buildHairTypeSelectors(Color color) {
  final hairTypeThickness = {
    'Fine': 2.0,
    'Medium': 3.5,
    'Coarse': 5.0,
  };

  return Column(
    children: _options['HAIR DENSITY']!.map((option) {
      final isSelected = _selections['HAIR DENSITY'] == option;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selections['HAIR DENSITY'] = option;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11.6, horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(56.5),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CustomPaint(
                  size: const Size(100, 30),
                  painter: WavyHairPainter(thickness: hairTypeThickness[option]!),
                ),
                // Reduced height between wave paint and text
                const SizedBox(height: 0), // Smaller space between the text and the wave
                Text(
                  option,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? color : const Color(0xff602E84),
                  ),
                ),
              ],
            ),
          ),
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

  return Column(
    children: skinToneColors.entries.map((entry) {
      final String type = entry.key;
      final Color color = entry.value;
      final bool isSelected = _selections['SKIN TYPE'] == type;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selections['SKIN TYPE'] = type;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11.3, horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color,
                ),
                const SizedBox(width: 15), // Space between circle and text
                Expanded(
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : const Color(0xff602E84),
                    ),
                  ),
                ),
              ],
            ),
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
    'Light Brown': Colors.brown.shade200,
  };

  return Column(
    children: hairColors.entries.map((entry) {
      final String type = entry.key;
      final Color hairColor = entry.value;
      final bool isSelected = _selections['HAIR COLOR'] == type;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selections['HAIR COLOR'] = type;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19.5, horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: isSelected ? hairColor.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? hairColor : Colors.grey.shade400,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: hairColor,
                ),
                const SizedBox(width: 20), // Space between circle and text
                Expanded(
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : const Color(0xff602E84),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildSelector(String category, List<String> options, Color color) {
  return Column(
    children: options.map((option) {
      final isSelected = _selections[category] == option;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 23.1, horizontal: 65.0),
        child: SizedBox(
          width: double.infinity, // Ensures all buttons have the same width
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selections[category] = option;
                if (option == "Custom") {
                  _showCustomSESSIONDialog(category);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20.0), // Uniform height
              backgroundColor: isSelected ? color : Colors.white,
              foregroundColor: isSelected ? Colors.white : color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: color, width: 2),
              ),
            ),
            child: Text(
              option,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }).toList(),
  );
}

Widget _areabuildSelector(String category, List<String> options, Color color) {
  return Column(
    children: options.map((option) {
      final isSelected = _selections[category] == option;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 23.1, horizontal: 55.0),
        child: SizedBox(
          width: double.infinity, // Makes all buttons the same width
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selections[category] = option;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20.0), // Uniform button height
              backgroundColor: isSelected ? color : Colors.white,
              foregroundColor: isSelected ? Colors.white : color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: color, width: 2),
              ),
            ),
            child: Text(
              option,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }).toList(),
  );
}

void _showCustomSESSIONDialog(String category) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          FocusNode dropdownFocusNode = FocusNode();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            dropdownFocusNode.requestFocus();
          });

          return AlertDialog(
            title: const Text('Select Session'),
            content: DropdownButtonFormField<int>(
              value: _customSESSION,
              focusNode: dropdownFocusNode, // Auto-focus on dropdown
              isExpanded: true,
              items: List.generate(
                10,
                (index) => DropdownMenuItem(
                  value: index + 6,
                  child: Text('${index + 6}'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _customSESSION = value;
                  _selections[category] = value != null ? '$value' : null;
                });
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    },
  );
}

  bool _canProceed() {
    return _selections.values.every((selection) => selection != null);
  }
}