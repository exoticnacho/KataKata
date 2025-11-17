import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/widgets/input_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _SignInScreenBody(
            emailController: emailController,
            passwordController: passwordController,
            nameController: nameController,
            isLoading: isLoading,
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
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              _isLogin ? 'Masuk' : 'Daftar',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isLogin
                  ? 'Selamat datang kembali!'
                  : 'Mari mulai perjalanan belajar bahasa!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: KataKataColors.charcoal.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 40),
            if (!_isLogin)
              InputField(
                controller: widget.nameController,
                hintText: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
              ),
            const SizedBox(height: 16),
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
              prefixIcon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      if (_isLogin) {
                        await ref.read(authProvider.notifier).login(
                              widget.emailController.text,
                              widget.passwordController.text,
                            );

                        if (context.mounted &&
                            !ref.read(isAuthenticatedProvider)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Login gagal. Email/Password salah.'),
                            ),
                          );
                        }
                      } else {
                        await ref.read(authProvider.notifier).login(
                              widget.emailController.text,
                              widget.passwordController.text,
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: KataKataColors.pinkCeria,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isLogin ? 'Masuk' : 'Daftar Sekarang',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin
                      ? 'Belum punya akun? '
                      : 'Sudah punya akun? ',
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
          ],
        );
      },
    );
  }
}