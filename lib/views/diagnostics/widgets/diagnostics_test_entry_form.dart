import 'package:flutter/material.dart';

import '../../../models/diagnostics/diagnostics_models.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import 'diagnostics_ui_components.dart';

class DiagnosticsTestEntryForm extends StatelessWidget {
  final DiagnosticsRequest patient;
  final String status;
  final String selectedTestPerformed;
  final bool sampleCollected;
  final DateTime? collectionDate;
  final TextEditingController notesController;
  final Widget uploadTile;
  final ValueChanged<String> onTestPerformedChanged;
  final ValueChanged<bool> onSampleCollectedChanged;
  final Future<void> Function() onPickCollectionDate;
  final VoidCallback onSave;
  final VoidCallback onMarkCompleted;

  const DiagnosticsTestEntryForm({
    super.key,
    required this.patient,
    required this.status,
    required this.selectedTestPerformed,
    required this.sampleCollected,
    required this.collectionDate,
    required this.notesController,
    required this.uploadTile,
    required this.onTestPerformedChanged,
    required this.onSampleCollectedChanged,
    required this.onPickCollectionDate,
    required this.onSave,
    required this.onMarkCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DiagnosticsLifecycleIndicator(status: status),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient: ${patient.patientName} (${patient.patientId})',
                  style: AppFonts.labelLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Test Requested: ${patient.testRequested}',
                  style: AppFonts.bodyMedium,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedTestPerformed,
                  items: const [
                    DropdownMenuItem(value: 'CBC', child: Text('CBC')),
                    DropdownMenuItem(
                      value: 'Lipid Profile',
                      child: Text('Lipid Profile'),
                    ),
                    DropdownMenuItem(
                      value: 'Thyroid Panel',
                      child: Text('Thyroid Panel'),
                    ),
                    DropdownMenuItem(value: 'LFT', child: Text('LFT')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onTestPerformedChanged(value);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Test Performed (dropdown)',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: sampleCollected,
                  onChanged: onSampleCollectedChanged,
                  title: const Text('Sample Collected (Yes/No)'),
                ),
                const SizedBox(height: 6),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    collectionDate == null
                        ? 'Collection Date'
                        : 'Collection Date: ${collectionDate!.day}/${collectionDate!.month}/${collectionDate!.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: onPickCollectionDate,
                ),
                const SizedBox(height: 10),
                uploadTile,
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: onSave,
                      child: const Text('Save Progress'),
                    ),
                    ElevatedButton(
                      onPressed: onMarkCompleted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                      ),
                      child: const Text('Mark as Completed'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
