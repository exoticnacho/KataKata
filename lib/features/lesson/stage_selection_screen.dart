import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/user_service.dart';

class StageSelectionScreen extends ConsumerWidget {
  const StageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final currentLevel = userProfile?.currentLevel ?? 1;
    final currentXp = userProfile?.xp ?? 0;

    const int stagesPerLevel = 10;
    final int baseStage = (currentLevel - 1) * stagesPerLevel;
    final int xpInCurrentLevel = currentXp % 1000;
    final int completedStages = xpInCurrentLevel ~/ 100;
    final int nextStageToUnlock = completedStages + 1;
    final int unlockedStagesInCurrentLevel = nextStageToUnlock.clamp(1, stagesPerLevel);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: KataKataColors.offWhite,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Level $currentLevel: Pilih Latihan',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 11.0,
            mainAxisSpacing: 11.0,
            childAspectRatio: 0.9,
          ),
          itemCount: stagesPerLevel,
          itemBuilder: (context, index) {
            final localStageNumber = index + 1;
            final globalStageNumber = baseStage + localStageNumber;
            final isUnlocked = localStageNumber <= unlockedStagesInCurrentLevel;
            final isCurrentStage = localStageNumber == nextStageToUnlock;

            return GestureDetector(
              onTap: isUnlocked
                  ? () {
                      context.push('/lesson/$globalStageNumber');
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isCurrentStage
                      ? KataKataColors.pinkCeria
                      : (isUnlocked
                          ? KataKataColors.kuningCerah
                          : KataKataColors.charcoal.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: KataKataColors.charcoal,
                      width: isCurrentStage ? 3 : 2),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: KataKataColors.charcoal.withOpacity(0.4),
                            offset: const Offset(4, 4),
                            blurRadius: 0,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCurrentStage
                          ? Icons.play_arrow
                          : (isUnlocked ? Icons.check_circle : Icons.lock),
                      size: 40,
                      color: isCurrentStage
                          ? KataKataColors.offWhite
                          : (isUnlocked
                              ? KataKataColors.charcoal
                              : KataKataColors.charcoal.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stage $localStageNumber',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isCurrentStage
                            ? KataKataColors.offWhite
                            : (isUnlocked
                                ? KataKataColors.charcoal
                                : KataKataColors.charcoal.withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCurrentStage
                          ? 'Mulai!'
                          : (isUnlocked ? 'Selesai' : 'Terkunci'),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isCurrentStage
                            ? KataKataColors.offWhite.withOpacity(0.8)
                            : KataKataColors.charcoal.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
