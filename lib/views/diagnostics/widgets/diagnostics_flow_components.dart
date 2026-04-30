import 'package:flutter/material.dart';

import '../../../models/diagnostics/diagnostics_models.dart';
import '../../../utils/fonts.dart';

class DiagnosticsSearchBar extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DiagnosticsSearchBar({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppFonts.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticsDateFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const DiagnosticsDateFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const items = <String>['Day', 'Month', 'Year'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date Filter', style: AppFonts.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: items
                  .map(
                    (item) => ChoiceChip(
                      label: Text(item),
                      selected: selected == item,
                      onSelected: (_) => onSelected(item),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticsDateRangeCard extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final Future<void> Function() onPickFrom;
  final Future<void> Function() onPickTo;

  const DiagnosticsDateRangeCard({
    super.key,
    required this.fromController,
    required this.toController,
    required this.onPickFrom,
    required this.onPickTo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Global Search with date range', style: AppFonts.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fromController,
                    readOnly: true,
                    onTap: onPickFrom,
                    decoration: const InputDecoration(
                      labelText: 'From Date (D/M/Y)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: toController,
                    readOnly: true,
                    onTap: onPickTo,
                    decoration: const InputDecoration(
                      labelText: 'To Date (D/M/Y)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticsPatientCard extends StatelessWidget {
  final DiagnosticsRequest patient;
  final String? trailingLabel;
  final VoidCallback onTap;

  const DiagnosticsPatientCard({
    super.key,
    required this.patient,
    required this.onTap,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(patient.patientName),
        subtitle: Text('ID No: ${patient.patientId}'),
        trailing: trailingLabel == null
            ? const Icon(Icons.chevron_right)
            : Text(trailingLabel!, style: AppFonts.labelSmall),
        onTap: onTap,
      ),
    );
  }
}
