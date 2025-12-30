import 'package:flutter/material.dart';
import '../../core/widgets/circular_focus_timer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../focus_session/presentation/widgets/session_setup_bottom_sheet.dart';
import '../focus_session/presentation/models/session_config.dart';

/// Demo screen showcasing the CircularFocusTimer widget
class TimerDemoScreen extends StatefulWidget {
  const TimerDemoScreen({super.key});

  @override
  State<TimerDemoScreen> createState() => _TimerDemoScreenState();
}

class _TimerDemoScreenState extends State<TimerDemoScreen> {
  double _progress = 0.0;
  TimerState _state = TimerState.idle;
  bool _isAnimating = false;

  void _startAnimation() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _state = TimerState.focus;
      _progress = 0.0;
    });

    // Simulate timer progress
    _animateProgress();
  }

  void _animateProgress() {
    if (!_isAnimating) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted || !_isAnimating) return;

      setState(() {
        _progress += 0.01;

        if (_progress >= 1.0) {
          _progress = 1.0;
          _isAnimating = false;
          _state = TimerState.idle;
        }
      });

      if (_isAnimating) {
        _animateProgress();
      }
    });
  }

  void _pauseAnimation() {
    setState(() {
      _isAnimating = false;
      _state = TimerState.paused;
    });
  }

  void _resumeAnimation() {
    setState(() {
      _isAnimating = true;
      _state = TimerState.focus;
    });
    _animateProgress();
  }

  void _reset() {
    setState(() {
      _isAnimating = false;
      _progress = 0.0;
      _state = TimerState.idle;
    });
  }

  void _setBreakState() {
    setState(() {
      _state = TimerState.breakTime;
    });
  }

  void _showSetupSheet() {
    SessionSetupBottomSheet.show(
      context,
      onStart: (config) {
        // TODO: Start session with config
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Starting ${config.focusDuration.inMinutes} min ${config.focusMode.label} session',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        _startAnimation();
      },
    );
  }

  String _getTimeText() {
    final totalSeconds = (1500 * (1 - _progress)).round(); // 25 min = 1500s
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Circular Timer Demo')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Timer Display
                CircularFocusTimer(
                  progress: _progress,
                  state: _state,
                  size: 280,
                  strokeWidth: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _state == TimerState.idle ? 'START' : _getTimeText(),
                        style: AppTextStyles.displayLarge,
                      ),
                      if (_state != TimerState.idle) ...[
                        AppSpacing.gapSm,
                        Text('25 min', style: AppTextStyles.bodySmall),
                      ],
                    ],
                  ),
                ),

                AppSpacing.gapXl,

                // State Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.slate800,
                    borderRadius: AppSpacing.chipRadius,
                  ),
                  child: Text(
                    'State: ${_state.name.toUpperCase()} | Progress: ${(_progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.labelMedium,
                  ),
                ),

                AppSpacing.gapXl,

                // Control Buttons
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    // Setup Bottom Sheet Button
                    ElevatedButton.icon(
                      onPressed: _showSetupSheet,
                      icon: const Icon(Icons.settings),
                      label: const Text('Setup Session'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.indigo600,
                      ),
                    ),

                    if (_state == TimerState.idle)
                      ElevatedButton.icon(
                        onPressed: _startAnimation,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                      ),

                    if (_state == TimerState.focus)
                      ElevatedButton.icon(
                        onPressed: _pauseAnimation,
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
                      ),

                    if (_state == TimerState.paused)
                      ElevatedButton.icon(
                        onPressed: _resumeAnimation,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Resume'),
                      ),

                    if (_state != TimerState.idle)
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.stop),
                        label: const Text('Reset'),
                      ),

                    OutlinedButton.icon(
                      onPressed: _setBreakState,
                      icon: const Icon(Icons.coffee),
                      label: const Text('Break Mode'),
                    ),
                  ],
                ),

                AppSpacing.gapXl,

                // Quick Progress Buttons
                const Text(
                  'Quick Progress Test:',
                  style: AppTextStyles.labelMedium,
                ),
                AppSpacing.gapSm,
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    for (final progress in [0.0, 0.25, 0.5, 0.75, 1.0])
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _progress = progress;
                            if (progress > 0 && _state == TimerState.idle) {
                              _state = TimerState.focus;
                            }
                          });
                        },
                        child: Text('${(progress * 100).toInt()}%'),
                      ),
                  ],
                ),

                AppSpacing.gapXl,

                // Performance Info
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.slate900,
                    borderRadius: AppSpacing.cardRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance Optimizations:',
                        style: AppTextStyles.titleSmall,
                      ),
                      AppSpacing.gapSm,
                      _buildInfoRow('✓ Smooth 60fps animations'),
                      _buildInfoRow('✓ Optimized CustomPainter repaints'),
                      _buildInfoRow('✓ State-based color transitions'),
                      _buildInfoRow('✓ Minimal widget rebuilds'),
                      _buildInfoRow('✓ Configurable size & stroke width'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(text, style: AppTextStyles.bodySmall),
    );
  }
}
