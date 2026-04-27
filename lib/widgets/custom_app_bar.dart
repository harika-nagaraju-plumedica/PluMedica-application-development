import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

/// Custom App Bar Widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLogout;
  final List<Widget>? actions;
  final bool showLogout;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onLogout,
    this.actions,
    this.showLogout = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppFonts.heading2.copyWith(
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.primaryDarkBlue,
      elevation: 0,
      actions: [
        ...(actions ?? []),
        if (showLogout && onLogout != null)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Logout',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
