import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildPage(index);
                },
              ),
            ),
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final bool hasClients = _pageController.hasClients;
                    final double page = hasClients
                        ? (_pageController.page ?? 0.0)
                        : 0.0;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: page.round() == index
                            ? KataKataColors.pinkCeria
                            : KataKataColors.charcoal.withOpacity(0.3),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.go('/signin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KataKataColors.pinkCeria,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Mulai Belajar!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final titles = ['Belajar Seru', 'Latihan Interaktif', 'Progres Terpantau'];
    final descriptions = [
      'Dengan Baloo, belajar bahasa jadi menyenangkan dan tidak membosankan.',
      'Jawab soal pilihan ganda dengan cepat dan dapatkan poin!',
      'Lihat kemajuanmu setiap hari dan raih pencapaian baru.',
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const MascotWidget(size: 260, assetName: 'mascot_main.png'),
        const SizedBox(height: 10),
        Text(
          titles[index],
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          descriptions[index],
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: KataKataColors.charcoal.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
