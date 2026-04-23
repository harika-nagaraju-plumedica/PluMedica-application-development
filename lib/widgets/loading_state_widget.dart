import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Loading State Widget
class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const LoadingStateWidget({
    Key? key,
    this.message,
    this.fullScreen = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(AppColors.primaryDarkBlue),
          strokeWidth: 3,
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (fullScreen) {
      return Center(child: content);
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Center(child: content),
    );
  }
}
