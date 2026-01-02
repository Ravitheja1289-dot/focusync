import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/account_section.dart';
import '../widgets/account_list_tile.dart';
import '../widgets/account_action_button.dart';

/// Comprehensive account screen with all user profile, subscription,
/// data management, security, and support features
///
/// Philosophy: Transparency, user control, no dark patterns
/// Design: Calm, organized, respectful of user's data ownership
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _appVersion = '';
  String _buildNumber = '';
  bool _isCloudSyncEnabled = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text('Account', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        children: [
          // SECTION 1: Identity & Profile
          _buildProfileOverview(),
          const SizedBox(height: AppSpacing.lg),

          AccountSection(
            title: 'Profile',
            children: [
              AccountListTile(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                subtitle: 'Change display name and avatar',
                onTap: _handleEditProfile,
              ),
              AccountListTile(
                icon: Icons.verified_user_outlined,
                title: 'Authentication',
                subtitle: 'Email • Last login: Today',
                onTap: _showAuthStatus,
              ),
            ],
          ),

          // SECTION 2: Subscription & Plan
          AccountSection(
            title: 'Subscription',
            children: [
              AccountListTile(
                icon: Icons.workspace_premium_outlined,
                title: 'Current Plan',
                subtitle: 'Pro',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.indigo500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PRO',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.indigo400,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                onTap: _showCurrentPlan,
              ),
              AccountListTile(
                icon: Icons.rocket_launch_outlined,
                title: 'Upgrade to Pro',
                subtitle: 'Unlock advanced features',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.gray40,
                ),
                onTap: _handleUpgradeToPro,
              ),
              AccountListTile(
                icon: Icons.payment_outlined,
                title: 'Manage Subscription',
                subtitle: 'App Store / Play Store billing',
                onTap: _handleManageSubscription,
              ),
            ],
          ),

          // SECTION 3: Data Ownership & Sync
          AccountSection(
            title: 'Data & Sync',
            children: [
              AccountListTile(
                icon: Icons.cloud_outlined,
                title: 'Cloud Sync',
                subtitle: _isCloudSyncEnabled
                    ? 'Last synced: Just now'
                    : 'Sync disabled',
                trailing: Switch(
                  value: _isCloudSyncEnabled,
                  onChanged: (value) {
                    setState(() => _isCloudSyncEnabled = value);
                  },
                ),
              ),
              AccountListTile(
                icon: Icons.sync_outlined,
                title: 'Manual Sync',
                subtitle: 'Sync your data now',
                onTap: _handleManualSync,
                enabled: _isCloudSyncEnabled,
              ),
              AccountListTile(
                icon: Icons.download_outlined,
                title: 'Export Data',
                subtitle: 'Download focus history (CSV/JSON)',
                onTap: _handleExportData,
              ),
            ],
          ),

          // SECTION 4: Security & Privacy
          AccountSection(
            title: 'Security & Privacy',
            children: [
              AccountListTile(
                icon: Icons.lock_outlined,
                title: 'Change Password',
                subtitle: 'Update your password securely',
                onTap: _handleChangePassword,
              ),
              AccountListTile(
                icon: Icons.fingerprint_outlined,
                title: 'App Lock',
                subtitle: _isBiometricEnabled
                    ? 'Biometric enabled'
                    : 'Disabled',
                trailing: Switch(
                  value: _isBiometricEnabled,
                  onChanged: (value) {
                    setState(() => _isBiometricEnabled = value);
                  },
                ),
              ),
              AccountListTile(
                icon: Icons.visibility_off_outlined,
                title: 'Privacy Controls',
                subtitle: 'App switcher and recent sessions',
                onTap: _handlePrivacyControls,
              ),
              AccountListTile(
                icon: Icons.policy_outlined,
                title: 'Data Collection',
                subtitle: 'What we track and don\'t track',
                onTap: _showDataCollectionInfo,
              ),
            ],
          ),

          // SECTION 5: Account Lifecycle
          AccountSection(
            title: 'Account',
            children: [
              AccountListTile(
                icon: Icons.logout_outlined,
                title: 'Log Out',
                subtitle: 'Sign out of your account',
                onTap: _handleLogout,
                textColor: AppColors.textPrimary,
              ),
              AccountListTile(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently delete all data',
                onTap: _handleDeleteAccount,
                textColor: AppColors.red500,
              ),
            ],
          ),

          // SECTION 6: Support & Communication
          AccountSection(
            title: 'Support',
            children: [
              AccountListTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Email, GitHub, feedback',
                onTap: _handleHelpSupport,
              ),
              AccountListTile(
                icon: Icons.bug_report_outlined,
                title: 'Report a Bug',
                subtitle: 'Help us improve Focusync',
                onTap: _handleReportBug,
              ),
              AccountListTile(
                icon: Icons.lightbulb_outline,
                title: 'Feature Requests',
                subtitle: 'Suggest new features',
                onTap: _handleFeatureRequest,
              ),
            ],
          ),

          // SECTION 7: About & Meta
          AccountSection(
            title: 'About',
            children: [
              AccountListTile(
                icon: Icons.info_outline,
                title: 'App Info',
                subtitle: 'v$_appVersion (Build $_buildNumber)',
                onTap: _showAppInfo,
              ),
              AccountListTile(
                icon: Icons.history_outlined,
                title: 'Changelog',
                subtitle: 'What\'s new in Focusync',
                onTap: _showChangelog,
              ),
              AccountListTile(
                icon: Icons.gavel_outlined,
                title: 'Legal',
                subtitle: 'Privacy Policy & Terms',
                onTap: _showLegal,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ============================================================================
  // Profile Overview Card
  // ============================================================================

  Widget _buildProfileOverview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.gray10, width: 1),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.indigo500.withOpacity(0.15),
            ),
            child: Icon(
              Icons.person_outline,
              size: 32,
              color: AppColors.indigo300,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ravi Teja Reddy',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ravithejareddy1289@gmail.com',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray40,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.indigo500.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Pro Account',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.indigo400,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 1: Profile
  // ============================================================================

  void _handleEditProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: TextStyle(color: AppColors.gray40),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.gray20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.indigo500),
                  ),
                ),
                style: TextStyle(color: AppColors.white),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Email cannot be changed here',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray50,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigo500,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAuthStatus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Authentication Status',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Login Method', 'Email'),
            const SizedBox(height: 12),
            _buildInfoRow('Last Login', 'Today, 10:30 AM'),
            const SizedBox(height: 12),
            _buildInfoRow('Account Created', 'December 2025'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 2: Subscription
  // ============================================================================

  void _showCurrentPlan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Current Plan',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.indigo500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.indigo500.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: 48,
                    color: AppColors.indigo400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Free Plan',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlimited focus sessions\nBasic analytics\nLocal data storage',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleUpgradeToPro();
            },
            child: Text(
              'Upgrade to Pro',
              style: TextStyle(color: AppColors.indigo400),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.gray50)),
          ),
        ],
      ),
    );
  }

  void _handleUpgradeToPro() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Upgrade to Pro',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Free',
              style: AppTextStyles.titleSmall.copyWith(color: AppColors.gray50),
            ),
            const SizedBox(height: 8),
            Text(
              '✓ Unlimited focus sessions\n✓ Basic analytics\n✓ Local storage',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
            ),
            const SizedBox(height: 16),
            Text(
              'Pro',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.indigo400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '✓ Everything in Free\n✓ Cloud sync across devices\n✓ Advanced analytics\n✓ Custom session durations\n✓ Export data (CSV/JSON)\n✓ Priority support',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
            ),
            const SizedBox(height: 16),
            Text(
              'No fake urgency. No dark patterns.\nUpgrade when it makes sense for you.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray50,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Not Now', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement IAP
            },
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.indigo400),
            ),
          ),
        ],
      ),
    );
  }

  void _handleManageSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Manage Subscription',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Subscriptions are managed through your device\'s app store:\n\n'
          '• iOS: Settings → [Your Name] → Subscriptions\n'
          '• Android: Play Store → Account → Payments & subscriptions\n\n'
          'We do not handle billing directly to keep your payment information secure.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 3: Data & Sync
  // ============================================================================

  void _handleManualSync() {
    if (!_isCloudSyncEnabled) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Syncing your data...'),
        backgroundColor: AppColors.indigo500,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO: Implement actual sync logic
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Sync complete'),
            backgroundColor: AppColors.green500,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _handleExportData() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Data',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Download your complete focus history and statistics',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
            ),
            const SizedBox(height: AppSpacing.lg),
            AccountActionButton(
              icon: Icons.table_chart_outlined,
              label: 'Export as CSV',
              subtitle: 'Spreadsheet format',
              onTap: () {
                Navigator.pop(context);
                _showExportSuccess('CSV');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AccountActionButton(
              icon: Icons.code_outlined,
              label: 'Export as JSON',
              subtitle: 'Developer format',
              onTap: () {
                Navigator.pop(context);
                _showExportSuccess('JSON');
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _showExportSuccess(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ $format export ready. Saved to Downloads.'),
        backgroundColor: AppColors.green500,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 4: Security & Privacy
  // ============================================================================

  void _handleChangePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Change Password',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Text(
          'For security, password changes are handled through a secure flow.\n\n'
          'We\'ll send a password reset link to your email address.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✓ Password reset email sent'),
                  backgroundColor: AppColors.green500,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Send Reset Link',
              style: TextStyle(color: AppColors.indigo400),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePrivacyControls() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Controls',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Control what\'s visible in public or semi-public contexts',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
            ),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile(
              value: false,
              onChanged: (value) {},
              title: Text(
                'Hide in App Switcher',
                style: TextStyle(color: AppColors.white),
              ),
              subtitle: Text(
                'Blur app preview in task manager',
                style: TextStyle(color: AppColors.gray50, fontSize: 13),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              value: false,
              onChanged: (value) {},
              title: Text(
                'Obscure Recent Sessions',
                style: TextStyle(color: AppColors.white),
              ),
              subtitle: Text(
                'Hide session details on lock screen',
                style: TextStyle(color: AppColors.gray50, fontSize: 13),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _showDataCollectionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Data Collection',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What We Track',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.green400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '✓ Your focus sessions (locally on your device)\n'
                '✓ App crashes (to fix bugs)\n'
                '✓ Performance metrics (to improve speed)',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'What We DON\'T Track',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.red400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '✗ Your usage patterns\n'
                '✗ Third-party analytics\n'
                '✗ Advertising IDs\n'
                '✗ Location data\n'
                '✗ Contacts or personal files',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We believe in privacy by design, not privacy by policy.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.indigo400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 5: Account Lifecycle
  // ============================================================================

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Log Out',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Are you sure you want to log out?\n\n'
          'Your local data will remain on this device.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppColors.green500,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: AppColors.indigo400),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.red500,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete Account',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.red500,
              ),
            ),
          ],
        ),
        content: Text(
          'This action is IRREVERSIBLE.\n\n'
          'What will be deleted:\n'
          '• Your account and profile\n'
          '• All focus session history\n'
          '• Analytics and statistics\n'
          '• Cloud backups (if any)\n\n'
          'What won\'t be deleted:\n'
          '• Local data on this device (until app is uninstalled)\n\n'
          'Are you absolutely sure?',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteAccount();
            },
            child: Text('Continue', style: TextStyle(color: AppColors.red500)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Final Confirmation',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.red500),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Type "DELETE" to confirm permanent account deletion',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray40),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type DELETE',
                hintStyle: TextStyle(color: AppColors.gray50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.red500),
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deletion initiated'),
                  backgroundColor: AppColors.red500,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Delete Forever',
              style: TextStyle(color: AppColors.red500),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 6: Support
  // ============================================================================

  void _handleHelpSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.lg),
            AccountActionButton(
              icon: Icons.email_outlined,
              label: 'Email Support',
              subtitle: 'support@focusync.app',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            AccountActionButton(
              icon: Icons.code_outlined,
              label: 'GitHub Issues',
              subtitle: 'github.com/focusync/app',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            AccountActionButton(
              icon: Icons.feedback_outlined,
              label: 'Feedback Form',
              subtitle: 'Share your thoughts',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _handleReportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Report a Bug',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auto-attached Information:',
              style: AppTextStyles.titleSmall.copyWith(color: AppColors.gray40),
            ),
            const SizedBox(height: 8),
            Text(
              '• App version: $_appVersion\n'
              '• Build: $_buildNumber\n'
              '• Device: Android/iOS\n'
              '• OS version: 14.0',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray50),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe the bug...',
                hintStyle: TextStyle(color: AppColors.gray50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.indigo500),
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✓ Bug report submitted. Thank you!'),
                  backgroundColor: AppColors.green500,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Submit', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  void _handleFeatureRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Feature Request',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your feature idea...',
                hintStyle: TextStyle(color: AppColors.gray50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.indigo500),
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray50)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✓ Feature request received. Thanks!'),
                  backgroundColor: AppColors.green500,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Submit', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Action Handlers - Section 7: About
  // ============================================================================

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'App Info',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Version', _appVersion),
            const SizedBox(height: 12),
            _buildInfoRow('Build', _buildNumber),
            const SizedBox(height: 12),
            _buildInfoRow('Environment', 'Debug'),
            const SizedBox(height: 12),
            _buildInfoRow('Flutter', '3.x.x'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  void _showChangelog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Changelog',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version $_appVersion',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.indigo400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Added comprehensive account section\n'
                '• Improved timer visualization\n'
                '• Enhanced privacy controls\n'
                '• Bug fixes and performance improvements',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Previous Versions',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.gray50,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Initial release\n'
                '• Core focus session features\n'
                '• Basic analytics',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray50,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.indigo400)),
          ),
        ],
      ),
    );
  }

  void _showLegal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legal',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.lg),
            AccountActionButton(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            AccountActionButton(
              icon: Icons.description_outlined,
              label: 'Terms of Service',
              subtitle: 'Usage terms and conditions',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            AccountActionButton(
              icon: Icons.code_outlined,
              label: 'Open Source Licenses',
              subtitle: 'Third-party software',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Helper Widgets
  // ============================================================================

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray50),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}
