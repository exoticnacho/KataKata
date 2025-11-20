import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/lesson_service.dart';
import 'package:katakata_app/core/services/user_service.dart';
import 'package:katakata_app/widgets/custom_button.dart';
import 'package:katakata_app/widgets/level_up_modal.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class LessonScreen extends ConsumerWidget {
  final int stageNumber;

  const LessonScreen({super.key, required this.stageNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final lessonState = ref.watch(lessonProvider(stageNumber));
    final lessonNotifier = ref.read(lessonProvider(stageNumber).notifier);

    final currentQuestion = lessonState.questions[lessonState.currentIndex];

    final currentLevel = ((stageNumber - 1) ~/ 10) + 1;
    final localStage = ((stageNumber - 1) % 10) + 1;

    if (lessonState.lessonCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          _handleLessonCompletion(context, ref);
        }
      });
      return const Scaffold(backgroundColor: KataKataColors.offWhite);
    }

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: KataKataColors.offWhite,
        elevation: 1,
        title: Text(
          'Latihan Level $currentLevel - Stage $localStage',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (lessonState.currentIndex + 1) / lessonState.questions.length,
              backgroundColor: KataKataColors.charcoal.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(KataKataColors.kuningCerah),
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: KataKataColors.kuningCerah,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: KataKataColors.charcoal),
                  boxShadow: [
                    BoxShadow(
                      color: KataKataColors.charcoal.withOpacity(0.4),
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    )
                  ]),
              child: Text(
                currentQuestion.text,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KataKataColors.charcoal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: List.generate(
                  currentQuestion.options.length,
                  (index) {
                    final option = currentQuestion.options[index];
                    final isSelected = lessonState.selectedOption == option;
                    final isCorrect = option == currentQuestion.correctAnswer;

                    Color buttonColor = KataKataColors.offWhite;
                    Color borderColor = KataKataColors.charcoal;
                    double shadowOffset = 4.0;

                    if (lessonState.answerSubmitted) {
                      if (isCorrect) {
                        buttonColor = Colors.green.shade400;
                        borderColor = Colors.green.shade800;
                        shadowOffset = 0.0;
                      } else if (isSelected) {
                        buttonColor = Colors.red.shade400;
                        borderColor = Colors.red.shade800;
                        shadowOffset = 0.0;
                      }
                    } else if (isSelected) {
                      buttonColor = KataKataColors.kuningCerah;
                      shadowOffset = 2.0;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: lessonState.answerSubmitted
                            ? null
                            : () => lessonNotifier.selectAnswer(option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      KataKataColors.charcoal.withOpacity(0.3),
                                  offset: Offset(shadowOffset, shadowOffset),
                                  blurRadius: 0,
                                ),
                              ]),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: Image.asset(
                                  'assets/images/icon_lesson_option.png',
                                  width: 45,
                                  height: 45,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: KataKataColors.charcoal,
                                  ),
                                ),
                              ),
                              if (lessonState.answerSubmitted)
                                if (isCorrect)
                                  const MascotWidget(
                                      size: 24, assetName: 'mascot_lesson.png')
                                else if (isSelected)
                                  const Icon(Icons.close,
                                      color: KataKataColors.charcoal, size: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (lessonState.selectedOption != null)
              SizedBox(
                width: double.infinity,
                child: KataKataButton(
                  text: lessonState.answerSubmitted
                      ? (lessonState.currentIndex <
                              lessonState.questions.length - 1
                          ? 'Lanjut'
                          : 'Selesai')
                      : 'Cek Jawaban',
                  onPressed: () {
                    if (lessonState.answerSubmitted) {
                      if (lessonState.isCorrect && userProfile != null) {
                        ref.read(userProfileProvider.notifier).addXp(10);
                      }
                      lessonNotifier.nextQuestion();
                    } else {
                      lessonNotifier.submitAnswer();
                    }
                  },
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        KataKataColors.violetCerah.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'Pilih Jawaban Dulu',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KataKataColors.offWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: KataKataColors.charcoal, width: 2),
        ),
        title: Text(
          'Keluar Latihan?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        content: Text(
          'Anda belum menyelesaikan stage ini. XP dari jawaban benar yang sudah Anda kumpulkan akan tersimpan, tetapi Anda akan diarahkan kembali ke Stage Selection.',
          style: GoogleFonts.poppins(color: KataKataColors.charcoal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Lanjutkan Latihan',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: KataKataColors.violetCerah,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/stages');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLessonCompletion(BuildContext context, WidgetRef ref) {
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final lessonNotifier = ref.read(lessonProvider(stageNumber).notifier);

    final userProfileBefore = ref.read(userProfileProvider);

    if (userProfileBefore != null) {
      userProfileNotifier.addXp(100);
    }

    lessonNotifier.resetLesson();

    final bool didLevelUp =
        ref.read(userProfileProvider)?.isLevelingUp == true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _buildLessonCompleteModalContent(context, didLevelUp);
      },
    ).then((_) {
      if (didLevelUp) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LevelUpModal(
              newLevel: userProfileNotifier.state?.currentLevel ?? 2),
        ).then((__) {
          context.go('/home');
        });
      } else {
        context.go('/stages');
      }
    });
  }

  Widget _buildLessonCompleteModalContent(
      BuildContext context, bool isLevelUp) {
    final currentLevel = ((stageNumber - 1) ~/ 10) + 1;
    final localStage = ((stageNumber - 1) % 10) + 1;

    return AlertDialog(
      backgroundColor: KataKataColors.offWhite,
      title: Center(
        child: Text(
          'Latihan Selesai!',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MascotWidget(size: 64, assetName: 'mascot_main.png'),
          const SizedBox(height: 20),
          Text(
            isLevelUp
                ? 'Level Up Menanti!'
                : 'Kamu telah menyelesaikan Stage $localStage di Level $currentLevel.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: KataKataColors.charcoal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            '+100 XP',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KataKataColors.kuningCerah,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            isLevelUp ? 'Lihat Level Up!' : 'Lanjut ke Stage',
            style: GoogleFonts.poppins(
              color: KataKataColors.pinkCeria,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
