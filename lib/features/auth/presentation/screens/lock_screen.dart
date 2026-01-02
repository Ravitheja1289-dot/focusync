import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/router/app_routes.dart';

/// PIN lock screen for app security
///
/// Philosophy: Calm security. No intimidation, just protection.
/// PIN: 2006 (hardcoded for now)
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  final String _correctPin = '2006';
  String _enteredPin = '';
  bool _isError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Shake animation for incorrect PIN
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += number;
        _isError = false;
      });

      // Auto-verify when 4 digits entered
      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  void _verifyPin() {
    if (_enteredPin == _correctPin) {
      // Correct PIN - navigate to home
      context.go(AppRoutes.home);
    } else {
      // Incorrect PIN - show error and shake
      setState(() {
        _isError = true;
      });

      _shakeController.forward(from: 0).then((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _enteredPin = '';
              _isError = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Lock icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.indigo500.withOpacity(0.15),
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: AppColors.indigo400,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'Focusync',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              Text(
                'Enter PIN to unlock',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray50,
                ),
              ),

              const SizedBox(height: AppSpacing.xl * 2),

              // PIN dots display
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _isError
                        ? Offset(
                            _shakeAnimation.value *
                                ((_shakeController.value * 4).floor().isEven
                                    ? 1
                                    : -1),
                            0,
                          )
                        : Offset.zero,
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final isFilled = index < _enteredPin.length;
                    return Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isError
                            ? AppColors.red500.withOpacity(isFilled ? 1.0 : 0.2)
                            : isFilled
                            ? AppColors.indigo400
                            : AppColors.gray20,
                        border: _isError
                            ? Border.all(color: AppColors.red500, width: 2)
                            : null,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Error message
              SizedBox(
                height: 24,
                child: _isError
                    ? Text(
                        'Incorrect PIN',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.red500,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const Spacer(flex: 1),

              // Number pad
              _buildNumberPad(),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Row 4: Empty, 0, Backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 72, height: 72), // Empty space for symmetry
            _buildNumberButton('0'),
            _buildBackspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNumberPressed(number),
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gray20, width: 1),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onBackspacePressed,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gray10.withOpacity(0.3),
          ),
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.gray50,
            size: 24,
          ),
        ),
      ),
    );
  }
}
