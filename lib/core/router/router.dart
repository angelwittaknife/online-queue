import 'package:go_router/go_router.dart';
import 'package:online_queue/src/labs/presentation/pages/labs_page.dart';
import 'package:online_queue/src/labs/presentation/pages/subjects_page.dart';

import 'package:online_queue/src/queue/presintation/pages/queue_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'subjects',
      builder: (context, state) => const SubjectsPage(),
      routes: [
        GoRoute(
          path: 'labs',
          name: 'labs',
          pageBuilder: (context, state) {
            final subject = state.extra as String;
            return NoTransitionPage(child: LabsPage(subject: subject));
          },
          routes: [
            GoRoute(
              path: 'queue',
              name: 'queue',
              pageBuilder: (context, state) {
                final labId = state.extra as String;
                return NoTransitionPage(child: QueuePage(labId: labId));
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
