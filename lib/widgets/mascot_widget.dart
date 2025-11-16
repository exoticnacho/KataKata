import 'package:flutter/material.dart';

class MascotWidget extends StatelessWidget {
  final double size;
  final String assetName;

  const MascotWidget({
    super.key,
    this.size = 24,
    this.assetName = 'mascot_main.png',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/$assetName',
        fit: BoxFit.contain,
      ),
    );
  }
}
