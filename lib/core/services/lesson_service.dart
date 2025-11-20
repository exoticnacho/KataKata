import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/data/mock_questions.dart';
import 'package:katakata_app/core/services/user_service.dart';

class Question {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}

class LessonState {
  final List<Question> questions;
  final int currentIndex;
  final String? selectedOption;
  final bool answerSubmitted;
  final bool isCorrect;
  final bool lessonCompleted;

  LessonState({
    required this.questions,
    required this.currentIndex,
    this.selectedOption,
    required this.answerSubmitted,
    required this.isCorrect,
    required this.lessonCompleted,
  });

  LessonState copyWith({
    List<Question>? questions,
    int? currentIndex,
    String? selectedOption,
    bool? answerSubmitted,
    bool? isCorrect,
    bool? lessonCompleted,
  }) {
    return LessonState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOption: selectedOption ?? this.selectedOption,
      answerSubmitted: answerSubmitted ?? this.answerSubmitted,
      isCorrect: isCorrect ?? this.isCorrect,
      lessonCompleted: lessonCompleted ?? this.lessonCompleted,
    );
  }
}

final lessonProvider = StateNotifierProvider.family<LessonNotifier, LessonState, int>((ref, stageNumber) { 
  return LessonNotifier(ref, stageNumber); 
});

class LessonNotifier extends StateNotifier<LessonState> {
  final Ref ref;
  final int stageNumber;

  LessonNotifier(this.ref, this.stageNumber) : super(_initialState(ref, stageNumber));

  static LessonState _initialState(Ref ref, int continuousStageNumber) {
    final currentLevel = ((continuousStageNumber - 1) ~/ 10) + 1;
    final localStage = ((continuousStageNumber - 1) % 10) + 1;
    final levelKey = questionsByLevelAndStage.containsKey(currentLevel) 
        ? currentLevel
        : 6; 
    final stageMap = questionsByLevelAndStage[levelKey]!;
    final initialQuestions = stageMap.containsKey(localStage)
        ? stageMap[localStage]!
        : stageMap[1]!; 

    return LessonState(
      questions: initialQuestions,
      currentIndex: 0,
      selectedOption: null,
      answerSubmitted: false,
      isCorrect: false,
      lessonCompleted: false,
    );
  }

  void selectAnswer(String option) {
    if (state.answerSubmitted) return; 
    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = option == currentQuestion.correctAnswer;
    
    state = state.copyWith(
      selectedOption: option,
      isCorrect: isCorrect,
    );
  }

  void submitAnswer() {
     if (state.selectedOption == null || state.answerSubmitted) return;
     
     state = state.copyWith(
        answerSubmitted: true,
     );
  }
  
  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedOption: null,
        answerSubmitted: false,
        isCorrect: false,
      );
    } else {
      state = state.copyWith(
        lessonCompleted: true,
      );
    }
  }

  void resetLesson() {
    state = _initialState(ref, stageNumber);
  }
}
