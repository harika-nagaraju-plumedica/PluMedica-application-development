import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/emergency_contact_repository.dart';
import '../repositories/health_metrics_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/patient_health_api_viewmodel.dart';

class MetricHistoryListScreen extends StatelessWidget {
  const MetricHistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PatientHealthApiViewModel>(
      create: (_) {
        final api = PatientApiService();
        final vm = PatientHealthApiViewModel(
          HealthMetricsRepository(api),
          EmergencyContactRepository(api),
        );
        final today = DateTime.now();
        final from = today.subtract(const Duration(days: 30));
        vm.fetchMetricHistory(
          metricType: 'HEART_RATE',
          from: from,
          to: today,
          page: 1,
          limit: 10,
        );
        return vm;
      },
      child: const _MetricHistoryListBody(),
    );
  }
}

class _MetricHistoryListBody extends StatefulWidget {
  const _MetricHistoryListBody();

  @override
  State<_MetricHistoryListBody> createState() => _MetricHistoryListBodyState();
}

class _MetricHistoryListBodyState extends State<_MetricHistoryListBody> {
  String _metricType = 'HEART_RATE';
  DateTime _from = DateTime.now().subtract(const Duration(days: 30));
  DateTime _to = DateTime.now();
  int _page = 1;
  int _limit = 10;

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _from,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _from = picked;
    });
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _to,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _to = picked;
    });
  }

  Future<void> _applyFilters() async {
    await context.read<PatientHealthApiViewModel>().fetchMetricHistory(
          metricType: _metricType,
          from: _from,
          to: _to,
          page: _page,
          limit: _limit,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientHealthApiViewModel>(
      builder: (context, vm, _) {
        final history = vm.metricHistory;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Metric History (API)'),
          ),
          body: RefreshIndicator(
            onRefresh: _applyFilters,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _metricType,
                          items: const [
                            DropdownMenuItem(
                              value: 'HEART_RATE',
                              child: Text('Heart Rate'),
                            ),
                            DropdownMenuItem(
                              value: 'BP_SYS',
                              child: Text('BP Systolic'),
                            ),
                            DropdownMenuItem(
                              value: 'BP_DIA',
                              child: Text('BP Diastolic'),
                            ),
                            DropdownMenuItem(
                              value: 'WEIGHT',
                              child: Text('Weight'),
                            ),
                            DropdownMenuItem(
                              value: 'SPO2',
                              child: Text('SPO2'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _metricType = value ?? 'HEART_RATE';
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Metric Type',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _pickFromDate,
                                child: Text('From: ${_fmt(_from)}'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _pickToDate,
                                child: Text('To: ${_fmt(_to)}'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: _page.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Page',
                                ),
                                onChanged: (value) {
                                  _page = int.tryParse(value) ?? 1;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: _limit.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Limit',
                                ),
                                onChanged: (value) {
                                  _limit = int.tryParse(value) ?? 10;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.isLoading ? null : _applyFilters,
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (vm.hasError && (history == null || history.items.isEmpty))
                  Card(
                    child: ListTile(
                      title: Text(
                        vm.error ?? 'Unable to load metric history.',
                        style: const TextStyle(color: Colors.red),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _applyFilters,
                      ),
                    ),
                  )
                else if (history == null || history.items.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('No metric history found for selected filter.'),
                    ),
                  )
                else ...[
                  Card(
                    child: ListTile(
                      title: Text('Total: ${history.meta.total}'),
                      subtitle: Text(
                        'Page ${history.meta.page}, Limit ${history.meta.limit}, Type ${history.meta.metricType}',
                      ),
                    ),
                  ),
                  ...history.items.map(
                    (item) => Card(
                      child: ListTile(
                        title: Text('${item.value} ${item.unit}'),
                        subtitle: Text(
                          '${item.metricType} | ${item.measuredAt ?? 'N/A'} | ${item.source ?? 'N/A'}',
                        ),
                        trailing: Text(item.id.isEmpty ? '-' : item.id),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmt(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
