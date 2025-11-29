import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class UserProfile {
  final String name;
  final int streak;
  final int totalWordsTaught;
  final int currentLevel;
  final int xp;
  final bool isLevelingUp;

  UserProfile({
    required this.name,
    required this.streak,
    required this.totalWordsTaught,
    required this.currentLevel,
    required this.xp,
    this.isLevelingUp = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'streak': streak,
      'totalWordsTaught': totalWordsTaught,
      'currentLevel': currentLevel,
      'xp': xp,
      'isLevelingUp': isLevelingUp,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? 'Pengguna',
      streak: map['streak'] ?? 0,
      totalWordsTaught: map['totalWordsTaught'] ?? 0,
      currentLevel: map['currentLevel'] ?? 1,
      xp: map['xp'] ?? 0,
      isLevelingUp: map['isLevelingUp'] ?? false,
    );
  }

  UserProfile copyWith({
    String? name,
    int? streak,
    int? totalWordsTaught,
    int? currentLevel,
    int? xp,
    bool? isLevelingUp,
  }) {
    return UserProfile(
      name: name ?? this.name,
      streak: streak ?? this.streak,
      totalWordsTaught: totalWordsTaught ?? this.totalWordsTaught,
      currentLevel: currentLevel ?? this.currentLevel,
      xp: xp ?? this.xp,
      isLevelingUp: isLevelingUp ?? this.isLevelingUp,
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserProfileNotifier(this.ref) : super(null) {
    ref.listen<bool>(isAuthenticatedProvider, (bool? previous, bool? next) {
      if (next == true) {
        _loadUserProfile();
      } else if (next == false) {
        state = null;
      }
    });
    
    if (ref.read(isAuthenticatedProvider)) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    final user = ref.read(userProvider);
    if (user == null) return;

    try {
      final doc = await _db.collection('users').doc(user.id).get();
      
      if (doc.exists && doc.data() != null) {
        state = UserProfile.fromMap(doc.data()!);
      } else {
        final newProfile = UserProfile(
          name: user.name,
          streak: 0,
          totalWordsTaught: 0,
          currentLevel: 1,
          xp: 0,
          isLevelingUp: false,
        );
        await _db.collection('users').doc(user.id).set(newProfile.toMap());
        state = newProfile;
      }
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  Future<void> _saveToFirestore(UserProfile profile) async {
    final user = ref.read(userProvider);
    if (user != null) {
      try {
        await _db.collection('users').doc(user.id).update(profile.toMap());
      } catch (e) {
        print("Error saving to firestore: $e");
      }
    }
  }

  void addXp(int xpToAdd) {
    if (state != null) {
      int newXp = state!.xp + xpToAdd;
      int oldLevel = state!.currentLevel;
      int requiredXpForNextLevel = oldLevel * 1000;

      if (newXp >= requiredXpForNextLevel) {
        levelUp();
      } else {
        state = state!.copyWith(xp: newXp);
        _saveToFirestore(state!);
      }
    }
  }

  void addWordsTaught(int wordsToAdd) {
    if (state != null) {
      final newState = state!.copyWith(
        totalWordsTaught: state!.totalWordsTaught + wordsToAdd,
      );
      state = newState;
      _saveToFirestore(newState);
    }
  }

  void levelUp() {
    if (state != null) {
      int nextLevel = state!.currentLevel + 1;
      int currentXp = state!.xp; 

      final newState = state!.copyWith(
        currentLevel: nextLevel,
        xp: currentXp, 
        isLevelingUp: true,
      );
      state = newState;
      _saveToFirestore(newState);
    }
  }

  void resetLevelUpStatus() {
    if (state != null && state!.isLevelingUp) {
      final newState = state!.copyWith(isLevelingUp: false);
      state = newState;
      _saveToFirestore(newState);
    }
  }
}