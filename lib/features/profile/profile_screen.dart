import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/core/services/user_service.dart';
 
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider);
    final userProfile = ref.watch(userProfileProvider);
 
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/signin');
              }
            },
            icon: const Icon(
              Icons.logout,
              color: KataKataColors.charcoal,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KataKataColors.pinkCeria.withOpacity(0.3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/mascot_avatar.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser != null ? currentUser.name : 'Memuat...',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: KataKataColors.charcoal,
                      ),
                    ),
                    if (currentUser != null && userProfile != null)
                      Text(
                        'Level ${userProfile.currentLevel}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: KataKataColors.charcoal.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
 
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/statistik');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KataKataColors.kuningCerah,
                  foregroundColor: KataKataColors.charcoal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: KataKataColors.charcoal,
                      width: 2,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon_streak.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Lihat Statistik Lengkap',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
 
            const SizedBox(height: 30),
 
            Text(
              'Pencapaian',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: KataKataColors.offWhite,
                border: Border.all(
                  color: KataKataColors.charcoal.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/achievement_levelup.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Level Up!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/badge_x3.png',
                    width: 32,
                    height: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}