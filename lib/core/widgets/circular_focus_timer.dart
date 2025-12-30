import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Timer state enum for visual differentiation
enum TimerState {
  /// Not started, showing start button
  idle,

  /// Focus session in progress
  focus,

  /// Break period
  breakTime,

  /// Session paused
  paused,
}

/// Animated circular timer widget with smooth progress ring
///
/// Features:
/// - 60fps+ smooth animations
/// - State-based color changes
/// - Optimized CustomPainter
/// - Configurable size and stroke width
class CircularFocusTimer extends StatefulWidget {
  const CircularFocusTimer({
    super.key,
    required this.progress,
    required this.state,
    this.size = 280,
    this.strokeWidth = 8,
    this.child,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  /// Progress value from 0.0 to 1.0
  final double progress;

  /// Current timer state (affects color)
  final TimerState state;

  /// Diameter of the circular timer
  final double size;

  /// Width of the progress ring stroke
  final double strokeWidth;

  /// Optional child widget (typically timer text or icon)
  final Widget? child;

  /// Duration for smooth progress transitions
  final Duration animationDuration;

  @override
  State<CircularFocusTimer> createState() => _CircularFocusTimerState();
}

class _CircularFocusTimerState extends State<CircularFocusTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _colorAnimation;

  double _previousProgress = 0.0;
  Color _previousColor = AppColors.indigo500;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _progressAnimation = Tween<double>(
      begin: widget.progress,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _colorAnimation = ColorTween(
      begin: _getColorForState(widget.state),
      end: _getColorForState(widget.state),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(CircularFocusTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate progress changes
    if (oldWidget.progress != widget.progress) {
      _previousProgress = _progressAnimation.value;
      _progressAnimation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      _controller.forward(from: 0.0);
    }

    // Animate color changes on state change
    if (oldWidget.state != widget.state) {
      _previousColor = _colorAnimation.value ?? _previousColor;
      _colorAnimation = ColorTween(
        begin: _previousColor,
        end: _getColorForState(widget.state),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Get ring color based on timer state
  Color _getColorForState(TimerState state) {
    switch (state) {
      case TimerState.idle:
        return AppColors.indigo500;
      case TimerState.focus:
        return AppColors.indigo500;
      case TimerState.breakTime:
        return AppColors.success;
      case TimerState.paused:
        return AppColors.indigo400;
    }
  }

  /// Get background circle color based on state
  Color _getBackgroundColorForState(TimerState state) {
    switch (state) {
      case TimerState.idle:
        return AppColors.slate800;
      case TimerState.focus:
        return AppColors.slate900;
      case TimerState.breakTime:
        return AppColors.slate900;
      case TimerState.paused:
        return AppColors.slate800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _CircularTimerPainter(
            progress: _progressAnimation.value,
            progressColor:
                _colorAnimation.value ?? _getColorForState(widget.state),
            backgroundColor: _getBackgroundColorForState(widget.state),
            strokeWidth: widget.strokeWidth,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(child: child),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// CustomPainter for drawing the circular timer ring
///
/// Optimized for performance with minimal repaints.
class _CircularTimerPainter extends CustomPainter {
  _CircularTimerPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  /// Current progress (0.0 to 1.0)
  final double progress;

  /// Color of the progress arc
  final Color progressColor;

  /// Color of the background circle
  final Color backgroundColor;

  /// Width of the stroke
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle (full ring)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    if (progress > 0.0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Start from top (12 o'clock = -90 degrees)
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularTimerPainter oldDelegate) {
    // Only repaint if values actually changed
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Extension for converting duration to circular timer progress
extension DurationProgress on Duration {
  /// Calculate progress (0.0 to 1.0) based on elapsed time
  double progressFrom(Duration totalDuration) {
    if (totalDuration.inSeconds == 0) return 0.0;
    final elapsed = totalDuration.inSeconds - inSeconds;
    return (elapsed / totalDuration.inSeconds).clamp(0.0, 1.0);
  }
}
