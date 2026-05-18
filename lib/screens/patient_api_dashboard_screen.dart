import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../repositories/dashboard_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/patient_dashboard_viewmodel.dart';

class PatientApiDashboardScreen extends StatelessWidget {
  const PatientApiDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PatientDashboardViewModel>(
      create: (_) => PatientDashboardViewModel(
        DashboardRepository(PatientApiService()),
      )..fetchDashboard(),
      child: const _PatientApiDashboardBody(),
    );
  }
}

class _PatientApiDashboardBody extends StatelessWidget {
  const _PatientApiDashboardBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientDashboardViewModel>(
      builder: (context, vm, _) {
        final dashboard = vm.dashboard;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient Dashboard (API)'),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed('/patient/api/profile'),
                icon: const Icon(Icons.person_outline),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: vm.fetchDashboard,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (vm.isLoading && dashboard == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.hasError && dashboard == null)
                  _ErrorState(
                    message: vm.error ?? 'Unable to load dashboard.',
                    onRetry: vm.fetchDashboard,
                  )
                else ...[
                  Text(
                    'Hello, ${dashboard?.patient.fullName.isNotEmpty == true ? dashboard!.patient.fullName : 'Patient'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dashboard?.patient.generatedId ?? 'Generated ID not available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: 'Upcoming',
                          value:
                              (dashboard?.summary.upcomingAppointments ?? 0)
                                  .toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryTile(
                          label: 'Medications',
                          value: (dashboard?.summary.activeMedications ?? 0)
                              .toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryTile(
                          label: 'Reports',
                          value: (dashboard?.summary.reports ?? 0).toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Latest Metrics',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  _MetricTile(
                    label: 'Blood Pressure',
                    value: dashboard?.latestMetrics.bloodPressure ?? '--',
                  ),
                  _MetricTile(
                    label: 'Heart Rate',
                    value: dashboard?.latestMetrics.heartRate == null
                        ? '--'
                        : '${dashboard!.latestMetrics.heartRate!.value} ${dashboard.latestMetrics.heartRate!.unit}',
                  ),
                  _MetricTile(
                    label: 'Weight',
                    value: dashboard?.latestMetrics.weight == null
                        ? '--'
                        : '${dashboard!.latestMetrics.weight} kg',
                  ),
                  _MetricTile(
                    label: 'Oxygen Level',
                    value: dashboard?.latestMetrics.oxygenLevel == null
                        ? '--'
                        : '${dashboard!.latestMetrics.oxygenLevel} %',
                  ),
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

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
