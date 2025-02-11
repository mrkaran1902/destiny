import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'footer_widget.dart';

class StampingModePage extends StatefulWidget {
  final Map<String, String?> selections;
  final int? customSession;

  const StampingModePage(
      {super.key, required this.selections, this.customSession});

  @override
  State<StampingModePage> createState() => _StampingModePageState();
}

class _StampingModePageState extends State<StampingModePage> {
  int _energy = 1;
  // ignore: unused_field, prefer_final_fields
  int _frequency = 1;
  int _pulseWidth = 20;
  final int _shotsDelivered = 0;
  final double _energyDelivered = 0.0;
  final double _areaCovered = 0.0;
  bool _isTreatmentActive = false;
  int _remainingTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = getTreatmentTime(widget.selections);
  }

  int getTreatmentTime(Map<String, String?> selections) {
    if (selections['AREA'] == 'ForeHead') {
      return 35; // 5 minutes in seconds
    } else if (selections['AREA'] == 'Cheeks') {
      return 55; // 5 minutes in seconds
    } else if (selections['AREA'] == 'Upper Lips') {
      return 6; // 5 minutes in seconds
    } else if (selections['AREA'] == 'Chin') {
      return 15; // 5 minutes in seconds
    } else if (selections['AREA'] == 'Neck') {
      return 1* 40; // 5 minutes in seconds
    }
    return 0;
  }

  void _startTreatment() {
    setState(() {
      _isTreatmentActive = true;
      startTimer();
    });
  }

  void _stopTreatment() {
    setState(() {
      _isTreatmentActive = false;
      _timer?.cancel();
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "STAMPING MODE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
            letterSpacing: 2,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff602E84),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSelectionDetail("Area", widget.selections['AREA']),
                  _buildSelectionDetail(
                      "Skin Type", widget.selections['SKIN TYPE']),
                  _buildSelectionDetail(
                      "Hair Density", widget.selections['HAIR DENSITY']),
                  _buildSelectionDetail(
                      "Hair Color", widget.selections['HAIR COLOR']),
                  _buildSelectionDetail(
                      "Session", widget.selections['SESSION']),
                  if (widget.selections['SESSION'] == 'Custom' &&
                      widget.customSession != null)
                    _buildSelectionDetail(
                        "Session", widget.customSession.toString()),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildStatCard("Energy Delivered",
                          "${_energyDelivered.toStringAsFixed(1)} J/cm²"),
                      buildEnergyMeter(),
                      buildStatCard("Area Covered",
                          "${_areaCovered.toStringAsFixed(1)} cm²"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildStatCard(
                          "Shots Delivered", _shotsDelivered.toString()),
                      buildPulseDurationClock(),
                      buildStatCard(
                          "Time Remaining", formatTime(_remainingTime)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      _isTreatmentActive ? _stopTreatment : _startTreatment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    minimumSize: const Size(120, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        _isTreatmentActive ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  child: Text(
                    _isTreatmentActive ? "STOP" : "START",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterWidget(),
    );
  }

  Widget _buildSelectionDetail(String title, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff602E84), width: 1.5),
        boxShadow: [
          BoxShadow(
            //color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        "$title: ${value ?? 'Not Selected'}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff602E84),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xff7B3FAF), Color(0xff602E84)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 3,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'PlayfairDisplay',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff602E84),
                  fontFamily: 'PlayfairDisplay',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEnergyMeter() {
    // Set maximum energy based on the frequency
    int maxEnergy = 25; // Default for frequency 1

    // Ensure _energy is within the valid range
    if (_energy > maxEnergy) {
      _energy = maxEnergy; // Reset to max value if out of range
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "FLUENCE",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff602E84)),
            ),
            const SizedBox(height: 0),
            CustomPaint(
              size: const Size(150, 150),
              painter: RPMPainter(
                  _energy, maxEnergy), // Pass maxEnergy to the painter
            ),
            const SizedBox(height: 0),
            buildValueControls(
              value: _energy,
              min: 1,
              max: maxEnergy, // Dynamically set max value
              unitLabel: "J/cm²",
              onChanged: (value) {
                if (value <= maxEnergy) {
                  setState(() => _energy = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPulseDurationClock() {
    int minPulseWidth = 20; // Default minimum pulse width
    String pulseLabel = "Low"; // Default pulse width label

    if (_energy >= 1 && _energy <= 25) {
      minPulseWidth = 20;
      pulseLabel = "Low";
    } else if (_energy >= 1 && _energy <= 25) {
      minPulseWidth = 40;
      pulseLabel = "Medium";
    } else if (_energy >= 1 && _energy <= 25) {
      minPulseWidth = 60;
      pulseLabel = "High";
    } else {
      _energy = 1; // Reset energy if outside valid range
    }

    // Ensure _pulseWidth is at least minPulseWidth
    if (_pulseWidth < minPulseWidth) {
      _pulseWidth = minPulseWidth;
    }

    // Determine the label based on the current _pulseWidth
    if (_pulseWidth == 20) {
      pulseLabel = "Low";
    } else if (_pulseWidth == 40) {
      pulseLabel = "Medium";
    } else if (_pulseWidth == 60) {
      pulseLabel = "High";
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "PULSE WIDTH",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff602E84)),
            ),
            const SizedBox(height: 5),
            CustomPaint(
              size: const Size(100, 100),
              painter: ClockPainter(_pulseWidth, 60),
            ),
            const SizedBox(height: 5),

            // The value control buttons for pulse width (with "Low", "Medium", "High" labels)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: !_isTreatmentActive && _pulseWidth > minPulseWidth
                      ? () {
                          setState(() {
                            if (_pulseWidth > minPulseWidth) {
                              _pulseWidth -= 20;
                            }
                          });
                        }
                      : null,
                  icon: const Icon(Icons.remove),
                  color: Colors.white,
                  iconSize: 40,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xff602E84),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  pulseLabel, // Show "Low", "Medium", or "High"
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff602E84),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: !_isTreatmentActive && _pulseWidth < 60
                      ? () {
                          setState(() {
                            if (_pulseWidth < 60) {
                              _pulseWidth += 20;
                            }
                          });
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  iconSize: 40,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xff602E84),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildValueControls({
    required int value,
    required int min,
    required int max,
    required String unitLabel,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: !_isTreatmentActive && value > min
              ? () {
                  onChanged(value - (unitLabel == "ms" ? 10 : 1));
                }
              : null,
          icon: const Icon(Icons.remove),
          color: Colors.white,
          iconSize: 40,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xff602E84),
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: Colors.black54,
          ),
        ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff7B3FAF), Color(0xff602E84)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Text(
            "$value $unitLabel",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: !_isTreatmentActive && value < max
              ? () {
                  onChanged(value + (unitLabel == "ms" ? 10 : 1));
                }
              : null,
          icon: const Icon(Icons.add),
          color: Colors.white,
          iconSize: 40,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xff602E84),
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// Custom painters for energy, clock, and wave.
class RPMPainter extends CustomPainter {
  final int value;
  final int maxValue;

  RPMPainter(this.value, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 1.2);
    final radius = size.width / 1.5;

    // Background arc gradient
    final Paint backgroundPaint = Paint()
      ..shader = SweepGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade500],
        startAngle: pi,
        endAngle: 2 * pi,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50; // Thicker arc

    // Determine color based on RPM value
    Color activeColor;
    if (value <= maxValue * 0.10) {
      activeColor = Colors.yellow.shade300;
    } else if (value <= maxValue * 0.20) {
      activeColor = Colors.yellow.shade500;
    } else if (value <= maxValue * 0.30) {
      activeColor = Colors.amber.shade500;
    } else if (value <= maxValue * 0.40) {
      activeColor = Colors.orange.shade400;
    } else if (value <= maxValue * 0.50) {
      activeColor = Colors.orange.shade600;
    } else if (value <= maxValue * 0.60) {
      activeColor = Colors.deepOrange.shade500;
    } else if (value <= maxValue * 0.70) {
      activeColor = Colors.deepOrange.shade700;
    } else if (value <= maxValue * 0.80) {
      activeColor = Colors.red.shade600;
    } else if (value <= maxValue * 0.90) {
      activeColor = Colors.red.shade800;
    } else {
      activeColor = Colors.red.shade900;
    }

    // Active arc gradient
    final Paint activePaint = Paint()
      ..shader = SweepGradient(
        colors: [activeColor.withOpacity(0.4), activeColor],
        startAngle: pi,
        endAngle: pi + ((value / maxValue) * pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50;
    //..strokeCap = StrokeCap.round; // Rounded ends

    // Glow effect around active arc
    final Paint glowPaint = Paint()
      ..color = activeColor.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Glow effect
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      (value / maxValue) * pi,
      false,
      glowPaint,
    );

    // Active arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      (value / maxValue) * pi,
      false,
      activePaint,
    );

    // Tick marks
    final Paint tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2;

    for (int i = 0; i <= 30; i++) {
      double angle = pi + (i / 30) * pi;
      Offset start = Offset(
        center.dx + (radius - 6) * cos(angle),
        center.dy + (radius - 6) * sin(angle),
      );
      Offset end = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ClockPainter extends CustomPainter {
  final int value;
  final int maxValue;

  ClockPainter(this.value, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Gradient clock face
    final Paint clockPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, Colors.grey.shade300],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // Stroke for clock border
    final Paint borderPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Hand Paint (actual clock hand)
    final Paint handPaint = Paint()
      ..color = const Color(0xff602E84)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Glow Effect for the hand
    final Paint glowPaint = Paint()
      ..color = const Color(0xff602E84).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw the clock face
    canvas.drawCircle(center, radius, clockPaint);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw tick marks
    final Paint tickPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..strokeWidth = 2;

    for (int i = 0; i < 12; i++) {
      double angle = (2 * pi * i / 12) - (pi / 2);
      Offset start = Offset(
        center.dx + (radius - 10) * cos(angle),
        center.dy + (radius - 10) * sin(angle),
      );
      Offset end = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Draw clock hand
    final double angle = (2 * pi * (value / maxValue)) - (pi / 2);
    final Offset handEnd = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    canvas.drawLine(center, handEnd, glowPaint); // Glow effect
    canvas.drawLine(center, handEnd, handPaint); // Actual hand

    // Draw pivot at the center of clock
    final Paint pivotPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 6, pivotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
