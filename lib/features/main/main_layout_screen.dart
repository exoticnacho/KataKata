import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;

  const MainLayoutScreen({super.key, required this.child});

  static const double iconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = _calculateIndex(location);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: KataKataColors.charcoal.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: KataKataColors.pinkCeria,
          unselectedItemColor: KataKataColors.charcoal.withOpacity(0.6),
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 0 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/logo_katakata.png',
                  height: iconSize,
                  color: currentIndex == 0
                      ? KataKataColors.pinkCeria
                      : KataKataColors.charcoal,
                ),
              ),
              label: 'Latihan',
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 1 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/icon_streak.png',
                  height: iconSize,
                  color: currentIndex == 1
                      ? KataKataColors.pinkCeria
                      : KataKataColors.charcoal,
                ),
              ),
              label: 'Statistik',
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 2 ? 1.0 : 0.6,
                child: Icon(
                  Icons.auto_stories,
                  size: iconSize,
                  color: currentIndex == 2
                      ? KataKataColors.pinkCeria
                      : KataKataColors.charcoal,
                ),
              ),
              label: 'Glosarium',
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 3 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/icon_avatar_placeholder.png',
                  height: iconSize,
                  color: currentIndex == 3
                      ? KataKataColors.pinkCeria
                      : KataKataColors.charcoal,
                ),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/statistik')) return 1;
    if (location.startsWith('/wordlist')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/statistik');
        break;
      case 2:
        context.go('/wordlist');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
