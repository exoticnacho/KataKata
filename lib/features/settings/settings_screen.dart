import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/core/services/user_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with TickerProviderStateMixin {
  bool _notifikasiEnabled = true;
  bool _soundEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 00);
  String _selectedLevel = 'Menengah';
  
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: KataKataColors.pinkCeria,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: KataKataColors.charcoal,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _showLevelSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Tingkat Kesulitan',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
            const SizedBox(height: 16),
            _LevelOption(
              label: 'Pemula',
              isSelected: _selectedLevel == 'Pemula',
              onTap: () {
                setState(() => _selectedLevel = 'Pemula');
                Navigator.pop(context);
              },
            ),
            _LevelOption(
              label: 'Menengah',
              isSelected: _selectedLevel == 'Menengah',
              onTap: () {
                setState(() => _selectedLevel = 'Menengah');
                Navigator.pop(context);
              },
            ),
            _LevelOption(
              label: 'Mahir',
              isSelected: _selectedLevel == 'Mahir',
              onTap: () {
                setState(() => _selectedLevel = 'Mahir');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          const _BackgroundParticles(),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildCurvedHeader(context),
                    Positioned(
                      top: 110,
                      left: 24,
                      right: 24,
                      child: _SlideInElement(
                        controller: _entranceController,
                        delay: 0.2,
                        child: _buildProfileEditCard(currentUser),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 90), 

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.3,
                        child: _SectionLabel(title: 'Preferensi Belajar'),
                      ),
                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.4,
                        child: _buildSettingsGroup(
                          children: [
                            _SwitchTile(
                              icon: Icons.notifications_active_outlined,
                              title: 'Notifikasi Belajar',
                              color: Colors.orange,
                              value: _notifikasiEnabled,
                              onChanged: (val) => setState(() => _notifikasiEnabled = val),
                            ),
                            if (_notifikasiEnabled)
                              _SettingsTile(
                                icon: Icons.access_time_rounded,
                                title: 'Jam Pengingat',
                                color: Colors.blue,
                                trailingText: _reminderTime.format(context),
                                onTap: () => _selectTime(context),
                              ),
                            _SettingsTile(
                              icon: Icons.bar_chart_rounded,
                              title: 'Tingkat Kesulitan',
                              color: Colors.purple,
                              trailingText: _selectedLevel,
                              onTap: () => _showLevelSelector(context),
                            ),
                            _SwitchTile(
                              icon: Icons.volume_up_outlined,
                              title: 'Efek Suara',
                              color: KataKataColors.pinkCeria,
                              value: _soundEnabled,
                              onChanged: (val) => setState(() => _soundEnabled = val),
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.5,
                        child: _SectionLabel(title: 'Akun & Keamanan'),
                      ),
                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.6,
                        child: _buildSettingsGroup(
                          children: [
                            _SettingsTile(
                              icon: Icons.lock_outline_rounded,
                              title: 'Ganti Kata Sandi',
                              color: Colors.green,
                              onTap: () {},
                            ),
                            _SettingsTile(
                              icon: Icons.delete_outline_rounded,
                              title: 'Hapus Akun',
                              color: Colors.red,
                              textColor: Colors.red,
                              onTap: () {},
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.7,
                        child: _SectionLabel(title: 'Lainnya'),
                      ),
                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.8,
                        child: _buildSettingsGroup(
                          children: [
                            _SettingsTile(
                              icon: Icons.help_outline_rounded,
                              title: 'Bantuan & Dukungan',
                              color: Colors.teal,
                              onTap: () {},
                            ),
                            _SettingsTile(
                              icon: Icons.info_outline_rounded,
                              title: 'Tentang Aplikasi',
                              color: Colors.indigo,
                              onTap: () {},
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      _SlideInElement(
                        controller: _entranceController,
                        delay: 0.9,
                        child: _LogoutButton(ref: ref),
                      ),

                      const SizedBox(height: 30),
                      _SlideInElement(
                        controller: _entranceController,
                        delay: 1.0,
                        child: Center(
                          child: Text(
                            'KataKata App v2.1.0\nMade with 💖 in Indonesia',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurvedHeader(BuildContext context) {
    return Container(
      height: 200,
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
          bottom: Radius.elliptical(500, 40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: -20,
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
                children: [
                  _BouncyButton(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Pengaturan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileEditCard(dynamic currentUser) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: KataKataColors.pinkCeria, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mascot_avatar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser?.name ?? 'Pengguna',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  currentUser?.email ?? 'email@contoh.com',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _BouncyButton(
            onTap: () {}, 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: KataKataColors.offWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Edit',
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
    );
  }

  Widget _buildSettingsGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isLast;
  final String? trailingText;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.isLast = false,
    this.trailingText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BouncyButton(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? KataKataColors.charcoal,
                    ),
                  ),
                ),
                if (trailingText != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: KataKataColors.offWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trailingText!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: KataKataColors.pinkCeria,
                        ),
                      ),
                    ),
                  ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFFE0E0E0),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 76,
            endIndent: 20,
            color: Colors.grey.withOpacity(0.1),
          ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: KataKataColors.charcoal,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.white,
                  activeTrackColor: color,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 76,
            endIndent: 20,
            color: Colors.grey.withOpacity(0.1),
          ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final WidgetRef ref;
  const _LogoutButton({required this.ref});

  @override
  Widget build(BuildContext context) {
    return _BouncyButton(
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Mau istirahat?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Text('Progres belajarmu sudah tersimpan kok. Yakin ingin keluar?', style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KataKataColors.pinkCeria,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Ya, Keluar', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) context.go('/signin');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFD1D1)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Keluar Akun',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? KataKataColors.pinkCeria.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? KataKataColors.pinkCeria : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? KataKataColors.pinkCeria : KataKataColors.charcoal,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: KataKataColors.pinkCeria),
          ],
        ),
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

class _SlideInElement extends StatelessWidget {
  final Widget child;
  final double delay;
  final AnimationController controller;

  const _SlideInElement({
    required this.child,
    required this.delay,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(delay, 1.0, curve: Curves.easeOutQuart),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(delay, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _BackgroundParticles extends StatelessWidget {
  const _BackgroundParticles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 150,
          left: 20,
          child: _Particle(color: Colors.blue.withOpacity(0.05), size: 100),
        ),
        Positioned(
          top: 400,
          right: -20,
          child: _Particle(color: KataKataColors.pinkCeria.withOpacity(0.05), size: 150),
        ),
        Positioned(
          bottom: 100,
          left: 50,
          child: _Particle(color: Colors.yellow.withOpacity(0.05), size: 80),
        ),
      ],
    );
  }
}

class _Particle extends StatelessWidget {
  final Color color;
  final double size;

  const _Particle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}