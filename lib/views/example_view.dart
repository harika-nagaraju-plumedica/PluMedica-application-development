import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

/// Example view screen
class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Center(
        child: Text(
          'Example View',
          style: AppFonts.bodyLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
