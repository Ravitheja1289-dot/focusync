import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

/// Animated splash screen with meditation quote
///
/// Displays a calming intro with:
/// - Smooth fade-in logo animation
/// - Quote text with staggered appearance
/// - Auto-transitions to home screen after completion
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _quoteController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _quoteOpacity;

  @override
  void initState() {
    super.initState();

    // Logo animation: fade in and subtle scale
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Quote animation: delayed fade in
    _quoteController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _quoteOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _quoteController, curve: Curves.easeIn));

    // Start animations
    _logoController.forward();

    // Delay quote animation
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _quoteController.forward();
      }
    });

    // Auto-navigate after animations complete
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        // Use replace to remove splash from navigation stack and transition to home
        context.replace('/');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  /// Build logo image with fallback support
  Widget _buildLogoImage() {
    return Image.asset(
      'assets/app_logo.png',
      width: 120,
      height: 120,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback: beautiful gradient timer icon
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.indigo500, AppColors.indigo400],
            ),
          ),
          child: const Center(
            child: Icon(Icons.timer_outlined, size: 70, color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate950,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with animation
            FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.indigo500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  ),
                  child: Center(child: _buildLogoImage()),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Quote text with animation
            FadeTransition(
              opacity: _quoteOpacity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'Meditation is life.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.gray50,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Subtle loading indicator
            FadeTransition(
              opacity: _quoteOpacity,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.indigo500.withOpacity(0.6),
                  ),
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
