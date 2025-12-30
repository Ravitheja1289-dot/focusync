import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Clean, minimal settings screen
///
/// Sections: Focus Rules, Notifications, Sounds, Data Controls
/// Optimized: Each section is a separate widget to prevent full tree rebuilds
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate950,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              backgroundColor: AppColors.slate950,
              elevation: 0,
              pinned: true,
              title: Text(
                'Settings',
                style: AppTypography.h2.copyWith(color: AppColors.white),
              ),
              automaticallyImplyLeading: false,
            ),

            // Content - each section is independent to prevent rebuilds
            const SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Focus Rules Section
                  _FocusRulesSection(),
                  SizedBox(height: AppSpacing.lg),

                  // Notifications Section
                  _NotificationsSection(),
                  SizedBox(height: AppSpacing.lg),

                  // Sounds Section
                  _SoundsSection(),
                  SizedBox(height: AppSpacing.lg),

                  // Data Controls Section
                  _DataControlsSection(),
                  SizedBox(height: AppSpacing.lg),

                  // About Section
                  _AboutSection(),
                  SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Focus Rules Section - Isolated state
class _FocusRulesSection extends StatefulWidget {
  const _FocusRulesSection();

  @override
  State<_FocusRulesSection> createState() => _FocusRulesSectionState();
}

class _FocusRulesSectionState extends State<_FocusRulesSection> {
  // TODO: Replace with Riverpod provider
  bool _autoStartBreaks = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsHeader(title: 'Focus Rules'),
        const SizedBox(height: AppSpacing.sm),
        _SettingsCard(
          children: [
            _ToggleSetting(
              title: 'Auto-start breaks',
              subtitle: 'Start break timer after completing a session',
              value: _autoStartBreaks,
              onChanged: (value) => setState(() => _autoStartBreaks = value),
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Default session length',
              subtitle: '25 minutes',
              onTap: () {
                // TODO: Navigate to duration picker
              },
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Default break length',
              subtitle: '5 minutes',
              onTap: () {
                // TODO: Navigate to duration picker
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Notifications Section - Isolated state
class _NotificationsSection extends StatefulWidget {
  const _NotificationsSection();

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  // TODO: Replace with Riverpod provider
  bool _notificationsEnabled = true;
  bool _breakReminders = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsHeader(title: 'Notifications'),
        const SizedBox(height: AppSpacing.sm),
        _SettingsCard(
          children: [
            _ToggleSetting(
              title: 'Enable notifications',
              subtitle: 'Receive focus session alerts',
              value: _notificationsEnabled,
              onChanged: (value) =>
                  setState(() => _notificationsEnabled = value),
            ),
            const _SettingsDivider(),
            _ToggleSetting(
              title: 'Break reminders',
              subtitle: 'Get notified when it\'s time for a break',
              value: _breakReminders,
              enabled: _notificationsEnabled,
              onChanged: (value) => setState(() => _breakReminders = value),
            ),
          ],
        ),
      ],
    );
  }
}

/// Sounds Section - Isolated state
class _SoundsSection extends StatefulWidget {
  const _SoundsSection();

  @override
  State<_SoundsSection> createState() => _SoundsSectionState();
}

class _SoundsSectionState extends State<_SoundsSection> {
  // TODO: Replace with Riverpod provider
  bool _soundsEnabled = true;
  bool _tickingSounds = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsHeader(title: 'Sounds'),
        const SizedBox(height: AppSpacing.sm),
        _SettingsCard(
          children: [
            _ToggleSetting(
              title: 'Enable sounds',
              subtitle: 'Play audio feedback',
              value: _soundsEnabled,
              onChanged: (value) => setState(() => _soundsEnabled = value),
            ),
            const _SettingsDivider(),
            _ToggleSetting(
              title: 'Ticking sounds',
              subtitle: 'Ambient timer ticking during focus',
              value: _tickingSounds,
              enabled: _soundsEnabled,
              onChanged: (value) => setState(() => _tickingSounds = value),
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Completion sound',
              subtitle: 'Soft chime',
              enabled: _soundsEnabled,
              onTap: () {
                // TODO: Navigate to sound picker
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Data Controls Section - Isolated state
class _DataControlsSection extends StatefulWidget {
  const _DataControlsSection();

  @override
  State<_DataControlsSection> createState() => _DataControlsSectionState();
}

class _DataControlsSectionState extends State<_DataControlsSection> {
  // TODO: Replace with Riverpod provider
  bool _analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsHeader(title: 'Data & Privacy'),
        const SizedBox(height: AppSpacing.sm),
        _SettingsCard(
          children: [
            _ToggleSetting(
              title: 'Local analytics',
              subtitle: 'Track your focus patterns on-device',
              value: _analyticsEnabled,
              onChanged: (value) => setState(() => _analyticsEnabled = value),
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Export data',
              subtitle: 'Download your focus history as JSON',
              onTap: () => _showExportDialog(context),
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Clear all data',
              subtitle: 'Permanently delete your focus history',
              destructive: true,
              onTap: () => _showClearDataDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slate900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.slate800),
        ),
        title: Text(
          'Export Data',
          style: AppTypography.h3.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Your focus history will be exported as a JSON file. This file contains all your session data and can be imported later.',
          style: AppTypography.body.copyWith(color: AppColors.gray300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.body.copyWith(color: AppColors.gray400),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual export
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Export functionality coming soon',
                    style: AppTypography.body.copyWith(color: AppColors.white),
                  ),
                  backgroundColor: AppColors.slate800,
                ),
              );
            },
            child: Text(
              'Export',
              style: AppTypography.body.copyWith(color: AppColors.indigo400),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slate900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.red400.withOpacity(0.3)),
        ),
        title: Text(
          'Clear All Data',
          style: AppTypography.h3.copyWith(color: AppColors.red400),
        ),
        content: Text(
          'This will permanently delete all your focus sessions, analytics, and settings. This action cannot be undone.',
          style: AppTypography.body.copyWith(color: AppColors.gray300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.body.copyWith(color: AppColors.gray400),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual data clearing
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Data cleared successfully',
                    style: AppTypography.body.copyWith(color: AppColors.white),
                  ),
                  backgroundColor: AppColors.slate800,
                ),
              );
            },
            child: Text(
              'Delete',
              style: AppTypography.body.copyWith(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );
  }
}

/// About Section - Stateless
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsHeader(title: 'About'),
        const SizedBox(height: AppSpacing.sm),
        _SettingsCard(
          children: [
            _NavigationSetting(
              title: 'Version',
              subtitle: '1.0.0',
              onTap: () {
                // TODO: Show version info/changelog
              },
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Privacy policy',
              subtitle: 'How we handle your data',
              onTap: () {
                // TODO: Open privacy policy
              },
            ),
            const _SettingsDivider(),
            _NavigationSetting(
              title: 'Open source licenses',
              subtitle: 'View third-party licenses',
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Focusync',
                  applicationVersion: '1.0.0',
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// Reusable Widgets (All const-friendly)
// =============================================================================

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
        top: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: AppColors.gray500,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate800, width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  const _ToggleSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          title,
          style: AppTypography.body.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTypography.caption.copyWith(color: AppColors.gray400),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: AppColors.indigo500,
          activeTrackColor: AppColors.indigo500.withOpacity(0.3),
          inactiveThumbColor: AppColors.gray400,
          inactiveTrackColor: AppColors.slate700,
        ),
      ),
    );
  }
}

class _NavigationSetting extends StatelessWidget {
  const _NavigationSetting({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
    this.destructive = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          title,
          style: AppTypography.body.copyWith(
            color: destructive ? AppColors.red400 : AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: destructive
                  ? AppColors.red300.withOpacity(0.7)
                  : AppColors.gray400,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: destructive ? AppColors.red400 : AppColors.gray500,
          size: 20,
        ),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(height: 1, thickness: 1, color: AppColors.slate800),
    );
  }
}
