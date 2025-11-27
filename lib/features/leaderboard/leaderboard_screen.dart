import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/user_service.dart';

class LeaderboardUser {
  final String id;
  final String name;
  final String avatar;
  final int xp;
  final int rank;
  final int rankChange;
  final String tier;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.xp,
    required this.rank,
    required this.rankChange,
    required this.tier,
  });
  
  LeaderboardUser copyWith({int? rank}) {
    return LeaderboardUser(
      id: id,
      name: name,
      avatar: avatar,
      xp: xp,
      rank: rank ?? this.rank,
      rankChange: rankChange,
      tier: tier,
    );
  }
}

List<LeaderboardUser> _generateInteractiveLeaderboard(int userRealXp, List<LeaderboardUser> rivals) {
  List<LeaderboardUser> allUsers = List.from(rivals);

  allUsers.add(LeaderboardUser(
    id: 'me',
    name: 'Kamu (User)',
    avatar: 'assets/images/mascot_avatar.png',
    xp: userRealXp,
    rank: 0,
    rankChange: 2, 
    tier: 'Gold',
  ));

  allUsers.sort((a, b) => b.xp.compareTo(a.xp));

  return allUsers.asMap().entries.map((entry) {
    int index = entry.key;
    LeaderboardUser user = entry.value;
    return user.copyWith(rank: index + 1);
  }).toList();
}

final weeklyLeaderboardProvider = Provider<List<LeaderboardUser>>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final myXp = userProfile?.xp ?? 0;

  final rivals = [
    LeaderboardUser(id: '1', name: 'Siti Jagoan', avatar: 'assets/images/mascot_avatar.png', xp: 600, rank: 0, rankChange: 0, tier: 'Diamond'),
    LeaderboardUser(id: '2', name: 'Budi Santoso', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 450, rank: 0, rankChange: 1, tier: 'Diamond'),
    LeaderboardUser(id: '3', name: 'Citra Kirana', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 300, rank: 0, rankChange: -1, tier: 'Gold'),
    LeaderboardUser(id: '4', name: 'Ahmad Dani', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 150, rank: 0, rankChange: 0, tier: 'Gold'),
    LeaderboardUser(id: '5', name: 'Eka Saputra', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 50, rank: 0, rankChange: -2, tier: 'Silver'),
  ];

  return _generateInteractiveLeaderboard(myXp, rivals);
});

final monthlyLeaderboardProvider = Provider<List<LeaderboardUser>>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final myXp = userProfile?.xp ?? 0;

  final myMonthlyXp = myXp + 2000; 

  final rivals = [
    LeaderboardUser(id: '1', name: 'Master Yoda', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 5000, rank: 0, rankChange: 0, tier: 'Diamond'),
    LeaderboardUser(id: '2', name: 'Rangga', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 3500, rank: 0, rankChange: 1, tier: 'Diamond'),
    LeaderboardUser(id: '3', name: 'Cinta', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 2800, rank: 0, rankChange: 5, tier: 'Gold'),
  ];

  return _generateInteractiveLeaderboard(myMonthlyXp, rivals);
});

final allTimeLeaderboardProvider = Provider<List<LeaderboardUser>>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final myXp = userProfile?.xp ?? 0;
  final myAllTimeXp = myXp + 15000; 

  final rivals = [
    LeaderboardUser(id: '1', name: 'Legendary', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 99999, rank: 0, rankChange: 0, tier: 'Mythic'),
    LeaderboardUser(id: '2', name: 'Sepuh Flutter', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 50000, rank: 0, rankChange: 0, tier: 'Mythic'),
  ];

  return _generateInteractiveLeaderboard(myAllTimeXp, rivals);
});

final tierLeaderboardProvider = Provider<List<LeaderboardUser>>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final myXp = userProfile?.xp ?? 0;

  final rivals = [
    LeaderboardUser(id: '1', name: 'Top Global', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 1000, rank: 0, rankChange: 0, tier: 'Gold I'),
    LeaderboardUser(id: '2', name: 'Pro Player', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 800, rank: 0, rankChange: 2, tier: 'Gold I'),
    LeaderboardUser(id: '3', name: 'NoobMaster', avatar: 'assets/images/icon_avatar_placeholder.png', xp: 200, rank: 0, rankChange: -2, tier: 'Gold I'),
  ];

  return _generateInteractiveLeaderboard(myXp, rivals);
});

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = ref.watch(weeklyLeaderboardProvider);
    final monthlyData = ref.watch(monthlyLeaderboardProvider);
    final allTimeData = ref.watch(allTimeLeaderboardProvider);
    final tierData = ref.watch(tierLeaderboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: KataKataColors.charcoal),
        title: Text(
          'Papan Peringkat',
          style: GoogleFonts.poppins(color: KataKataColors.charcoal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: KataKataColors.violetCerah,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          indicatorColor: KataKataColors.violetCerah,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All-Time'),
            Tab(text: 'Tier'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LeaderboardListWithStickyUser(data: weeklyData, bannerText: 'Reset dalam 2 hari. Top 3 naik ke Diamond!', bannerColor: const Color(0xFFE6F7FF), bannerIconColor: Colors.blue),
          _LeaderboardListWithStickyUser(data: monthlyData, bannerText: 'Peringkat Bulan November. Kejar Top 1!', bannerColor: const Color(0xFFFFF5E6), bannerIconColor: Colors.orange),
          _LeaderboardListWithStickyUser(data: allTimeData, bannerText: 'Legenda KataKata sepanjang masa.', bannerColor: const Color(0xFFF3E5F5), bannerIconColor: Colors.purple),
          _LeaderboardListWithStickyUser(data: tierData, bannerText: 'Liga Gold I - Grup B', bannerColor: const Color(0xFFFFFDE7), bannerIconColor: Colors.amber),
        ],
      ),
    );
  }
}

class _LeaderboardListWithStickyUser extends StatelessWidget {
  final List<LeaderboardUser> data;
  final String bannerText;
  final Color bannerColor;
  final Color bannerIconColor;

  const _LeaderboardListWithStickyUser({
    required this.data,
    required this.bannerText,
    required this.bannerColor,
    required this.bannerIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = data.firstWhere((u) => u.id == 'me', orElse: () => data.last);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: bannerColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, size: 16, color: bannerIconColor),
              const SizedBox(width: 8),
              Text(bannerText, style: GoogleFonts.poppins(fontSize: 12, color: bannerIconColor.withOpacity(0.8), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100, top: 8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _buildRankItem(context, data[index]);
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: _buildRankItem(context, currentUser, isSticky: true),
        ),
      ],
    );
  }

  Widget _buildRankItem(BuildContext context, LeaderboardUser user, {bool isSticky = false}) {
    Color textColor = KataKataColors.charcoal;
    bool isTop3 = user.rank <= 3;
    
    if (user.rank == 1) textColor = Colors.orange[800]!;
    else if (user.rank == 2) textColor = Colors.grey[800]!;
    else if (user.rank == 3) textColor = Colors.brown[700]!;

    Color backgroundColor = isSticky ? const Color(0xFFF0F4FF) : Colors.white; 
    if (user.id == 'me' && !isSticky) backgroundColor = const Color(0xFFFFF9C4);

    return Container(
      margin: isSticky ? null : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: isSticky ? Border(top: BorderSide(color: KataKataColors.violetCerah.withOpacity(0.3))) : null,
        boxShadow: isSticky ? null : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#${user.rank}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                if (user.rankChange != 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(user.rankChange > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: user.rankChange > 0 ? Colors.green : Colors.red, size: 14),
                      Text('${user.rankChange.abs()}', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: user.rankChange > 0 ? Colors.green : Colors.red)),
                    ],
                  ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isTop3 ? Colors.amber : Colors.transparent, width: 2)),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(user.avatar),
                  backgroundColor: Colors.grey[200],
                  onBackgroundImageError: (_, __) {},
                ),
              ),
              if (isTop3) const Positioned(bottom: -4, right: -4, child: Icon(Icons.verified, color: Colors.amber, size: 18)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name + (user.id == 'me' ? '' : ''), 
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14), 
                  overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (user.xp % 1000) / 1000,
                          minHeight: 6,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(user.id == 'me' ? KataKataColors.violetCerah : KataKataColors.kuningCerah),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(user.tier, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('${user.xp} XP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: KataKataColors.violetCerah, fontSize: 13)),
        ],
      ),
    );
  }
}