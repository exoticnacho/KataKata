import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/widgets/custom_button.dart';
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
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: KataKataColors.pinkCeria.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: KataKataColors.pinkCeria.withOpacity(0.08),
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

class _SignInScreenBody extends StatefulWidget {
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
  _SignInScreenBodyState createState() => _SignInScreenBodyState();
}

class _SignInScreenBodyState extends State<_SignInScreenBody> {
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
            size: 150,
          ),
        ),
        const SizedBox(height: 20),
        
        Column(
          children: [
            Text(
              _isLogin ? 'Selamat Datang!' : 'Mulai Petualangan',
              style: GoogleFonts.poppins(
                fontSize: 26,
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
                    ? 'Lanjutkan progres belajarmu hari ini.'
                    : 'Buat akun dan kuasai bahasa baru sekarang.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: KataKataColors.charcoal.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              if (!_isLogin) ...[
                InputField(
                  controller: widget.nameController,
                  hintText: 'Nama Lengkap',
                  prefixIcon: Icons.person_rounded,
                ),
                const SizedBox(height: 16),
              ],
              InputField(
                controller: widget.emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              InputField(
                controller: widget.passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_rounded,
                obscureText: !_isPasswordVisible, 
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible 
                      ? Icons.visibility_rounded 
                      : Icons.visibility_off_rounded,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
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
                Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              _handleAuthAction(ref, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KataKataColors.pinkCeria,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _isLogin ? 'Masuk' : 'Daftar Sekarang',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'atau',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          ),
                          child: OutlinedButton(
                            onPressed: () async {
                              try {
                                await ref.read(authProvider.notifier).signInWithGoogle();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal: ${e.toString()}'),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(color: Colors.grey.shade300, width: 1),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey.shade100, 
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  _googleLogoSvg, 
                                  width: 24, 
                                  height: 24
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Lanjutkan dengan Google',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: const Color(0xFF1F1F1F),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
          child: RichText(
            text: TextSpan(
              text: _isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: KataKataColors.charcoal.withOpacity(0.6),
              ),
              children: [
                TextSpan(
                  text: _isLogin ? 'Daftar' : 'Masuk',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.pinkCeria,
                    decoration: TextDecoration.underline,
                    decorationColor: KataKataColors.pinkCeria.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
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