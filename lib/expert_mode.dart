import 'package:flutter/material.dart';
import 'dart:math';
import 'footer_widget.dart';

class ExpertModePage extends StatefulWidget {
  const ExpertModePage({super.key});

  @override
  State<ExpertModePage> createState() => _ExpertModePageState();
}

class _ExpertModePageState extends State<ExpertModePage> {
  int _energy = 1;
  int _frequency = 1;
  int _pulseWidth = 10;
  final int _shotsDelivered = 0;
  final double _energyDelivered = 0.0;
  final double _areaCovered = 0.0;
  bool _isTreatmentActive = false;

  void _startTreatment() {
    setState(() {
      _isTreatmentActive = true;
    });
  }

  void _stopTreatment() {
    setState(() {
      _isTreatmentActive = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "EXPERT MODE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
            letterSpacing: 1.2,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff602E84),
      ),
      body: Column(
        children: [
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
                      buildPulseDurationClock(),
                      buildStatCard(
                          "Shots Delivered", _shotsDelivered.toString()),
                      buildFrequencyWave(),
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
    int maxEnergy = 30; // Default for frequency 1
    if (_frequency == 2) {
      maxEnergy = 20; // Limit to 20 for frequency 2
    } else if (_frequency == 3) {
      maxEnergy = 15; // Limit to 15 for frequency 3
    }

    // Ensure _energy is within the valid range
    if (_energy > maxEnergy) {
      _energy = maxEnergy; // Reset to max value if out of range
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "FLUENCE",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xff602E84)),
            ),
            const SizedBox(height: 0),
            CustomPaint(
              size: const Size(200, 200),
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
    // Ensure energy is within valid range for the selected frequency
    if ((_frequency == 2 && _energy > 20) ||
        (_frequency == 3 && _energy > 15)) {
      _energy = 1; // Reset to valid value
    }

    int minPulseWidth = 10; // Default minimum pulse width

    // Set minimum pulse width based on frequency and energy
    if (_frequency == 1) {
      if (_energy >= 1 && _energy <= 15) {
        minPulseWidth = 10;
      } else if (_energy >= 16 && _energy <= 25) {
        minPulseWidth = 20;
      } else if (_energy >= 26 && _energy <= 30) {
        minPulseWidth = 30;
      }
    } else if (_frequency == 2) {
      if (_energy >= 1 && _energy <= 10) {
        minPulseWidth = 10;
      } else if (_energy >= 11 && _energy <= 20) {
        minPulseWidth = 20;
      }
    } else if (_frequency == 3 && _energy >= 1 && _energy <= 15) {
      minPulseWidth = 10;
    } else {
      _energy = 1; // Reset energy if outside valid range
    }

    // Ensure _pulseWidth is at least minPulseWidth
    if (_pulseWidth < minPulseWidth) {
      _pulseWidth = minPulseWidth;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "PULSE WIDTH",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xff602E84)),
            ),
            const SizedBox(height: 1),
            CustomPaint(
              size: const Size(100, 100),
              painter: ClockPainter(_pulseWidth, 60),
            ),
            const SizedBox(height: 15),
            buildValueControls(
              value: _pulseWidth,
              min: minPulseWidth, // Dynamically set minimum pulse width
              max: 60, // Allow increasing pulse width
              unitLabel: "ms",
              onChanged: (value) {
                if (value >= minPulseWidth) {
                  setState(() => _pulseWidth = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFrequencyWave() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "FREQUENCY",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xff602E84)),
            ),
            const SizedBox(height: 30),
            CustomPaint(
              size: const Size(150, 50),
              painter: WavePainter(_frequency, 500),
            ),
            const SizedBox(height: 20),
            buildValueControls(
              value: _frequency,
              min: 1,
              max: 3,
              unitLabel: "Hz",
              onChanged: (value) => setState(() => _frequency = value),
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

class WavePainter extends CustomPainter {
  final int value;
  final int maxValue;

  WavePainter(this.value, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xff602E84), Colors.purple.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final waveHeight = size.height / 2;
    final waveWidth = size.width / 550;
    final normalizedValue = value / maxValue;

    Path path = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = waveHeight * sin((x / waveWidth) * 2 * pi * normalizedValue) +
          waveHeight;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw shadow behind wave
    canvas.drawShadow(path, const Color(0xff602E84), 5, false);

    // Draw the wave
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
