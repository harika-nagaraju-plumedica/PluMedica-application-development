import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class JobFilterWidgetItem extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final Function(String) onChanged;

  const JobFilterWidgetItem({
    super.key,
    required this.label,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.labelMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options
              .map(
                (option) => ChoiceChip(
                  label: Text(option),
                  selected: selectedValue == option,
                  onSelected: (_) => onChanged(option),
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.primaryBlue,
                  labelStyle: AppFonts.bodySmall.copyWith(
                    color: selectedValue == option
                        ? AppColors.white
                        : AppColors.textPrimary,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
