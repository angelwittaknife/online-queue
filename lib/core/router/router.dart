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

/// 🔄 Следит за изменением токена и статуса авторизации
class AuthChangeNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _subscription;

  AuthChangeNotifier() {
    // idTokenChanges реагирует и на logout, и на истечение токена, и на удалённого пользователя
    _subscription = _auth.idTokenChanges().listen((_) {
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
  initialLocation: '/auth',
  refreshListenable: authChangeNotifier,
  debugLogDiagnostics: true, // 👀 помогает отладить редиректы
  redirect: (context, state) async {
    final user = _auth.currentUser;
    final goingToAuth = state.matchedLocation == '/auth';

    // 🧠 Принудительно обновляем данные пользователя из Firebase
    if (user != null) {
      try {
        await user.reload(); // проверка актуальности токена
      } on FirebaseAuthException catch (_) {
        await _auth.signOut();
        return '/auth';
      } catch (_) {
        await _auth.signOut();
        return '/auth';
      }
    }

    final isLoggedIn = _auth.currentUser != null;

    // 🧭 Роутинг в зависимости от статуса
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

    /// Главная страница после входа
    GoRoute(
      path: '/subjects',
      name: 'subjects',
      builder: (_, __) => const SubjectsPage(),

      routes: [
        GoRoute(
          path: 'labs',
          name: 'labs',
          builder: (context, state) {
            final subject = state.extra as String?;
            if (subject == null) {
              return const Scaffold(
                body: Center(child: Text('Ошибка: предмет не передан')),
              );
            }
            return LabsPage(subject: subject);
          },
        ),
        GoRoute(
          path: 'queue',
          name: 'queue',
          builder: (context, state) {
            final labId = state.extra as String?;
            if (labId == null) {
              return const Scaffold(
                body: Center(child: Text('Ошибка: лаборатория не передана')),
              );
            }
            return QueuePage(labId: labId);
          },
        ),
      ],
    ),
  ],
);
