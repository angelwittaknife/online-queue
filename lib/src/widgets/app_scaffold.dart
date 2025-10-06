import 'package:flutter/material.dart';
import 'gradient_background.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GradientBackground(child: child),
      ),
    );
  }
}
