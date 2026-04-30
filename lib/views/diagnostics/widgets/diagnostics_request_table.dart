import 'package:flutter/material.dart';

import '../../../models/diagnostics/diagnostics_models.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/empty_state_widget.dart';
import 'diagnostics_ui_components.dart';

class DiagnosticsRequestTable extends StatelessWidget {
  final List<DiagnosticsRequest> rows;
  final ValueChanged<DiagnosticsRequest> onView;
  final void Function(DiagnosticsRequest row, String status) onStatusChange;

  const DiagnosticsRequestTable({
    super.key,
    required this.rows,
    required this.onView,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final useCompactActions = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  'Incoming Requests from Doctors / Hospitals / Pharmacies / Patients',
                  style: AppFonts.labelLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (rows.isEmpty)
          const EmptyStateWidget(
            message: 'No test requests match the current search.',
            icon: Icons.search_off,
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(
                AppColors.primaryBlue.withValues(alpha: 0.08),
              ),
              columns: const [
                DataColumn(label: Text('Patient Name')),
                DataColumn(label: Text('Patient ID')),
                DataColumn(label: Text('Source')),
                DataColumn(label: Text('Requested By')),
                DataColumn(label: Text('Test Requested')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: rows
                  .map(
                    (row) => DataRow(
                      cells: [
                        DataCell(Text(row.patientName)),
                        DataCell(Text(row.patientId)),
                        DataCell(Text(row.source)),
                        DataCell(Text(row.doctorName)),
                        DataCell(Text(row.testRequested)),
                        DataCell(DiagnosticsStatusBadge(status: row.status)),
                        DataCell(_buildActionsCell(row, useCompactActions)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionsCell(DiagnosticsRequest row, bool useCompactActions) {
    if (useCompactActions) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Actions',
        onSelected: (value) {
          switch (value) {
            case 'view':
              onView(row);
              break;
            case 'accept':
              onStatusChange(row, 'Sample Collected');
              break;
            case 'reject':
              onStatusChange(row, 'Rejected');
              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem<String>(value: 'view', child: Text('View')),
          PopupMenuItem<String>(value: 'accept', child: Text('Accept')),
          PopupMenuItem<String>(value: 'reject', child: Text('Reject')),
        ],
      );
    }

    final buttonStyle = TextButton.styleFrom(
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          style: buttonStyle,
          onPressed: () => onView(row),
          child: const Text('View'),
        ),
        TextButton(
          style: buttonStyle,
          onPressed: () => onStatusChange(row, 'Sample Collected'),
          child: const Text('Accept'),
        ),
        TextButton(
          style: buttonStyle,
          onPressed: () => onStatusChange(row, 'Rejected'),
          child: const Text('Reject'),
        ),
      ],
    );
  }
}
