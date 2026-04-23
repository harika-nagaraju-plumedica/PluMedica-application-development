import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';

/// SOS emergency action button widget
class SosActionButtonWidget extends StatefulWidget {
  final VoidCallback onSosActivated;
  final VoidCallback onCancel;
  final bool isActive;

  const SosActionButtonWidget({
    Key? key,
    required this.onSosActivated,
    required this.onCancel,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<SosActionButtonWidget> createState() => _SosActionButtonWidgetState();
}

class _SosActionButtonWidgetState extends State<SosActionButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.2),
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onCancel,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.error,
                    AppColors.error.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emergency,
                    color: AppColors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ACTIVE',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: widget.onSosActivated,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.error,
              AppColors.error.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emergency,
              color: AppColors.white,
              size: 40,
            ),
            const SizedBox(height: 4),
            Text(
              'S.O.S',
              style: AppFonts.labelLarge.copyWith(
                color: AppColors.white,
                fontWeight: AppFonts.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
