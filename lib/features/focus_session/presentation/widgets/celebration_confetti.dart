import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

/// Subtle confetti animation for session completion
///
/// Design: Minimal particle count, slow-falling, fades out quickly
/// Performance: <60 particles, simple physics, no complex shapes
class CelebrationConfetti extends StatefulWidget {
  const CelebrationConfetti({
    super.key,
    this.particleCount = 40,
    this.duration = const Duration(seconds: 4),
  });

  final int particleCount;
  final Duration duration;

  @override
  State<CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<CelebrationConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    // Generate particles with random properties
    final random = math.Random();
    _particles = List.generate(widget.particleCount, (index) {
      return _ConfettiParticle(
        color: _getRandomColor(random),
        startX: random.nextDouble(),
        startY: -0.1 - (random.nextDouble() * 0.2), // Start above screen
        endY: 1.2, // End below screen
        drift: (random.nextDouble() - 0.5) * 0.3, // Horizontal drift
        rotationSpeed: (random.nextDouble() - 0.5) * 4,
        size: 3.0 + random.nextDouble() * 5.0,
        delay: random.nextDouble() * 0.3, // Stagger start times
      );
    });

    _controller.forward();
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      AppColors.indigo400,
      AppColors.indigo500,
      AppColors.blue400,
      AppColors.gray60,
      AppColors.gray80,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ConfettiParticle {
  final Color color;
  final double startX;
  final double startY;
  final double endY;
  final double drift;
  final double rotationSpeed;
  final double size;
  final double delay;

  _ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startY,
    required this.endY,
    required this.drift,
    required this.rotationSpeed,
    required this.size,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate particle progress with delay
      final particleProgress = math.max(
        0.0,
        math.min(1.0, (progress - particle.delay) / (1.0 - particle.delay)),
      );

      if (particleProgress <= 0) continue;

      // Calculate position
      final y =
          particle.startY +
          (particle.endY - particle.startY) * particleProgress;
      final x =
          particle.startX +
          (particle.drift * math.sin(particleProgress * math.pi * 2));

      // Calculate opacity (fade in quickly, fade out at end)
      final opacity = particleProgress < 0.1
          ? particleProgress / 0.1
          : particleProgress > 0.8
          ? (1.0 - particleProgress) / 0.2
          : 1.0;

      // Calculate rotation
      final rotation = particleProgress * particle.rotationSpeed * math.pi;

      // Draw particle
      canvas.save();
      canvas.translate(x * size.width, y * size.height);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.fill;

      // Draw small rectangle (confetti piece)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 1.5,
          ),
          const Radius.circular(1),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
