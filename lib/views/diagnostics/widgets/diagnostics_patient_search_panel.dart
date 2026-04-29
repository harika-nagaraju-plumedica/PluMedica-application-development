import 'package:flutter/material.dart';

import '../../../models/diagnostics/diagnostics_models.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/empty_state_widget.dart';

class DiagnosticsPatientSearchPanel extends StatelessWidget {
  final TextEditingController searchController;
  final List<DiagnosticsRequest> results;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DiagnosticsRequest> onSelect;

  const DiagnosticsPatientSearchPanel({
    super.key,
    required this.searchController,
    required this.results,
    required this.onSearchChanged,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Global patient search', style: AppFonts.labelLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search by Patient ID / Name',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: onSearchChanged,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (results.isEmpty)
          const EmptyStateWidget(
            message: 'No matching patients found.',
            icon: Icons.person_search,
          )
        else
          ...results.map(
            (patient) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(patient.patientName),
                subtitle: Text('ID: ${patient.patientId}'),
                trailing: ElevatedButton(
                  onPressed: () => onSelect(patient),
                  child: const Text('Select'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
