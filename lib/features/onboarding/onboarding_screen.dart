import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/widgets/custom_button.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Belajar Seru',
      'description':
          'Dengan Baloo, belajar bahasa jadi menyenangkan dan tidak membosankan.',
      'image': 'mascot_main.png',
    },
    {
      'title': 'Latihan Interaktif',
      'description':
          'Jawab soal pilihan ganda dengan cepat, kumpulkan poin, dan naikkan levelmu!',
      'image': 'mascot_lesson.png',
    },
    {
      'title': 'Progres Terpantau',
      'description':
          'Lihat kemajuanmu setiap hari, pertahankan streak, dan raih pencapaian baru.',
      'image': 'mascot_speech.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 40,
                  child: _currentIndex < _onboardingData.length - 1
                      ? TextButton(
                          onPressed: () => context.go('/signin'),
                          child: Text(
                            'Lewati',
                            style: GoogleFonts.poppins(
                              color: KataKataColors.charcoal.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildPageContent(data: _onboardingData[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 32),
                  KataKataButton(
                    text: _currentIndex == _onboardingData.length - 1
                        ? 'Mulai Petualangan!'
                        : 'Lanjut',
                    onPressed: _handleNext,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent({required Map<String, String> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          MascotWidget(size: 280, assetName: data['image']!),
          const Spacer(flex: 3),
          Text(
            data['title']!,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: KataKataColors.charcoal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data['description']!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: KataKataColors.charcoal.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? KataKataColors.pinkCeria
            : KataKataColors.charcoal.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
