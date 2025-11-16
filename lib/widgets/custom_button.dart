import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class KataKataButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const KataKataButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool useOverrideColor = backgroundColor != null;
    final Color effectiveBackgroundColor = backgroundColor ?? KataKataColors.violetCerah;
    final Color effectiveForegroundColor = foregroundColor ?? Colors.white;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: !useOverrideColor
            ? const LinearGradient(
                colors: [KataKataColors.pinkCeria, KataKataColors.violetCerah],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: useOverrideColor ? effectiveBackgroundColor : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: effectiveForegroundColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
