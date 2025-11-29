import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Tambah ini
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/firebase_options.dart'; // 2. Tambah ini (File hasil flutterfire configure)

import 'package:katakata_app/features/auth/sign_in_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KataKata App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const SignInScreen(), 
    );
  }
}