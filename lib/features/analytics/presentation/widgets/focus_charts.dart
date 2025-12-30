import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

/// Animated bar chart for weekly focus trends
///
/// Design: Minimal, clean, smooth entry animation
class WeeklyFocusChart extends StatefulWidget {
  const WeeklyFocusChart({super.key, required this.data, this.height = 180});

  /// Daily focus minutes for the week (7 values)
  final List<int> data;
  final double height;

  @override
  State<WeeklyFocusChart> createState() => _WeeklyFocusChartState();
}

class _WeeklyFocusChartState extends State<WeeklyFocusChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Start animation on mount
    _controller.forward();
  }

  @override
  void didUpdateWidget(WeeklyFocusChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only restart animation if data actually changed
    if (oldWidget.data != widget.data && !_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(height: widget.height);
    }

    final maxValue = widget.data.reduce((a, b) => a > b ? a : b).toDouble();
    final normalizedData = maxValue > 0
        ? widget.data.map((v) => v / maxValue).toList()
        : List.filled(7, 0.0);

    // Pre-calculate stagger delays to avoid repeated calculations
    const staggerDelays = [0.0, 0.08, 0.16, 0.24, 0.32, 0.40, 0.48];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final value = normalizedData[index];
              final isToday = index == 6; // Last bar is today
              final hasData = widget.data[index] > 0;

              // Use pre-calculated stagger delay
              final staggerDelay = staggerDelays[index];
              final adjustedProgress = math.max(
                0.0,
                math.min(
                  1.0,
                  (_animation.value - staggerDelay) / (1.0 - staggerDelay),
                ),
              );

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bar with animated height and fade
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Opacity(
                            opacity: adjustedProgress,
                            child: Container(
                              width: double.infinity,
                              height: widget.height * value * adjustedProgress,
                              decoration: BoxDecoration(
                                color: hasData
                                    ? (isToday
                                          ? AppColors.indigo500
                                          : AppColors.indigo400.withOpacity(
                                              0.6,
                                            ))
                                    : AppColors.slate700.withOpacity(0.3),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                boxShadow: hasData && isToday
                                    ? [
                                        BoxShadow(
                                          color: AppColors.indigo500
                                              .withOpacity(
                                                0.3 * adjustedProgress,
                                              ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              // Value label on hover/tap (optional)
                              alignment: Alignment.center,
                              child: hasData && value > 0.2
                                  ? Opacity(
                                      opacity: adjustedProgress * 0.6,
                                      child: Text(
                                        '${widget.data[index]}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isToday
                                              ? AppColors.white
                                              : AppColors.gray200,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Day label with fade-in
                      Opacity(
                        opacity: adjustedProgress,
                        child: Text(
                          _getDayLabel(index),
                          style: TextStyle(
                            fontSize: 11,
                            color: isToday
                                ? AppColors.indigo400
                                : AppColors.gray500,
                            fontWeight: isToday
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  String _getDayLabel(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }
}

/// Animated sparkline chart for focus quality trends
///
/// Design: Smooth line with gradient fill, animated entry
class FocusQualitySparkline extends StatefulWidget {
  const FocusQualitySparkline({
    super.key,
    required this.qualityScores,
    this.height = 60,
  });

  /// Quality scores (0.0 to 1.0) for recent sessions
  final List<double> qualityScores;
  final double height;

  @override
  State<FocusQualitySparkline> createState() => _FocusQualitySparklineState();
}

class _FocusQualitySparklineState extends State<FocusQualitySparkline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    // Start animation on mount
    _controller.forward();
  }

  @override
  void didUpdateWidget(FocusQualitySparkline oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only restart animation if data actually changed
    if (oldWidget.qualityScores != widget.qualityScores &&
        !_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.qualityScores.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _SparklinePainter(
            data: widget.qualityScores,
            color: AppColors.indigo400,
            backgroundColor: AppColors.slate800,
            progress: _animation.value,
          ),
        );
      },
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final Color backgroundColor;
  final double progress;

  _SparklinePainter({
    required this.data,
    required this.color,
    required this.backgroundColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Calculate visible points based on animation progress
    final visiblePointCount = (data.length * progress).ceil();
    final visibleData = data.sublist(
      0,
      math.min(visiblePointCount, data.length),
    );

    if (visibleData.isEmpty) return;

    final paint = Paint()
      ..color = color.withOpacity(progress)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.2 * progress), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Calculate points
    final points = <Offset>[];
    final segmentWidth = size.width / (data.length - 1);

    for (int i = 0; i < visibleData.length; i++) {
      final x = i * segmentWidth;
      final y = size.height - (visibleData[i] * size.height);
      points.add(Offset(x, y));
    }

    // Draw smooth curve through points
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);

      if (points.length > 1) {
        // Smooth curve using quadratic bezier
        for (int i = 0; i < points.length - 1; i++) {
          final p0 = points[i];
          final p1 = points[i + 1];
          final controlPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            controlPoint.dx,
            controlPoint.dy,
          );
        }
        path.lineTo(points.last.dx, points.last.dy);
      }

      canvas.drawPath(path, paint);

      // Draw fill area with gradient
      fillPath.moveTo(0, size.height);
      fillPath.lineTo(points[0].dx, points[0].dy);

      if (points.length > 1) {
        for (int i = 0; i < points.length - 1; i++) {
          final p0 = points[i];
          final p1 = points[i + 1];
          final controlPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          fillPath.quadraticBezierTo(
            p0.dx,
            p0.dy,
            controlPoint.dx,
            controlPoint.dy,
          );
        }
        fillPath.lineTo(points.last.dx, points.last.dy);
      }

      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);

      // Draw dots at each point with staggered animation
      for (int i = 0; i < points.length; i++) {
        final point = points[i];

        // Stagger dot appearance
        final dotDelay = i / data.length;
        final dotProgress = math.max(
          0.0,
          (progress - dotDelay) / (1.0 - dotDelay),
        );

        if (dotProgress > 0) {
          final dotPaint = Paint()
            ..color = color.withOpacity(progress)
            ..style = PaintingStyle.fill;

          final radius = 3.5 * dotProgress;
          canvas.drawCircle(point, radius, dotPaint);

          // White center dot for contrast
          final centerPaint = Paint()
            ..color = AppColors.slate900.withOpacity(progress * 0.8)
            ..style = PaintingStyle.fill;

          canvas.drawCircle(point, radius * 0.4, centerPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
