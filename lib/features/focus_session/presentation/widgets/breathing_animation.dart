import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

/// Breathing animation widget with calm, natural rhythm
///
/// Uses 4-4-6-2 breathing pattern:
/// - Inhale: 4 seconds
/// - Hold: 4 seconds
/// - Exhale: 6 seconds
/// - Hold: 2 seconds
/// Total cycle: 16 seconds
class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({super.key, this.size = 280});

  final double size;

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Breathing phase durations (in seconds)
  static const double _inhaleDuration = 4.0;
  static const double _holdInDuration = 4.0;
  static const double _exhaleDuration = 6.0;
  static const double _holdOutDuration = 2.0;
  static const double _totalCycleDuration =
      _inhaleDuration + _holdInDuration + _exhaleDuration + _holdOutDuration;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: (_totalCycleDuration * 1000).toInt()),
      vsync: this,
    )..repeat();

    // Scale: small (exhale) -> large (inhale)
    _scaleAnimation = TweenSequence<double>([
      // Inhale: grow from 0.7 to 1.0
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.7,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: _inhaleDuration,
      ),
      // Hold (inhale): stay at 1.0
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: _holdInDuration,
      ),
      // Exhale: shrink from 1.0 to 0.7
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.7,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: _exhaleDuration,
      ),
      // Hold (exhale): stay at 0.7
      TweenSequenceItem(
        tween: ConstantTween<double>(0.7),
        weight: _holdOutDuration,
      ),
    ]).animate(_controller);

    // Opacity: pulsate gently for breathing effect
    _opacityAnimation = TweenSequence<double>([
      // Inhale: fade in slightly
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.4,
          end: 0.7,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: _inhaleDuration,
      ),
      // Hold (inhale): steady
      TweenSequenceItem(
        tween: ConstantTween<double>(0.7),
        weight: _holdInDuration,
      ),
      // Exhale: fade out
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.7,
          end: 0.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: _exhaleDuration,
      ),
      // Hold (exhale): steady
      TweenSequenceItem(
        tween: ConstantTween<double>(0.4),
        weight: _holdOutDuration,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getCurrentPhase() {
    final progress = _controller.value;

    if (progress < _inhaleDuration / _totalCycleDuration) {
      return 'Breathe in';
    } else if (progress <
        (_inhaleDuration + _holdInDuration) / _totalCycleDuration) {
      return 'Hold';
    } else if (progress <
        (_inhaleDuration + _holdInDuration + _exhaleDuration) /
            _totalCycleDuration) {
      return 'Breathe out';
    } else {
      return 'Hold';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Breathing circle
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring (pulsating)
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.indigo400.withOpacity(
                            _opacityAnimation.value,
                          ),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  // Middle ring (subtle)
                  Transform.scale(
                    scale: _scaleAnimation.value * 0.75,
                    child: Container(
                      width: widget.size * 0.75,
                      height: widget.size * 0.75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.indigo400.withOpacity(
                            _opacityAnimation.value * 0.6,
                          ),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // Inner circle (solid, pulsating)
                  Transform.scale(
                    scale: _scaleAnimation.value * 0.5,
                    child: Container(
                      width: widget.size * 0.5,
                      height: widget.size * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.indigo500.withOpacity(
                          _opacityAnimation.value * 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.indigo500.withOpacity(
                              _opacityAnimation.value * 0.4,
                            ),
                            blurRadius: 32 * _scaleAnimation.value,
                            spreadRadius: 8 * _scaleAnimation.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.gapXl,

            // Breathing instruction text
            Text(
              _getCurrentPhase(),
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.gray50,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
              ),
            ),

            AppSpacing.gapSm,

            // Cycle progress dots
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(4, (index) {
                final threshold = (index + 1) / 4;
                final isActive =
                    _controller.value >= (index / 4) &&
                    _controller.value < threshold;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.white : AppColors.gray70,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
