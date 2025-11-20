import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/data/mock_words.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:katakata_app/widgets/custom_button.dart';

final pronunciationStateProvider = StateProvider<PronunciationState>((ref) {
  final int randomIndex = (mockLearnedWords.length * 0.4).toInt();
  final targetWord = mockLearnedWords.isNotEmpty
      ? mockLearnedWords[randomIndex]
      : LearnedWord(english: "Hello", indonesian: "Halo", level: "Level 1");

  return PronunciationState(targetWord: targetWord);
});

class PronunciationState {
  final LearnedWord targetWord;
  final bool isListening;
  final String recognizedText;
  final String statusMessage;
  final bool isInitialized;
  final bool isCorrect;

  PronunciationState({
    required this.targetWord,
    this.isListening = false,
    this.recognizedText = '',
    this.statusMessage = 'Tekan mikrofon dan ucapkan kata ini.',
    this.isInitialized = false,
    this.isCorrect = false,
  });

  PronunciationState copyWith({
    LearnedWord? targetWord,
    bool? isListening,
    String? recognizedText,
    String? statusMessage,
    bool? isInitialized,
    bool? isCorrect,
  }) {
    return PronunciationState(
      targetWord: targetWord ?? this.targetWord,
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      statusMessage: statusMessage ?? this.statusMessage,
      isInitialized: isInitialized ?? this.isInitialized,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

class PronunciationScreen extends ConsumerStatefulWidget {
  const PronunciationScreen({super.key});

  @override
  ConsumerState<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends ConsumerState<PronunciationScreen> {
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onError: (e) => print('Speech Error: $e'),
      onStatus: (status) => print('Speech Status: $status'),
    );

    final notifier = ref.read(pronunciationStateProvider.notifier);
    if (available) {
      notifier.update((state) => state.copyWith(
            isInitialized: true,
            statusMessage: 'Siap! Tekan Mic untuk mulai berbicara.',
          ));
    } else {
      notifier.update((state) => state.copyWith(
            isInitialized: false,
            statusMessage: 'Error: Speech Recognition tidak tersedia.',
          ));
    }
  }

  void _startListening() async {
    final state = ref.read(pronunciationStateProvider);
    if (!state.isInitialized || state.isListening) return;

    ref.read(pronunciationStateProvider.notifier).update((s) => s.copyWith(
          isListening: true,
          recognizedText: '',
          statusMessage: 'Dengarkan... Ucapkan kata target.',
          isCorrect: false,
        ));

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenMode: ListenMode.confirmation,
      localeId: 'en_US',
      listenFor: const Duration(seconds: 5),
    );
  }

  void _stopListening() async {
    ref.read(pronunciationStateProvider.notifier).update((s) => s.copyWith(isListening: false));
    await _speechToText.stop();
  }

  void _onSpeechResult(result) {
    if (result.finalResult) {
      final recognized = result.recognizedWords.toLowerCase().trim();
      final target = ref.read(pronunciationStateProvider).targetWord.english.toLowerCase().trim();
      final bool correct = recognized.contains(target) && recognized.length < (target.length * 1.5);

      ref.read(pronunciationStateProvider.notifier).update((s) => s.copyWith(
            isListening: false,
            recognizedText: recognized,
            statusMessage: correct ? 'HEBAT! Pengucapan sangat baik.' : 'Ulangi: Coba ucapkan lebih jelas.',
            isCorrect: correct,
          ));
    }
  }

  void _nextWord() {
    _stopListening();
    if (mockLearnedWords.isEmpty) return;

    final int randomIndex = (mockLearnedWords.length * 0.4).toInt();
    final newTargetWord = mockLearnedWords[randomIndex];

    ref.read(pronunciationStateProvider.notifier).update((s) => PronunciationState(
          targetWord: newTargetWord,
          isInitialized: true,
          statusMessage: 'Siap! Tekan Mic untuk mulai berbicara.',
        ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pronunciationStateProvider);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: KataKataColors.offWhite,
        elevation: 1,
        title: Text(
          'Latihan Pengucapan',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: KataKataColors.charcoal),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ucapkan:',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: KataKataColors.charcoal),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: KataKataColors.kuningCerah,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KataKataColors.charcoal),
              ),
              child: Text(
                state.targetWord.english,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w900, color: KataKataColors.charcoal),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: state.isListening ? _stopListening : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.isListening
                      ? Colors.red.shade400
                      : (state.isCorrect ? Colors.green.shade400 : KataKataColors.violetCerah),
                  boxShadow: state.isListening
                      ? [BoxShadow(color: Colors.red.shade900, blurRadius: 10, spreadRadius: 3)]
                      : [BoxShadow(color: KataKataColors.charcoal.withOpacity(0.3), offset: const Offset(4, 4))],
                ),
                child: Icon(
                  state.isListening ? Icons.stop : Icons.mic,
                  size: 48,
                  color: KataKataColors.offWhite,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Status:',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: KataKataColors.charcoal),
            ),
            Text(
              state.statusMessage,
              style: GoogleFonts.poppins(fontSize: 16, color: KataKataColors.charcoal.withOpacity(0.8)),
            ),
            const SizedBox(height: 10),
            if (state.recognizedText.isNotEmpty)
              Text(
                'Anda mengucapkan: "${state.recognizedText}"',
                style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, color: KataKataColors.charcoal),
              ),
            const Spacer(),
            KataKataButton(
              text: 'Kata Berikutnya',
              onPressed: _nextWord,
              backgroundColor: KataKataColors.violetCerah,
            ),
            const SizedBox(height: 12),
            KataKataButton(
              text: 'Kembali ke Home',
              onPressed: () => context.go('/home'),
              backgroundColor: KataKataColors.charcoal.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
