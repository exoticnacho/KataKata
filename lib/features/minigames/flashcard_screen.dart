import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/flashcard_service.dart';
import 'package:katakata_app/widgets/custom_button.dart';
import 'package:flip_card/flip_card.dart';

class FlashcardScreen extends ConsumerWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashcardProvider);
    final notifier = ref.read(flashcardProvider.notifier);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: KataKataColors.offWhite,
        elevation: 1,
        title: Text(
          'Review Flashcard (${state.currentIndex + 1}/${state.sessionWords.length})',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
      ),
      body: state.sessionCompleted
          ? _buildCompletionScreen(context, notifier)
          : _buildFlashcard(context, state, notifier),
    );
  }

  Widget _buildFlashcard(BuildContext context, FlashcardState state, FlashcardNotifier notifier) {
    if (state.sessionWords.isEmpty) {
      return Center(
        child: Text(
          'Tambahkan kata untuk memulai sesi review!',
          style: GoogleFonts.poppins(color: KataKataColors.charcoal),
        ),
      );
    }

    final currentWord = state.sessionWords[state.currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              flipOnTouch: true,
              front: _buildCardContent(currentWord.english, 'English', KataKataColors.violetCerah),
              back: _buildCardContent(currentWord.indonesian, 'Indonesia', KataKataColors.kuningCerah),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: KataKataButton(
              text: 'Dikuasai (Mastered)',
              onPressed: () => notifier.nextCard(true),
              backgroundColor: Colors.green.shade500,
              foregroundColor: KataKataColors.offWhite,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: KataKataButton(
              text: 'Perlu Diulang',
              onPressed: () => notifier.nextCard(false),
              backgroundColor: Colors.red.shade500,
              foregroundColor: KataKataColors.offWhite,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCardContent(String text, String lang, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: KataKataColors.charcoal.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: KataKataColors.charcoal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context, FlashcardNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Review Selesai!',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: KataKataColors.pinkCeria,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Anda telah memperkuat ${notifier.state.sessionWords.length} kata dan mendapatkan kemajuan!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: KataKataColors.charcoal,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '+3 Kata Baru!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 40),
            KataKataButton(
              text: 'Lanjut ke Glosarium',
              onPressed: () {
                notifier.completeSession(3);
                context.pop();
              },
              backgroundColor: KataKataColors.violetCerah,
            ),
          ],
        ),
      ),
    );
  }
}
