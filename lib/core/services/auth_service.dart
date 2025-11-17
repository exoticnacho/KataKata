import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final userProvider = StateProvider<User?>((ref) => null);

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;

  AuthNotifier(this.ref) : super(false);

  Future<void> login(String email, String password) async {
    state = true;

    await Future.delayed(const Duration(seconds: 1));

    if (email == 'user@example.com' && password == 'password') {
      ref.read(userProvider.notifier).state = User(
        id: '1',
        name: 'Pengguna KataKata',
        email: email,
      );

      ref.read(isAuthenticatedProvider.notifier).state = true;
    }

    state = false;
  }

  Future<void> logout() async {
    ref.read(userProvider.notifier).state = null;
    ref.read(isAuthenticatedProvider.notifier).state = false;
  }
}