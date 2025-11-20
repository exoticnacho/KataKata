import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/data/mock_words.dart';
import 'package:katakata_app/core/services/user_service.dart';

class FlashcardState {
  final List<LearnedWord> sessionWords;
  final int currentIndex;
  final bool isFlipped;
  final bool sessionCompleted;

  FlashcardState({
    required this.sessionWords,
    required this.currentIndex,
    this.isFlipped = false,
    this.sessionCompleted = false,
  });

  FlashcardState copyWith({
    List<LearnedWord>? sessionWords,
    int? currentIndex,
    bool? isFlipped,
    bool? sessionCompleted,
  }) {
    return FlashcardState(
      sessionWords: sessionWords ?? this.sessionWords,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      sessionCompleted: sessionCompleted ?? this.sessionCompleted,
    );
  }
}

final flashcardProvider =
    StateNotifierProvider<FlashcardNotifier, FlashcardState>((ref) {
  final userProfile = ref.read(userProfileProvider);
  final totalWords = userProfile?.totalWordsTaught ?? 0;

  final wordsForSession = mockLearnedWords.take(totalWords).toList();
  wordsForSession.shuffle();

  final sessionWords = wordsForSession.take(5).toList();

  return FlashcardNotifier(ref, sessionWords);
});

class FlashcardNotifier extends StateNotifier<FlashcardState> {
  final Ref ref;

  FlashcardNotifier(this.ref, List<LearnedWord> initialWords)
      : super(FlashcardState(sessionWords: initialWords, currentIndex: 0));

  void flipCard() {
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  void nextCard(bool mastered) {
    if (state.currentIndex < state.sessionWords.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isFlipped: false,
      );
    } else {
      state = state.copyWith(sessionCompleted: true);
    }
  }

  void completeSession(int newWordsCount) {
    ref.read(userProfileProvider.notifier).addWordsTaught(newWordsCount);
  }
}
