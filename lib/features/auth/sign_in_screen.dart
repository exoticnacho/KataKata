import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/widgets/input_field.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final isLoading = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: KataKataColors.pinkCeria.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                physics: const BouncingScrollPhysics(),
                child: _SignInScreenBody(
                  emailController: emailController,
                  passwordController: passwordController,
                  nameController: nameController,
                  isLoading: isLoading,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInScreenBody extends ConsumerStatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final bool isLoading;

  const _SignInScreenBody({
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.isLoading,
  });

  @override
  ConsumerState<_SignInScreenBody> createState() => _SignInScreenBodyState();
}

class _SignInScreenBodyState extends ConsumerState<_SignInScreenBody> {
  bool _isLogin = true;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'mascot_hero',
          child: const MascotWidget(
            assetName: 'mascot_main.png',
            size: 140,
          ),
        ),
        const SizedBox(height: 16),
        
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey<bool>(_isLogin),
            children: [
              Text(
                _isLogin ? 'Selamat Datang!' : 'Mulai Petualangan',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: KataKataColors.charcoal,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _isLogin
                      ? 'Lanjutkan progres belajarmu hari ini'
                      : 'Buat akun untuk mulai petualangan bahasa.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: KataKataColors.charcoal.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B8B8B).withOpacity(0.08),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    if (!_isLogin) ...[
                      InputField(
                        controller: widget.nameController,
                        hintText: 'Nama Lengkap',
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                    ],
                    InputField(
                      controller: widget.emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      controller: widget.passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              if (widget.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: KataKataColors.pinkCeria,
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _handleAuthAction(ref, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KataKataColors.pinkCeria,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: KataKataColors.pinkCeria.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Masuk Sekarang' : 'Daftar Gratis',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'atau masuk dengan',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1.5)),
                ],
              ),
              
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    iconSvg: _googleLogoSvg,
                    label: 'Google',
                    onTap: () async {
                      try {
                        await ref.read(authProvider.notifier).signInWithGoogle();
                      } catch (e) {
                         _showError(context, e.toString());
                      }
                    },
                  ),
                  
                  const SizedBox(width: 16),

                  _SocialButton(
                    iconSvg: _githubLogoSvg,
                    label: 'GitHub',
                    isDark: true,
                    onTap: () async {
                      try {
                        await ref.read(authProvider.notifier).signInWithGitHub();
                      } catch (e) {
                        _showError(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        GestureDetector(
          onTap: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.transparent,
            child: RichText(
              text: TextSpan(
                text: _isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: KataKataColors.charcoal.withOpacity(0.6),
                ),
                children: [
                  TextSpan(
                    text: _isLogin ? 'Buat Akun' : 'Login',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.pinkCeria,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showError(BuildContext context, String message) {
     if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops: $message'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
  }

  Future<void> _handleAuthAction(WidgetRef ref, BuildContext context) async {
    try {
      if (_isLogin) {
        await ref.read(authProvider.notifier).login(
              widget.emailController.text.trim(),
              widget.passwordController.text.trim(),
            );
      } else {
        await ref.read(authProvider.notifier).register(
              widget.nameController.text.trim(),
              widget.emailController.text.trim(),
              widget.passwordController.text.trim(),
            );
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }
}

class _SocialButton extends StatelessWidget {
  final String iconSvg;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _SocialButton({
    required this.iconSvg,
    required this.label,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF24292e) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isDark ? null : Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(
                iconSvg,
                width: 22,
                height: 22,
                colorFilter: isDark ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
<path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
<path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
<path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
<path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
<path fill="none" d="M0 0h48v48H0z"/>
</svg>
''';

const String _githubLogoSvg = '''
<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>GitHub</title><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>
''';