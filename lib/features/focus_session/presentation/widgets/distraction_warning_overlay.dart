import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

/// Overlay that appears when user returns from backgrounding the app during a focus session
/// Shows a gentle reminder about staying focused without being too punitive
class DistractionWarningOverlay extends StatefulWidget {
  const DistractionWarningOverlay({
    super.key,
    required this.distractionCount,
    required this.onDismiss,
  });

  final int distractionCount;
  final VoidCallback onDismiss;

  @override
  State<DistractionWarningOverlay> createState() =>
      _DistractionWarningOverlayState();
}

class _DistractionWarningOverlayState extends State<DistractionWarningOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  String _getWarningMessage() {
    if (widget.distractionCount == 1) {
      return 'Stay focused. You\'ve got this.';
    } else if (widget.distractionCount == 2) {
      return 'Second distraction detected.';
    } else if (widget.distractionCount <= 5) {
      return 'Multiple distractions detected.';
    } else {
      return 'Struggling to focus? Take a break.';
    }
  }

  Color _getWarningColor() {
    if (widget.distractionCount <= 2) {
      return AppColors.gray60;
    } else if (widget.distractionCount <= 5) {
      return AppColors.gray70;
    } else {
      return AppColors.gray80;
    }
  }

  IconData _getWarningIcon() {
    if (widget.distractionCount <= 2) {
      return Icons.info_outline;
    } else if (widget.distractionCount <= 5) {
      return Icons.warning_amber_outlined;
    } else {
      return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.slate800,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getWarningColor().withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getWarningColor().withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(_getWarningIcon(), color: _getWarningColor(), size: 24),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getWarningMessage(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.gapXs,
                      Text(
                        '${widget.distractionCount} distraction${widget.distractionCount > 1 ? 's' : ''} this session',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapMd,
                InkWell(
                  onTap: _dismiss,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    child: Icon(
                      Icons.close,
                      color: AppColors.gray400,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
