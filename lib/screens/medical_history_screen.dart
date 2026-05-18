import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/medical_history_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/medical_history_viewmodel.dart';
import '../widgets/patient/api/appointment_history_tile.dart';
import 'add_health_metric_screen.dart';
import 'medical_history_filter_screen.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicalHistoryViewModel>(
      create: (_) => MedicalHistoryViewModel(
        MedicalHistoryRepository(PatientApiService()),
      )..fetchAllMedicalHistory(),
      child: const _MedicalHistoryBody(),
    );
  }
}

class _MedicalHistoryBody extends StatelessWidget {
  const _MedicalHistoryBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicalHistoryViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Medical History (API)'),
            actions: [
              IconButton(
                onPressed: () => _openFilter(context, vm),
                icon: const Icon(Icons.filter_alt_outlined),
              ),
              IconButton(
                onPressed: vm.hasActiveFilter
                    ? () => vm.clearFilterAndReload()
                    : null,
                icon: const Icon(Icons.filter_alt_off_outlined),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AddHealthMetricScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              if (vm.hasActiveFilter && vm.fromDate != null && vm.toDate != null) {
                return vm.fetchAppointmentsWithDateFilter(
                  from: vm.fromDate!,
                  to: vm.toDate!,
                );
              }
              return vm.fetchAllMedicalHistory();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (vm.hasActiveFilter)
                  Card(
                    child: ListTile(
                      title: const Text('Filter Applied'),
                      subtitle: Text(vm.formatDateRange()),
                    ),
                  ),
                if (vm.isLoading && vm.appointments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.hasError && vm.appointments.isEmpty)
                  _ErrorBlock(
                    message: vm.error ?? 'Unable to load medical history.',
                    onRetry: () => vm.fetchAllMedicalHistory(),
                  )
                else if (vm.appointments.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('No appointments found.'),
                    ),
                  )
                else
                  ...vm.appointments
                      .map((item) => AppointmentHistoryTile(appointment: item)),
                if (vm.hasError && vm.appointments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      vm.error ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openFilter(
    BuildContext context,
    MedicalHistoryViewModel vm,
  ) async {
    final result = await Navigator.of(context).push<(DateTime, DateTime)>(
      MaterialPageRoute<(DateTime, DateTime)>(
        builder: (_) => MedicalHistoryFilterScreen(
          initialFrom: vm.fromDate,
          initialTo: vm.toDate,
        ),
      ),
    );

    if (result == null) {
      return;
    }

    await vm.fetchAppointmentsWithDateFilter(
      from: result.$1,
      to: result.$2,
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
        ),
      ),
    );
  }
}
