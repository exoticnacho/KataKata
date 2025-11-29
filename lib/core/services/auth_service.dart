import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  AppUser({
    required this.id, 
    required this.name, 
    required this.email,
    this.photoUrl,
  });
}

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);
final userProvider = StateProvider<AppUser?>((ref) => null);
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;
  
  // Instance Firebase & Google
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthNotifier(this.ref) : super(false) {
    // Listener: Cek status login secara realtime
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      if (user != null) {
        _updateUserState(user);
      } else {
        _clearUserState();
      }
    });
  }

  // 1. FUNGSI GOOGLE SIGN IN 
  Future<void> signInWithGoogle() async {
    state = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        state = false; 
        return; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Error Google Sign In: $e");
      rethrow;
    } finally {
      state = false; 
    }
  }

  Future<void> login(String email, String password) async {
    state = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error Login: $e");
      rethrow;
    } finally {
      state = false;
    }
  }

  // 3. FUNGSI REGISTER 
  Future<void> register(String name, String email, String password) async {
    state = true;
    try {
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      
      final updatedUser = _auth.currentUser;
      if (updatedUser != null) {
         _updateUserState(updatedUser);
      }
    } catch (e) {
      print("Error Register: $e");
      rethrow;
    } finally {
      state = false;
    }
  }

  // 4. FUNGSI LOGOUT
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _clearUserState();
  }

  void _updateUserState(firebase_auth.User firebaseUser) {
    final appUser = AppUser(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'Pengguna',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );

    ref.read(userProvider.notifier).state = appUser;
    ref.read(isAuthenticatedProvider.notifier).state = true;
  }

  void _clearUserState() {
    ref.read(userProvider.notifier).state = null;
    ref.read(isAuthenticatedProvider.notifier).state = false;
  }
}