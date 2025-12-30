import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_motion.dart';
import '../models/session_config.dart';

/// Bottom sheet for configuring focus session
///
/// Optimized for speed: 3 taps maximum to start
class SessionSetupBottomSheet extends StatefulWidget {
  const SessionSetupBottomSheet({
    super.key,
    this.initialConfig = SessionConfig.defaultConfig,
    required this.onStart,
  });

  final SessionConfig initialConfig;
  final void Function(SessionConfig config) onStart;

  @override
  State<SessionSetupBottomSheet> createState() =>
      _SessionSetupBottomSheetState();

  /// Show the bottom sheet
  static Future<void> show(
    BuildContext context, {
    SessionConfig? initialConfig,
    required void Function(SessionConfig config) onStart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SessionSetupBottomSheet(
        initialConfig: initialConfig ?? SessionConfig.defaultConfig,
        onStart: onStart,
      ),
    );
  }
}

class _SessionSetupBottomSheetState extends State<SessionSetupBottomSheet> {
  late SessionConfig _config;
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  void _updateDuration(Duration duration) {
    setState(() {
      _config = _config.copyWith(focusDuration: duration);
    });
  }

  void _updateBreakDuration(Duration duration) {
    setState(() {
      _config = _config.copyWith(breakDuration: duration);
    });
  }

  void _updateFocusMode(FocusMode mode) {
    setState(() {
      _config = _config.copyWith(focusMode: mode);
    });
  }

  void _toggleBreak(bool value) {
    setState(() {
      _config = _config.copyWith(enableBreak: value);
    });
  }

  void _startSession() {
    Navigator.of(context).pop();
    widget.onStart(_config);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Text('Focus Session', style: AppTextStyles.titleLarge),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                      ),
                    ],
                  ),

                  AppSpacing.gapLg,

                  // Focus Duration (Primary)
                  Text(
                    'Duration',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.gray200,
                    ),
                  ),
                  AppSpacing.gapSm,
                  _DurationSelector(
                    selectedDuration: _config.focusDuration,
                    onChanged: _updateDuration,
                  ),

                  AppSpacing.gapLg,

                  // Focus Mode
                  Text(
                    'Focus Mode',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.gray200,
                    ),
                  ),
                  AppSpacing.gapSm,
                  _FocusModeSelector(
                    selectedMode: _config.focusMode,
                    onChanged: _updateFocusMode,
                  ),

                  // Advanced Options Toggle
                  AppSpacing.gapMd,
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAdvanced = !_showAdvanced;
                      });
                    },
                    icon: Icon(
                      _showAdvanced ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    label: Text(
                      _showAdvanced ? 'Less options' : 'More options',
                      style: AppTextStyles.labelMedium,
                    ),
                  ),

                  // Advanced Options (Collapsed by default)
                  AnimatedCrossFade(
                    duration: AppMotion.normal,
                    crossFadeState: _showAdvanced
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.gapMd,

                        // Break Toggle
                        _OptionTile(
                          title: 'Include break after session',
                          value: _config.enableBreak,
                          onChanged: _toggleBreak,
                        ),

                        if (_config.enableBreak) ...[
                          AppSpacing.gapMd,
                          Text(
                            'Break Duration',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.gray400,
                            ),
                          ),
                          AppSpacing.gapSm,
                          _BreakDurationSelector(
                            selectedDuration: _config.breakDuration,
                            onChanged: _updateBreakDuration,
                          ),
                        ],

                        AppSpacing.gapMd,

                        // Block Apps (Coming Soon)
                        _ComingSoonTile(
                          icon: Icons.block,
                          title: 'Block apps & websites',
                          subtitle: 'Coming soon',
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.gapXl,

                  // Start Button (Primary CTA)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startSession,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Text(
                          'Start ${_config.focusDuration.inMinutes} min session',
                          style: AppTextStyles.labelLarge,
                        ),
                      ),
                    ),
                  ),

                  AppSpacing.gapSm,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Duration Selector (Chips)
// =============================================================================

class _DurationSelector extends StatelessWidget {
  const _DurationSelector({
    required this.selectedDuration,
    required this.onChanged,
  });

  final Duration selectedDuration;
  final void Function(Duration) onChanged;

  @override
  Widget build(BuildContext context) {
    final durations = [
      const Duration(minutes: 15),
      const Duration(minutes: 25),
      const Duration(minutes: 45),
      const Duration(minutes: 60),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: durations.map((duration) {
        final isSelected = duration == selectedDuration;
        return ChoiceChip(
          label: Text('${duration.inMinutes} min'),
          selected: isSelected,
          onSelected: (_) => onChanged(duration),
          backgroundColor: AppColors.slate800,
          selectedColor: AppColors.indigo500,
          labelStyle: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.gray200,
          ),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        );
      }).toList(),
    );
  }
}

// =============================================================================
// Focus Mode Selector (Cards)
// =============================================================================

class _FocusModeSelector extends StatelessWidget {
  const _FocusModeSelector({
    required this.selectedMode,
    required this.onChanged,
  });

  final FocusMode selectedMode;
  final void Function(FocusMode) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: FocusMode.values.map((mode) {
        final isSelected = mode == selectedMode;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _FocusModeCard(
              mode: mode,
              isSelected: isSelected,
              onTap: () => onChanged(mode),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FocusModeCard extends StatelessWidget {
  const _FocusModeCard({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final FocusMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.calm,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.indigo900 : AppColors.slate800,
          borderRadius: AppSpacing.buttonRadius,
          border: Border.all(
            color: isSelected ? AppColors.indigo500 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              mode.icon,
              size: 24,
              color: isSelected ? AppColors.indigo400 : AppColors.gray400,
            ),
            AppSpacing.gapXs,
            Text(
              mode.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.gray50 : AppColors.gray200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Break Duration Selector
// =============================================================================

class _BreakDurationSelector extends StatelessWidget {
  const _BreakDurationSelector({
    required this.selectedDuration,
    required this.onChanged,
  });

  final Duration selectedDuration;
  final void Function(Duration) onChanged;

  @override
  Widget build(BuildContext context) {
    final durations = [
      const Duration(minutes: 5),
      const Duration(minutes: 10),
      const Duration(minutes: 15),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      children: durations.map((duration) {
        final isSelected = duration == selectedDuration;
        return ChoiceChip(
          label: Text('${duration.inMinutes} min'),
          selected: isSelected,
          onSelected: (_) => onChanged(duration),
          backgroundColor: AppColors.slate800,
          selectedColor: AppColors.indigo900,
          labelStyle: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? AppColors.gray50 : AppColors.gray400,
          ),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}

// =============================================================================
// Option Tile (Switch)
// =============================================================================

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: AppSpacing.buttonRadius,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// =============================================================================
// Coming Soon Tile
// =============================================================================

class _ComingSoonTile extends StatelessWidget {
  const _ComingSoonTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.5),
        borderRadius: AppSpacing.buttonRadius,
        border: Border.all(color: AppColors.slate700, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.gray600),
          AppSpacing.gapMdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_outline, size: 16, color: AppColors.gray600),
        ],
      ),
    );
  }
}
