import 'package:go_router/go_router.dart';
import 'package:online_queue/src/labs/presentation/pages/labs_page.dart';
import 'package:online_queue/src/labs/presentation/pages/subjects_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'subjects',
      builder: (context, state) => SubjectsPage(),
      routes: [
        GoRoute(
          path: 'labs',
          name: 'labs',
          pageBuilder: (context, state) {
            final subject = state.extra as String?;
            return NoTransitionPage(child: LabsPage(subject: subject!));
          },
        ),
      ],
    ),
  ],
);
