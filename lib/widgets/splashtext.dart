import 'dart:math';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class WaveTextAnimation extends StatefulWidget {
  const WaveTextAnimation({super.key});

  @override
  State<WaveTextAnimation> createState() => _WaveTextAnimationState();
}

class _WaveTextAnimationState extends State<WaveTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final String text = "Welcome to Jahan Pay";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Continuous loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letters = text.split('');

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(letters.length, (i) {
            final char = letters[i];
            if (char == ' ') {
              return const SizedBox(width: 6); // spacing for spaces
            }

            // Sinusoidal motion for wave
            final double waveY =
                sin((_controller.value * 2 * pi) + (i * 0.4)) * 10;

            // Alternate color based on position
            final bool isPrimary = i % 2 == 0;
            final Color color = isPrimary
                ? AppColors.primaryColor
                : AppColors.appgreen;

            return Transform.translate(
              offset: Offset(0, waveY),
              child: Text(
                char,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.2,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
