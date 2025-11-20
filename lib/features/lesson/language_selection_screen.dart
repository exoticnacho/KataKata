import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  final List<Map<String, dynamic>> languages = const [
    {'name': 'English', 'flag': 'assets/images/flag_uk.png', 'unlocked': true, 'code': 'en'},
    {'name': 'Spanish', 'flag': 'assets/images/flag_es.png', 'unlocked': false, 'code': 'es'},
    {'name': 'French', 'flag': 'assets/images/flag_fr.png', 'unlocked': false, 'code': 'fr'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: KataKataColors.offWhite,
        elevation: 1,
        title: Text(
          'Pilih Bahasa',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildLanguageTile(context, lang),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, Map<String, dynamic> lang) {
    final isUnlocked = lang['unlocked'] as bool;
    final icon = isUnlocked ? Icons.arrow_forward_ios : Icons.lock;
    final color = isUnlocked ? KataKataColors.violetCerah : KataKataColors.charcoal.withOpacity(0.5);

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          context.go('/stages');
        } else {
          _showLockedMessage(context, lang['name'] as String);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: KataKataColors.offWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: KataKataColors.charcoal.withOpacity(0.2),
              offset: const Offset(4, 4),
              blurRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              lang['flag'] as String,
              width: 28,
              height: 28,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.language, size: 28, color: KataKataColors.charcoal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                lang['name'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KataKataColors.charcoal,
                ),
              ),
            ),
            Icon(icon, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  void _showLockedMessage(BuildContext context, String langName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KataKataColors.offWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Mohon Maaf!',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: KataKataColors.pinkCeria,
          ),
        ),
        content: Text(
          'Bahasa $langName saat ini belum tersedia. Fitur ini akan hadir pada update berikutnya!',
          style: GoogleFonts.poppins(color: KataKataColors.charcoal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Oke',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: KataKataColors.violetCerah,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
