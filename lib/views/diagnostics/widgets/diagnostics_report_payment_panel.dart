import 'package:flutter/material.dart';

import '../../../utils/fonts.dart';
import '../../../widgets/empty_state_widget.dart';

class DiagnosticsReportPaymentPanel extends StatelessWidget {
  final String uploadedReportName;
  final TextEditingController testCostController;
  final String paymentStatus;
  final String paymentMethod;
  final ValueChanged<String> onPaymentStatusChanged;
  final ValueChanged<String> onPaymentMethodChanged;
  final VoidCallback onGenerateInvoice;
  final VoidCallback onPreviewReport;
  final VoidCallback onDownloadReport;

  const DiagnosticsReportPaymentPanel({
    super.key,
    required this.uploadedReportName,
    required this.testCostController,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.onPaymentStatusChanged,
    required this.onPaymentMethodChanged,
    required this.onGenerateInvoice,
    required this.onPreviewReport,
    required this.onDownloadReport,
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
                Text('Uploaded Report', style: AppFonts.labelLarge),
                const SizedBox(height: 8),
                if (uploadedReportName.isEmpty)
                  const EmptyStateWidget(
                    message: 'No report uploaded yet.',
                    icon: Icons.upload_file,
                  )
                else
                  ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    title: Text(uploadedReportName),
                    subtitle: const Text('Ready for preview/download'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: onPreviewReport,
                        ),
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: onDownloadReport,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Details', style: AppFonts.labelLarge),
                const SizedBox(height: 10),
                TextField(
                  controller: testCostController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Test Cost'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: paymentStatus,
                  decoration: const InputDecoration(
                    labelText: 'Payment Status',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onPaymentStatusChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                    DropdownMenuItem(value: 'Card', child: Text('Card')),
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(
                      value: 'Bank Transfer',
                      child: Text('Bank Transfer'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onPaymentMethodChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: onGenerateInvoice,
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Generate Invoice'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
