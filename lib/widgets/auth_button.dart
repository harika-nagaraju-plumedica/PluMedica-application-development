import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';

/// Authentication button widget
class AuthButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;
  final Color? backgroundColor;

  const AuthButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 56,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.isEnabled || widget.isLoading;
    final buttonColor = widget.backgroundColor ??
        (widget.isPrimary ? AppColors.purple : AppColors.white);

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : widget.onPressed,
          onHighlightChanged: (isPressed) {
            if (widget.isEnabled && !widget.isLoading) {
              setState(() {
                _isPressed = isPressed;
              });
            }
          },
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusLarge,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDisabled
                  ? AppColors.lightGrey
                  : (_isPressed && widget.isPrimary
                      ? AppColors.darkPurple
                      : buttonColor),
              border: widget.isPrimary
                  ? null
                  : Border.all(
                      color: isDisabled
                          ? AppColors.lightGrey
                          : AppColors.purple,
                      width: 2,
                    ),
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusLarge,
              ),
              boxShadow: _isPressed && widget.isPrimary && widget.isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isPrimary
                              ? AppColors.white
                              : AppColors.purple,
                        ),
                      ),
                    )
                  : Text(
                      widget.text,
                      style: AppFonts.labelLarge.copyWith(
                        color: isDisabled
                            ? AppColors.mediumGrey
                            : (widget.isPrimary
                                ? AppColors.white
                                : AppColors.purple),
                        fontWeight: AppFonts.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

