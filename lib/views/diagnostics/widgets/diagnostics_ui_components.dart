import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class DiagnosticsSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DiagnosticsSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppFonts.heading3.copyWith(
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiagnosticsStatusBadge extends StatelessWidget {
  final String status;

  const DiagnosticsStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (status == 'Requested') {
      color = AppColors.warning;
    } else if (status == 'Sample Collected') {
      color = AppColors.primaryBlue;
    } else if (status == 'In Progress') {
      color = AppColors.lightBlue;
    } else if (status == 'Completed') {
      color = AppColors.green;
    } else if (status == 'Rejected') {
      color = AppColors.error;
    } else {
      color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppFonts.labelSmall.copyWith(
          color: color,
          fontWeight: AppFonts.semiBold,
        ),
      ),
    );
  }
}

class DiagnosticsLifecycleIndicator extends StatelessWidget {
  final String status;

  const DiagnosticsLifecycleIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    const stages = [
      'Requested',
      'Sample Collected',
      'In Progress',
      'Completed',
    ];
    final currentIndex = stages.indexOf(status).clamp(0, stages.length - 1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Test Lifecycle', style: AppFonts.labelLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(stages.length, (index) {
                final active = index <= currentIndex;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryBlue.withValues(alpha: 0.16)
                        : AppColors.veryLightGrey,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 14,
                        color: active
                            ? AppColors.primaryBlue
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(stages[index], style: AppFonts.labelSmall),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticsRoleTag extends StatelessWidget {
  final String label;
  final Color color;

  const DiagnosticsRoleTag({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppFonts.labelSmall.copyWith(color: color)),
    );
  }
}

class DiagnosticsModuleLinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const DiagnosticsModuleLinkButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
