import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/data/mock_words.dart';
import 'package:katakata_app/core/services/user_service.dart';

class WordListScreen extends ConsumerWidget {
  const WordListScreen({super.key});

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: KataKataColors.offWhite,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: KataKataColors.charcoal),
            onPressed: () => context.go('/home'),
          ),
          Expanded(
            child: Text(
              'Glosarium Pribadi',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
          ),
          const SizedBox(width: 48), 
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final totalWords = userProfile?.totalWordsTaught ?? 0;
    final wordsToShow = mockLearnedWords.take(totalWords).toList();
    final double customAppBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: customAppBarHeight, bottom: 100),
            child: wordsToShow.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada kata yang dicatat.\nAyo mulai latihan!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: KataKataColors.charcoal.withOpacity(0.6), fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: wordsToShow.length,
                    itemBuilder: (context, index) {
                      final word = wordsToShow[index];
                      return _buildWordTile(word);
                    },
                  ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: KataKataColors.offWhite,
                boxShadow: [
                  BoxShadow(
                    color: KataKataColors.charcoal.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              height: customAppBarHeight,
              child: _buildCustomAppBar(context),
            ),
          ),
          
          if (totalWords > 0)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.push('/flashcard'); 
                },
                backgroundColor: KataKataColors.pinkCeria,
                icon: const Icon(Icons.flash_on, color: KataKataColors.offWhite),
                label: Text('Mulai Review Kata!', style: GoogleFonts.poppins(color: KataKataColors.offWhite, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWordTile(LearnedWord word) {
    return Card(
      color: KataKataColors.offWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: KataKataColors.charcoal, width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.english,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: KataKataColors.pinkCeria,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.indonesian,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: KataKataColors.kuningCerah.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                word.level,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: KataKataColors.charcoal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
