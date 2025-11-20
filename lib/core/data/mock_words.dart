class LearnedWord {
  final String english;
  final String indonesian;
  final String level;

  LearnedWord({
    required this.english,
    required this.indonesian,
    required this.level,
  });
}

final List<LearnedWord> mockLearnedWords = [
  LearnedWord(english: 'Hello', indonesian: 'Halo', level: 'Level 1'),
  LearnedWord(english: 'Goodbye', indonesian: 'Selamat tinggal', level: 'Level 1'),
  LearnedWord(english: 'My', indonesian: 'Saya (Kepemilikan)', level: 'Level 1'),
  LearnedWord(english: 'Your', indonesian: 'Kamu (Kepemilikan)', level: 'Level 1'),
  LearnedWord(english: 'Big', indonesian: 'Besar', level: 'Level 1'),
  LearnedWord(english: 'Small', indonesian: 'Kecil', level: 'Level 1'),
  LearnedWord(english: 'Five', indonesian: 'Lima', level: 'Level 1'),
  LearnedWord(english: 'Eat', indonesian: 'Makan', level: 'Level 1'),
  LearnedWord(english: 'Walk', indonesian: 'Berjalan', level: 'Level 1'),
  LearnedWord(english: 'Door', indonesian: 'Pintu', level: 'Level 1'),
  LearnedWord(english: 'Where', indonesian: 'Di mana', level: 'Level 1'),
  LearnedWord(english: 'On', indonesian: 'Di atas', level: 'Level 1'),
  LearnedWord(english: 'Is', indonesian: 'Adalah', level: 'Level 1'),
  LearnedWord(english: 'Write', indonesian: 'Menulis', level: 'Level 1'),

  LearnedWord(english: 'Plays', indonesian: 'Bermain (He/She/It)', level: 'Level 2'),
  LearnedWord(english: 'Go', indonesian: 'Pergi', level: 'Level 2'),
  LearnedWord(english: 'Doesn\'t', indonesian: 'Tidak (negatif)', level: 'Level 2'),

  LearnedWord(english: 'Ate', indonesian: 'Makan (Past Tense)', level: 'Level 3'),
  LearnedWord(english: 'Went', indonesian: 'Pergi (Past Tense)', level: 'Level 3'),
  LearnedWord(english: 'Did', indonesian: 'Apakah (Past Tense)', level: 'Level 3'),

  LearnedWord(english: 'Talking', indonesian: 'Sedang Berbicara', level: 'Level 4'),
  LearnedWord(english: 'Can', indonesian: 'Bisa/Dapat', level: 'Level 5'),
  LearnedWord(english: 'Bigger', indonesian: 'Lebih Besar', level: 'Level 6'),
];
