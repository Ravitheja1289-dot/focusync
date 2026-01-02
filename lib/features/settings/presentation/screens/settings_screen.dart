import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Clean, minimal settings screen
///
/// Sections: Focus Rules, Notifications, Sounds, Data Controls
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: Replace with actual state management (Riverpod provider)
  bool _autoStartBreaks = true;
  bool _notificationsEnabled = true;
  bool _breakReminders = true;
  bool _soundsEnabled = true;
  bool _tickingSounds = false;
  bool _analyticsEnabled = true;

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
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
              automaticallyImplyLeading: false,
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Focus Rules Section
                  _buildSectionHeader('Focus Rules'),
                  _buildSettingsCard([
                    _buildToggleSetting(
                      title: 'Auto-start breaks',
                      subtitle: 'Start break timer after completing a session',
                      value: _autoStartBreaks,
                      onChanged: (value) {
                        setState(() => _autoStartBreaks = value);
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
                      title: 'Default session length',
                      subtitle: '25 minutes',
                      onTap: () {
                        // TODO: Navigate to duration picker
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
                      title: 'Default break length',
                      subtitle: '5 minutes',
                      onTap: () {
                        // TODO: Navigate to duration picker
                      },
                    ),
                  ]),

                  AppSpacing.gapLg,

                  // Notifications Section
                  _buildSectionHeader('Notifications'),
                  _buildSettingsCard([
                    _buildToggleSetting(
                      title: 'Enable notifications',
                      subtitle: 'Receive focus session alerts',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                    _buildDivider(),
                    _buildToggleSetting(
                      title: 'Break reminders',
                      subtitle: 'Get notified when it\'s time for a break',
                      value: _breakReminders,
                      enabled: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _breakReminders = value);
                      },
                    ),
                  ]),

                  AppSpacing.gapLg,

                  // Sounds Section
                  _buildSectionHeader('Sounds'),
                  _buildSettingsCard([
                    _buildToggleSetting(
                      title: 'Enable sounds',
                      subtitle: 'Play audio feedback',
                      value: _soundsEnabled,
                      onChanged: (value) {
                        setState(() => _soundsEnabled = value);
                      },
                    ),
                    _buildDivider(),
                    _buildToggleSetting(
                      title: 'Ticking sounds',
                      subtitle: 'Ambient timer ticking during focus',
                      value: _tickingSounds,
                      enabled: _soundsEnabled,
                      onChanged: (value) {
                        setState(() => _tickingSounds = value);
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
                      title: 'Completion sound',
                      subtitle: 'Soft chime',
                      enabled: _soundsEnabled,
                      onTap: () {
                        // TODO: Navigate to sound picker
                      },
                    ),
                  ]),

                  AppSpacing.gapLg,

                  // Data Controls Section
                  _buildSectionHeader('Data & Privacy'),
                  _buildSettingsCard([
                    _buildToggleSetting(
                      title: 'Local analytics',
                      subtitle: 'Track your focus patterns on-device',
                      value: _analyticsEnabled,
                      onChanged: (value) {
                        setState(() => _analyticsEnabled = value);
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
                      title: 'Export data',
                      subtitle: 'Download your focus history as JSON',
                      onTap: () {
                        // TODO: Implement data export
                        _showExportDialog();
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
                      title: 'Clear all data',
                      subtitle: 'Permanently delete your focus history',
                      destructive: true,
                      onTap: () {
                        // TODO: Show confirmation dialog
                        _showClearDataDialog();
                      },
                    ),
                  ]),

                  AppSpacing.gapLg,

                  // About Section
                  _buildSectionHeader('About'),
                  _buildSettingsCard([
                    _buildNavigationSetting(
                      title: 'Version',
                      subtitle: '1.0.0',
                      onTap: () {
                        // TODO: Show version info/changelog
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
                      title: 'Privacy policy',
                      subtitle: 'How we handle your data',
                      onTap: () {
                        // TODO: Open privacy policy
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationSetting(
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
                  ]),

                  AppSpacing.gapXxl,
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
        top: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(12),
        // No border - unnecessary
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray400),
          ),
        ),
        trailing: Switch(value: value, onChanged: enabled ? onChanged : null),
      ),
    );
  }

  Widget _buildNavigationSetting({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
    bool destructive = false,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: destructive ? AppColors.red400 : AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: destructive
                  ? AppColors.red400.withOpacity(0.7)
                  : AppColors.gray400,
            ),
          ),
        ),
        trailing: null, // No chevron icon - unnecessary decoration
        onTap: enabled ? onTap : null,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(height: 1, thickness: 1, color: AppColors.slate800),
    );
  }

  void _showExportDialog() {
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
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Your focus history will be exported as a JSON file. This file contains all your session data and can be imported later.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray80),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray400,
              ),
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.slate800,
                ),
              );
            },
            child: Text(
              'Export',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.indigo400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
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
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.red400),
        ),
        content: Text(
          'This will permanently delete all your focus sessions, analytics, and settings. This action cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray80),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray400,
              ),
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.slate800,
                ),
              );
            },
            child: Text(
              'Delete',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );
  }
}
