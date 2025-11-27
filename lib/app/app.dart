import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/features/splash/splash_screen.dart';
import 'package:katakata_app/features/onboarding/onboarding_screen.dart';
import 'package:katakata_app/features/auth/sign_in_screen.dart';
import 'package:katakata_app/features/main/main_layout_screen.dart';
import 'package:katakata_app/features/home/home_screen.dart';
import 'package:katakata_app/features/lesson/lesson_screen.dart';
import 'package:katakata_app/features/profile/profile_screen.dart';
import 'package:katakata_app/features/statistics/statistics_screen.dart';
import 'package:katakata_app/features/lesson/stage_selection_screen.dart';
import 'package:katakata_app/features/lesson/language_selection_screen.dart';
import 'package:katakata_app/features/statistics/word_list_screen.dart';
import 'package:katakata_app/features/minigames/flashcard_screen.dart';
import 'package:katakata_app/features/minigames/pronunciation_screen.dart';
import 'package:katakata_app/features/leaderboard/leaderboard_screen.dart';
import 'package:katakata_app/features/dailychallenge/dailychallenge_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authState;
      final String location = state.uri.toString();
      final isPublicRoute = (location == '/' || location == '/onboarding' || location == '/signin');
      
      final isAuthRoute = location.startsWith('/home') ||
          location.startsWith('/profile') ||
          location.startsWith('/statistik') ||
          location.startsWith('/lesson') ||
          location.startsWith('/languages') ||
          location.startsWith('/stages') ||
          location.startsWith('/wordlist') ||
          location.startsWith('/flashcard') ||
          location.startsWith('/pronounce') ||
          location.startsWith('/leaderboard') ||
          location.startsWith('/dailychallenge');

      if (!loggedIn && isAuthRoute) {
        return '/signin';
      }

      if (loggedIn && isPublicRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/signin', builder: (context, state) => const SignInScreen()),
      
      ShellRoute(
        builder: (context, state, child) {
          return MainLayoutScreen(child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/statistik', builder: (context, state) => const StatisticsScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          GoRoute(path: '/languages', builder: (context, state) => const LanguageSelectionScreen()),
          GoRoute(path: '/wordlist', builder: (context, state) => const WordListScreen()),
          GoRoute(
            path: '/leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
        ],
      ),
      
      GoRoute(
        path: '/dailychallenge',
        builder: (context, state) => const DailyChallengeScreen(),
      ),
      
      GoRoute(
        path: '/stages',
        builder: (context, state) => const StageSelectionScreen(),
      ),
      GoRoute(
        path: '/lesson/:stageNumber',
        builder: (context, state) {
          final stageNumber = int.tryParse(state.pathParameters['stageNumber'] ?? '1') ?? 1;
          return LessonScreen(stageNumber: stageNumber);
        },
      ),
      GoRoute(
        path: '/flashcard',
        builder: (context, state) => const FlashcardScreen(),
      ),
      GoRoute(
        path: '/pronounce',
        builder: (context, state) => const PronunciationScreen(),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'KataKata',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('id', 'ID'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}