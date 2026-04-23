import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';

/// Custom dropdown widget that matches the app design system
class AppDropdown extends StatelessWidget {
  final String label;
  final String? hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Widget? prefixIcon;
  final bool isRequired;
  final String? errorText;
  final bool enabled;

  const AppDropdown({
    Key? key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.isRequired = false,
    this.errorText,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppFonts.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: AppFonts.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.lightGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            color: enabled ? AppColors.white : AppColors.veryLightGrey,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint ?? 'Select an option',
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: AppFonts.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: enabled ? onChanged : null,
              icon: Icon(
                Icons.arrow_drop_down,
                color: enabled
                    ? AppColors.primaryBlue
                    : AppColors.textSecondary,
              ),
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppFonts.caption.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
