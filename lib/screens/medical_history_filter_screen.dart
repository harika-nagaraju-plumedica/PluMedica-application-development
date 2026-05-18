import 'package:flutter/material.dart';

class MedicalHistoryFilterScreen extends StatefulWidget {
  const MedicalHistoryFilterScreen({
    super.key,
    this.initialFrom,
    this.initialTo,
  });

  final DateTime? initialFrom;
  final DateTime? initialTo;

  @override
  State<MedicalHistoryFilterScreen> createState() =>
      _MedicalHistoryFilterScreenState();
}

class _MedicalHistoryFilterScreenState extends State<MedicalHistoryFilterScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _fromDate = widget.initialFrom;
    _toDate = widget.initialTo;
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _fromDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _toDate ?? _fromDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Appointments')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('From Date'),
              subtitle: Text(_fromDate == null ? '--' : _formatDate(_fromDate!)),
              trailing: const Icon(Icons.date_range),
              onTap: _pickFromDate,
            ),
            ListTile(
              title: const Text('To Date'),
              subtitle: Text(_toDate == null ? '--' : _formatDate(_toDate!)),
              trailing: const Icon(Icons.date_range),
              onTap: _pickToDate,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_fromDate == null || _toDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select both dates.'),
                      ),
                    );
                    return;
                  }

                  if (_toDate!.isBefore(_fromDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('To date cannot be before from date.'),
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop((_fromDate!, _toDate!));
                },
                child: const Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
