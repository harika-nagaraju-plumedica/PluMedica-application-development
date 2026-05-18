import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/metric_item.dart';
import '../repositories/emergency_contact_repository.dart';
import '../repositories/health_metrics_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/patient_health_api_viewmodel.dart';

class PatientHealthDashboardScreen extends StatelessWidget {
  const PatientHealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PatientHealthApiViewModel>(
      create: (_) {
        final api = PatientApiService();
        return PatientHealthApiViewModel(
          HealthMetricsRepository(api),
          EmergencyContactRepository(api),
        )..fetchLatestMetrics();
      },
      child: const _PatientHealthDashboardBody(),
    );
  }
}

class _PatientHealthDashboardBody extends StatelessWidget {
  const _PatientHealthDashboardBody();

  static const List<String> _orderedMetricTypes = <String>[
    'BP_SYS',
    'BP_DIA',
    'HEART_RATE',
    'WEIGHT',
    'SPO2',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientHealthApiViewModel>(
      builder: (context, vm, _) {
        final latest = vm.latestMetrics;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Health Dashboard (API)'),
            actions: [
              IconButton(
                tooltip: 'Metric History',
                onPressed: () => Get.toNamed('/patient/api/metric-history'),
                icon: const Icon(Icons.history),
              ),
              IconButton(
                tooltip: 'Emergency SOS',
                onPressed: () => Get.toNamed('/patient/api/sos'),
                icon: const Icon(Icons.sos_outlined),
              ),
              IconButton(
                tooltip: 'Add Emergency Contact',
                onPressed: () => Get.toNamed('/patient/api/add-emergency-contact'),
                icon: const Icon(Icons.contact_emergency_outlined),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: vm.fetchLatestMetrics,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (vm.isLoading && latest == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.hasError && latest == null)
                  _ErrorView(
                    message: vm.error ?? 'Unable to load latest metrics.',
                    onRetry: vm.fetchLatestMetrics,
                  )
                else ...[
                  Text(
                    'Latest Health Metrics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pulled from /api/patient/health-metrics/latest',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ..._orderedMetricTypes.map((type) {
                    final item = latest?.byType(type);
                    return _MetricCard(
                      metricType: type,
                      item: item,
                    );
                  }),
                  if (vm.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        vm.error ?? '',
                        style: const TextStyle(color: Colors.red),
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
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.metricType,
    required this.item,
  });

  final String metricType;
  final MetricItem? item;

  @override
  Widget build(BuildContext context) {
    final measuredAt = item?.measuredAt ?? 'N/A';
    final value = item == null ? '--' : '${item!.value} ${item!.unit}';

    return Card(
      child: ListTile(
        title: Text(metricType),
        subtitle: Text('Measured: $measuredAt'),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
