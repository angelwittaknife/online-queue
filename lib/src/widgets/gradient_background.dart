import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        const Positioned(
          top: -60,
          left: -60,
          child: _DecorCircle(size: 180, color: Colors.white24),
        ),
        const Positioned(
          top: 40,
          right: -40,
          child: _DecorCircle(size: 120, color: Colors.white10),
        ),
        const Positioned(
          bottom: -80,
          right: -40,
          child: _DecorCircle(size: 220, color: Colors.white12),
        ),
        child,
      ],
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );
  }
}
