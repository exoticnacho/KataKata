import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/core/services/user_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _buildCurvedHeader(context),
                
                Positioned(
                  top: 100,
                  child: Column(
                    children: [
                      _buildAvatar(),
                      const SizedBox(height: 12),
                      _buildUserInfo(currentUser, userProfile),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 150),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeeklyActivity(),

                  const SizedBox(height: 24),

                  _buildDailyGoalCard(),

                  const SizedBox(height: 24),

                  _buildStatsGrid(userProfile),
                  
                  const SizedBox(height: 24),
                  
                  _buildMainActionCard(context),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pencapaian',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KataKataColors.charcoal,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Lihat Semua',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: KataKataColors.pinkCeria,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  _buildAchievementList(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedHeader(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            KataKataColors.pinkCeria,
            Color(0xFFFF8FA3),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(500, 60),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profil Saya',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Konsisten adalah kunci!',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  _BouncyButton(
                    onTap: () => context.push('/settings'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mascot_avatar.png',
                fit: BoxFit.cover,
                width: 130,
                height: 130,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: KataKataColors.kuningCerah,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            size: 16,
            color: KataKataColors.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(dynamic currentUser, dynamic userProfile) {
    return Column(
      children: [
        Text(
          currentUser != null ? currentUser.name : 'Memuat...',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'FREE MEMBER',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 220,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userProfile = 'Level 2',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.pinkCeria,
                    ),
                  ),
                  Text(
                    '350 / 500 XP',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: const Color(0xFFF0F0F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(KataKataColors.pinkCeria),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyActivity() {
    final days = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
    final activeDays = [true, true, true, false, false, false, false]; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Mingguan',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isActive = activeDays[index];
            return Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? KataKataColors.pinkCeria : Colors.transparent,
                    border: Border.all(
                      color: isActive ? KataKataColors.pinkCeria : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: isActive
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  days[index],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? KataKataColors.charcoal : Colors.grey,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDailyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.track_changes, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Harian',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                ),
                Text(
                  '15 / 30 Menit',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: 0.5,
              strokeWidth: 5,
              backgroundColor: Colors.grey[100],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(dynamic userProfile) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Streak',
            value: '3',
            unit: 'Hari',
            icon: 'assets/images/icon_streak.png', 
            color: const Color(0xFFFF9F1C),
            bgColor: const Color(0xFFFFF4E3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Kata Dipelajari',
            value: '120+', 
            unit: 'Kata Dipelajari',
            icon: 'assets/images/icon_total_words.png',
            color: Colors.blue,
            bgColor: Colors.blue.withOpacity(0.1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Ranking',
            value: '#4',
            unit: 'All Time',
            icon: Icons.emoji_events_rounded,
            color: const Color(0xFFFFBF00),
            bgColor: const Color(0xFFFFF9E1),
          ),
        ),
      ],
    );
  }

  Widget _buildMainActionCard(BuildContext context) {
    return _BouncyButton(
      onTap: () => context.push('/statistik'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              KataKataColors.kuningCerah,
              Color(0xFFFFD54F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: KataKataColors.kuningCerah.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistik Belajar',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lihat detail progres harianmu di sini',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: KataKataColors.charcoal.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: KataKataColors.charcoal,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementList() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        children: const [
          _AchievementCard3D(
            imagePath: 'assets/images/achievement_levelup.png',
            title: 'Level Up',
            subtitle: 'Mencapai Lv.2',
            color: Color(0xFFE3F2FD),
          ),
          SizedBox(width: 16),
          _AchievementCard3D(
            imagePath: 'assets/images/icon_streak.png',
            title: 'On Fire',
            subtitle: '3 Hari Streak',
            color: Color(0xFFFFF3E0),
          ),
          SizedBox(width: 16),
          _AchievementCard3D(
            imagePath: 'assets/images/badge_x3.png',
            title: 'Master',
            subtitle: 'Sempurna Quiz',
            color: Color(0xFFF3E5F5),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final dynamic icon; 
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF0F0F0),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: icon is IconData 
              ? Icon(icon as IconData, color: color, size: 20)
              : Image.asset(icon as String, width: 20, height: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: KataKataColors.charcoal,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard3D extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color color;

  const _AchievementCard3D({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 45, height: 45),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: KataKataColors.charcoal,
            ),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: KataKataColors.charcoal.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyButton({required this.child, required this.onTap});

  @override
  State<_BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<_BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}