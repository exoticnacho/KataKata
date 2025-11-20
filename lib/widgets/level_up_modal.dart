import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/user_service.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';
import 'package:lottie/lottie.dart'; 

const String confettiAsset = 'assets/lottie/confetti.json'; 

class LevelUpModal extends ConsumerWidget {
  final int newLevel;

  const LevelUpModal({super.key, required this.newLevel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userProfileProvider.notifier).resetLevelUpStatus();
    });

    return AlertDialog(
      backgroundColor: KataKataColors.offWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: KataKataColors.charcoal, width: 2),
      ),
      contentPadding: EdgeInsets.zero,
      content: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
              child: Lottie.asset(
                confettiAsset, 
                repeat: false,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          
          Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const MascotWidget(size: 80, assetName: 'mascot_main.png'),
                
                const SizedBox(height: 20),
                Text(
                  'SELAMAT!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: KataKataColors.pinkCeria,
                  ),
                ),
                
                Text(
                  'Kamu Naik ke Level $newLevel!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                ),
                
                const SizedBox(height: 16),
                Image.asset('assets/images/achievement_levelup.png', width: 48, height: 48),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KataKataColors.violetCerah,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('LANJUTKAN'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
