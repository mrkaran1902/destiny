import 'package:flutter/material.dart';
import 'loading.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> with TickerProviderStateMixin {
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..forward();

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToTextPage();
      }
    });
  }

  void _navigateToTextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoadingPage()),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: AnimatedBuilder(
          animation: _logoController,
          builder: (context, child) {
            final size = MediaQuery.of(context).size.width * 0.7 *
                (1.0 - _logoController.value * 0.1); // Shrinking animation
            return SizedBox(
              width: size,
              height: size,
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            );
          },
        ),
      ),
    );
  }
}
