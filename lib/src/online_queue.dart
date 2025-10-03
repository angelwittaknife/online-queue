import 'package:flutter/material.dart';
import 'package:online_queue/core/router/router.dart';

class OnlineQueue extends StatelessWidget {
  const OnlineQueue({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

