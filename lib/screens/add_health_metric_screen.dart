import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/health_metric_model.dart';
import '../repositories/health_metrics_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/health_metrics_viewmodel.dart';

class AddHealthMetricScreen extends StatelessWidget {
  const AddHealthMetricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HealthMetricsViewModel>(
      create: (_) => HealthMetricsViewModel(
        HealthMetricsRepository(PatientApiService()),
      ),
      child: const _AddHealthMetricBody(),
    );
  }
}

class _AddHealthMetricBody extends StatefulWidget {
  const _AddHealthMetricBody();

  @override
  State<_AddHealthMetricBody> createState() => _AddHealthMetricBodyState();
}

class _AddHealthMetricBodyState extends State<_AddHealthMetricBody> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _unitController = TextEditingController(text: 'bpm');

  String _metricType = 'HEART_RATE';
  String _source = 'MANUAL';
  DateTime _measuredAt = DateTime.now().toUtc();

  @override
  void dispose() {
    _valueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _pickMeasuredAt() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _measuredAt.toLocal(),
    );
    if (date == null) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_measuredAt.toLocal()),
    );

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    ).toUtc();

    setState(() {
      _measuredAt = picked;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vm = context.read<HealthMetricsViewModel>();
    final request = AddHealthMetricRequest(
      metricType: _metricType,
      value: double.parse(_valueController.text.trim()),
      unit: _unitController.text.trim(),
      measuredAt: _measuredAt.toIso8601String(),
      source: _source,
    );

    final ok = await vm.addHealthMetric(request);
    if (!mounted) {
      return;
    }

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health metric added.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthMetricsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Health Metric')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _metricType,
                    items: const [
                      DropdownMenuItem(
                        value: 'HEART_RATE',
                        child: Text('Heart Rate'),
                      ),
                      DropdownMenuItem(
                        value: 'BLOOD_PRESSURE',
                        child: Text('Blood Pressure'),
                      ),
                      DropdownMenuItem(
                        value: 'WEIGHT',
                        child: Text('Weight'),
                      ),
                      DropdownMenuItem(
                        value: 'OXYGEN_LEVEL',
                        child: Text('Oxygen Level'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _metricType = value ?? 'HEART_RATE';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Metric Type'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Value'),
                    validator: (value) {
                      final raw = value?.trim() ?? '';
                      if (raw.isEmpty) {
                        return 'Value is required.';
                      }
                      if (double.tryParse(raw) == null) {
                        return 'Enter a valid numeric value.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return 'Unit is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _source,
                    items: const [
                      DropdownMenuItem(value: 'MANUAL', child: Text('Manual')),
                      DropdownMenuItem(value: 'DEVICE', child: Text('Device')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _source = value ?? 'MANUAL';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Source'),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Measured At'),
                    subtitle: Text(_measuredAt.toIso8601String()),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: _pickMeasuredAt,
                  ),
                  const SizedBox(height: 16),
                  if (vm.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        vm.error ?? '',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isLoading ? null : _submit,
                      child: vm.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add Metric'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
