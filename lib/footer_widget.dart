import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Color(0xffffffff),
      height: 45,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/logo.png', // Replace with your logo file path
            height: 300,
            width: 205,
          ),
        ],
      ),
    );
  }
}