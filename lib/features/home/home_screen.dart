import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/user_service.dart';
import 'package:katakata_app/features/minigames/flashcard_screen.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    final name = userProfile?.name ?? 'Teman';
    final currentLevel = userProfile?.currentLevel ?? 1;
    final xp = userProfile?.xp ?? 0;
    final double levelProgress = (xp % 1000) / 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildTopHeader(context, name),
          Transform.translate(
            offset: const Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(context),
                  const SizedBox(height: 24),
                  Text(
                    'Lanjutkan Perjalanan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildHeroLessonCard(context, currentLevel, levelProgress),
                  const SizedBox(height: 24),
                  Text(
                    'Pilihan Belajar',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionTile(
                    context,
                    title: 'Papan Peringkat',
                    subtitle: 'Lihat posisimu vs teman lain',
                    icon: Icons.emoji_events_rounded,
                    color: Colors.amber,
                    onTap: () => context.push('/leaderboard'),
                  ),
                  const SizedBox(height: 12),

                  _buildActionTile(
                    context,
                    title: 'Tantangan Harian',
                    subtitle: 'Misi harian & bonus XP',
                    icon: Icons.local_fire_department_rounded,
                    color: Colors.deepOrange,
                    onTap: () => context.push('/dailychallenge'),
                  ),
                  const SizedBox(height: 12),

                  _buildActionTile(
                    context,
                    title: 'Latihan Pengucapan',
                    subtitle: 'Perbaiki aksen bicaramu',
                    icon: Icons.mic_rounded,
                    color: KataKataColors.violetCerah,
                    onTap: () => context.push('/pronounce'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    context,
                    title: 'Ganti Bahasa',
                    subtitle: 'Inggris, Spanyol, Prancis...',
                    icon: Icons.language_rounded,
                    color: KataKataColors.kuningCerah,
                    onTap: () => context.push('/languages'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    context,
                    title: 'Flashcards',
                    subtitle: 'Hafalan cepat kata-kata baru',
                    icon: Icons.style_rounded,
                    color: KataKataColors.pinkCeria,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FlashcardScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $name! 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semangat belajar hari ini!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Container(
              height: 60,
              width: 60,
              child: Image.asset(
                'assets/images/mascot_avatar.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/dailychallenge'),
            child: _buildStatCard(
              icon: 'assets/images/icon_streak.png',
              label: 'Streak',
              value: '3 Hari',
              bgColor: const Color(0xFFFFF5E6),
              accentColor: Colors.orange,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: 'assets/images/icon_total_words.png',
            label: 'Kata',
            value: '120+',
            bgColor: const Color(0xFFE6F7FF),
            accentColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 36, height: 36),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KataKataColors.charcoal,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroLessonCard(
      BuildContext context, int level, double progress) {
    return GestureDetector(
      onTap: () => context.push('/languages'),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [KataKataColors.violetCerah, Color(0xFF9F5DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: KataKataColors.violetCerah.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                Icons.school_rounded,
                size: 150,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'LEVEL $level',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai Belajar',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.black.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation(
                                KataKataColors.kuningCerah),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: MascotWidget(
                      size: 100,
                      assetName: 'mascot_main.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}