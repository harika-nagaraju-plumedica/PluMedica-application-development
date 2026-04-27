import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

/// Home view screen
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.medical_services,
                size: 60,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Plumedica',
              style: AppFonts.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'MVVM Architecture',
              style: AppFonts.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Healthcare Made Simple',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              width: 200,
              height: 1,
              color: AppColors.gold,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                _buildColorBox(AppColors.primaryDarkBlue, 'Primary'),
                _buildColorBox(AppColors.green, 'Secondary'),
                _buildColorBox(AppColors.gold, 'Accent'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFonts.labelSmall,
        ),
      ],
    );
  }
}
