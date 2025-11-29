import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
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
  
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthNotifier(this.ref) : super(false) {
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      if (user != null) {
        _updateUserState(user);
      } else {
        _clearUserState();
      }
    });
  }

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

      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
         final doc = await _db.collection('users').doc(userCredential.user!.uid).get();
         if (!doc.exists) {
           await _db.collection('users').doc(userCredential.user!.uid).set({
             'name': userCredential.user!.displayName ?? 'Pengguna',
             'email': userCredential.user!.email ?? '',
             'streak': 0,
             'totalWordsTaught': 0,
             'currentLevel': 1,
             'xp': 0,
             'isLevelingUp': false,
             'createdAt': FieldValue.serverTimestamp(),
           });
         }
      }

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

  Future<void> register(String name, String email, String password) async {
    state = true;
    try {
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      
      if (userCredential.user != null) {
        await _db.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'streak': 0,
          'totalWordsTaught': 0,
          'currentLevel': 1,
          'xp': 0,
          'isLevelingUp': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

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