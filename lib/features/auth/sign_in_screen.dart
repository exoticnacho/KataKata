import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: SafeArea(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const MascotWidget(
          assetName: 'mascot_main.png',
          size: 140, 
        ),
        const SizedBox(height: 24),
        Text(
          _isLogin ? 'Selamat Datang!' : 'Buat Akun Baru',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin
              ? 'Ayo lanjutkan progres belajarmu hari ini.'
              : 'Gabung sekarang dan mulai petualangan kata!',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: KataKataColors.charcoal.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
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
                obscureText: true,
              ),
              const SizedBox(height: 24),

              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(
                    color: KataKataColors.pinkCeria,
                  ),
                )
              else
                Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      children: [
                        KataKataButton(
                          text: _isLogin ? 'Masuk' : 'Daftar Sekarang',
                          onPressed: () async {
                            try {
                              if (_isLogin) {
                                await ref.read(authProvider.notifier).login(
                                      widget.emailController.text,
                                      widget.passwordController.text,
                                    );
                              } else {
                                await ref.read(authProvider.notifier).register(
                                      widget.nameController.text,
                                      widget.emailController.text,
                                      widget.passwordController.text,
                                    );
                              }

                              if (context.mounted &&
                                  !ref.read(isAuthenticatedProvider)) {
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Terjadi kesalahan: ${e.toString()}'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'atau',
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),

                        OutlinedButton.icon(
                          onPressed: () async {
                            await ref.read(authProvider.notifier).signInWithGoogle();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.g_mobiledata, size: 35, color: Colors.red),
                          label: Text(
                            'Lanjutkan dengan Google',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: KataKataColors.charcoal,
                              fontWeight: FontWeight.w500,
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

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: KataKataColors.charcoal.withOpacity(0.7),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin ? 'Daftar' : 'Masuk',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KataKataColors.pinkCeria,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}