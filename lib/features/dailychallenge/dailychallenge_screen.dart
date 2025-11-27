import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class DailyTask {
  final String id;
  final String title;
  final String description;
  final int target;
  final int current;
  final int xpReward;
  final IconData icon;
  final bool isCompleted;

  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.current,
    required this.xpReward,
    required this.icon,
    this.isCompleted = false,
  });

  DailyTask copyWith({bool? isCompleted, int? current}) {
    return DailyTask(
      id: id,
      title: title,
      description: description,
      target: target,
      current: current ?? this.current,
      xpReward: xpReward,
      icon: icon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ChallengeHistory {
  final String day;
  final int xpEarned;
  final int xpTarget;

  ChallengeHistory(this.day, this.xpEarned, this.xpTarget);
}

class DailyChallengeState {
  final List<DailyTask> tasks;
  final bool canReroll;
  final bool isBonusActive; 

  DailyChallengeState({
    required this.tasks, 
    required this.canReroll,
    this.isBonusActive = false, 
  });
}

class DailyChallengeNotifier extends StateNotifier<DailyChallengeState> {
  DailyChallengeNotifier()
      : super(DailyChallengeState(
          tasks: [
            DailyTask(id: '1', title: 'Pemanasan', description: 'Selesaikan 1 pelajaran', target: 1, current: 0, xpReward: 20, icon: Icons.book_rounded),
            DailyTask(id: '2', title: 'Si Paling Benar', description: 'Jawab 10 soal tanpa salah', target: 10, current: 0, xpReward: 50, icon: Icons.check_circle_outline),
            DailyTask(id: '3', title: 'Pendengar Setia', description: 'Selesaikan 2 sesi listening', target: 2, current: 2, xpReward: 30, icon: Icons.headphones, isCompleted: true),
          ],
          canReroll: true,
          isBonusActive: false,
        ));

  final List<DailyTask> _reserveTasks = [
    DailyTask(id: '4', title: 'Gerak Cepat', description: 'Selesaikan lesson dalam 2 menit', target: 1, current: 0, xpReward: 40, icon: Icons.timer),
    DailyTask(id: '5', title: 'Kolektor Kata', description: 'Pelajari 5 kata baru', target: 5, current: 0, xpReward: 25, icon: Icons.style),
    DailyTask(id: '6', title: 'Social Butterfly', description: 'Tantang 1 teman', target: 1, current: 0, xpReward: 30, icon: Icons.people),
  ];

  void claimBonus() {
    state = DailyChallengeState(
      tasks: state.tasks,
      canReroll: state.canReroll,
      isBonusActive: true, 
    );
  }

  void incrementTaskProgress(String id, {int amount = 1}) {
    state = DailyChallengeState(
      tasks: state.tasks.map((task) {
        if (task.id == id && !task.isCompleted) {
          final newCurrent = task.current + amount;
          final isFinished = newCurrent >= task.target;
          return task.copyWith(
            current: newCurrent > task.target ? task.target : newCurrent,
            isCompleted: isFinished,
          );
        }
        return task;
      }).toList(),
      canReroll: state.canReroll,
      isBonusActive: state.isBonusActive,
    );
  }

  void completeTask(String id) {
    incrementTaskProgress(id, amount: 999);
  }

  void rerollTask(String idToReplace) {
    if (!state.canReroll) return;
    final random = Random();
    final newTask = _reserveTasks[random.nextInt(_reserveTasks.length)];
    state = DailyChallengeState(
      tasks: state.tasks.map((task) {
        if (task.id == idToReplace) return newTask;
        return task;
      }).toList(),
      canReroll: false,
      isBonusActive: state.isBonusActive,
    );
  }
}

final dailyChallengeProvider = StateNotifierProvider<DailyChallengeNotifier, DailyChallengeState>((ref) {
  return DailyChallengeNotifier();
});

final historyProvider = Provider<List<ChallengeHistory>>((ref) {
  return [
    ChallengeHistory('Senin', 100, 100),
    ChallengeHistory('Selasa', 80, 100),
    ChallengeHistory('Rabu', 100, 100),
    ChallengeHistory('Kamis', 40, 100),
    ChallengeHistory('Jumat', 120, 100),
    ChallengeHistory('Sabtu', 0, 100),
    ChallengeHistory('Minggu', 0, 100),
  ];
});

class DailyChallengeScreen extends ConsumerWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeState = ref.watch(dailyChallengeProvider);
    final tasks = challengeState.tasks;
    final canReroll = challengeState.canReroll;
    final isBonusActive = challengeState.isBonusActive;

    final totalXp = tasks.where((t) => t.isCompleted).fold(0, (sum, t) => sum + t.xpReward);
    final maxXp = tasks.fold(0, (sum, t) => sum + t.xpReward);
    final progress = maxXp > 0 ? totalXp / maxXp : 0.0;

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: KataKataColors.charcoal),
        title: Text(
          'Tantangan Harian',
          style: GoogleFonts.poppins(color: KataKataColors.charcoal, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _showHistorySheet(context, ref),
            icon: const Icon(Icons.calendar_month_rounded, color: KataKataColors.violetCerah),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: KataKataColors.kuningCerah, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, size: 20, color: Colors.orange),
                const SizedBox(width: 4),
                Text('3', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressHeader(progress, totalXp, maxXp),
            const SizedBox(height: 24),
            
            _buildBonusChallenge(context, ref, isBonusActive), 
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Misi Hari Ini', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: KataKataColors.charcoal)),
                if (canReroll)
                  TextButton.icon(
                    onPressed: () => _showRerollInfo(context),
                    icon: const Icon(Icons.refresh, size: 16, color: Colors.grey),
                    label: Text('Acak Ulang', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...tasks.map((task) => _buildTaskCard(context, ref, task, canReroll)),
            const SizedBox(height: 30),
            Text('Top Performer Hari Ini', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: KataKataColors.charcoal)),
            const SizedBox(height: 12),
            _buildMiniLeaderboard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(double progress, int currentXp, int maxXp) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [KataKataColors.violetCerah, Color(0xFF9F5DE2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: KataKataColors.violetCerah.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress Harian', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('Reset: 04:23:10', style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.black.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(KataKataColors.kuningCerah),
              minHeight: 20,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$currentXp / $maxXp XP', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.card_giftcard, color: progress >= 1.0 ? KataKataColors.kuningCerah : Colors.white54),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBonusChallenge(BuildContext context, WidgetRef ref, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : const Color(0xFFFFF5E6), // Ubah warna jika aktif
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? Colors.green : Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.orange, 
              shape: BoxShape.circle
            ),
            child: Icon(isActive ? Icons.check : Icons.bolt, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Double XP Aktif!' : 'Double XP Hour!', 
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, 
                    color: isActive ? Colors.green.shade900 : Colors.orange[900]
                  )
                ),
                Text(
                  isActive ? 'Berlaku selama 59 menit lagi.' : 'Aktif selama 1 jam ke depan.', 
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    color: isActive ? Colors.green.shade800 : Colors.orange[800]
                  )
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isActive 
              ? null
              : () {
                  ref.read(dailyChallengeProvider.notifier).claimBonus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Double XP Berhasil Diaktifkan! Selamat Belajar!'), 
                      backgroundColor: Colors.green
                    )
                  );
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.green : Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              minimumSize: const Size(60, 30),
              disabledBackgroundColor: Colors.green.shade200, // Warna saat disabled
            ),
            child: Text(
              isActive ? 'Aktif' : 'Claim', 
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, DailyTask task, bool canReroll) {
    return GestureDetector(
      onTap: () {
        if (!task.isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selesaikan di menu Latihan untuk update progress!'), duration: const Duration(seconds: 2)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: task.isCompleted ? KataKataColors.kuningCerah : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: task.isCompleted ? KataKataColors.kuningCerah.withOpacity(0.2) : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Icon(task.icon, color: task.isCompleted ? Colors.orange : Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: KataKataColors.charcoal)),
                  Text(task.description, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task.target > 0 ? task.current / task.target : 0,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation(KataKataColors.violetCerah),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text('+${task.xpReward} XP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: KataKataColors.violetCerah, fontSize: 12)),
                const SizedBox(height: 4),
                if (task.isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else if (canReroll)
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey, size: 20),
                    onPressed: () => _showRerollConfirm(context, ref, task),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMiniLeaderboard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _buildMiniRankItem('1', 'Rina W.', '09:00 AM', true),
          const Divider(),
          _buildMiniRankItem('2', 'Joko S.', '09:15 AM', false),
          const Divider(),
          _buildMiniRankItem('3', 'Anda', 'On Progress', false, isMe: true),
        ],
      ),
    );
  }

  Widget _buildMiniRankItem(String rank, String name, String time, bool isWinner, {bool isMe = false}) {
    return Row(
      children: [
        Text('#$rank', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(width: 12),
        CircleAvatar(radius: 14, backgroundColor: Colors.grey[200], child: const Icon(Icons.person, size: 16, color: Colors.grey)),
        const SizedBox(width: 8),
        Text(name, style: GoogleFonts.poppins(fontWeight: isMe ? FontWeight.bold : FontWeight.normal)),
        if (isWinner) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.emoji_events, color: Colors.amber, size: 16)),
        const Spacer(),
        Text(time, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  void _showRerollInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tekan tombol refresh pada misi yang ingin diganti.')));
  }

  void _showRerollConfirm(BuildContext context, WidgetRef ref, DailyTask task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ganti Misi?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Anda hanya bisa melakukan ini 1x sehari.', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              ref.read(dailyChallengeProvider.notifier).rerollTask(task.id);
              Navigator.pop(ctx);
            },
            child: const Text('Ganti', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showHistorySheet(BuildContext context, WidgetRef ref) {
    final history = ref.read(historyProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Riwayat 7 Hari', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...history.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(width: 60, child: Text(h.day, style: GoogleFonts.poppins(fontWeight: FontWeight.w500))),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(height: 10, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5))),
                        FractionallySizedBox(
                          widthFactor: (h.xpEarned / h.xpTarget).clamp(0.0, 1.0),
                          child: Container(height: 10, decoration: BoxDecoration(color: h.xpEarned >= h.xpTarget ? Colors.green : KataKataColors.violetCerah, borderRadius: BorderRadius.circular(5))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${h.xpEarned} XP', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}