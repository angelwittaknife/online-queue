import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/presentation/pages/auth_page.dart';
import 'package:online_queue/src/labs/presentation/pages/labs_page.dart';
import 'package:online_queue/src/labs/presentation/pages/subjects_page.dart';
import 'package:online_queue/src/queue/presentation/pages/queue_page.dart';

final FirebaseAuth _auth = sl<FirebaseAuth>();

class AuthChangeNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _subscription;

  AuthChangeNotifier() {
    _subscription = _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authChangeNotifier = AuthChangeNotifier();

final router = GoRouter(
  // Не указываем fixed initialLocation, чтобы GoRouter сам выбрал маршрут
  initialLocation: '/auth',

  refreshListenable: authChangeNotifier,

  redirect: (context, state) async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;
    print(user);
    final isLoggedIn = user != null;
    final goingToAuth = state.matchedLocation == '/auth';

    if (!isLoggedIn && !goingToAuth) return '/auth';
    if (isLoggedIn && goingToAuth) return '/subjects';
    return null;
  },

  routes: [
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (_, __) => const AuthPage(),
    ),
    GoRoute(
      path: '/subjects',
      name: 'subjects',
      builder: (_, __) => const SubjectsPage(),
    ),
    GoRoute(
      path: '/labs',
      name: 'labs',
      pageBuilder: (context, state) {
        final subject = state.extra as String?;
        if (subject == null) {
          return const NoTransitionPage(
            child: Scaffold(
              body: Center(child: Text('Ошибка: предмет не передан')),
            ),
          );
        }
        return NoTransitionPage(child: LabsPage(subject: subject));
      },
    ),
    GoRoute(
      path: '/queue',
      name: 'queue',
      pageBuilder: (context, state) {
        final labId = state.extra as String?;
        if (labId == null) {
          return const NoTransitionPage(
            child: Scaffold(
              body: Center(child: Text('Ошибка: лаборатория не передана')),
            ),
          );
        }
        return NoTransitionPage(child: QueuePage(labId: labId));
      },
    ),
  ],
);
