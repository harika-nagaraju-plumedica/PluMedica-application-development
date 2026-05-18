import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/sos_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/sos_viewmodel.dart';

class PatientSosApiScreen extends StatelessWidget {
  const PatientSosApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SosViewModel>(
      create: (_) => SosViewModel(
        SosRepository(PatientApiService()),
      ),
      child: const _PatientSosApiBody(),
    );
  }
}

class _PatientSosApiBody extends StatelessWidget {
  const _PatientSosApiBody();

  Future<void> _triggerSos(BuildContext context, SosViewModel vm) async {
    final ok = await vm.triggerSOS();
    if (!context.mounted) {
      return;
    }

    final message = ok
        ? (vm.success ?? 'SOS alert triggered successfully.')
        : (vm.error ?? 'Failed to trigger SOS alert.');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SosViewModel>(
      builder: (context, vm, _) {
        final response = vm.latestResponse;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Emergency SOS (API)'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 42,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Emergency SOS',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the button to trigger emergency alert and notify contacts.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: ElevatedButton(
                  onPressed: vm.isLoading ? null : () => _triggerSos(context, vm),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 6,
                  ),
                  child: vm.isLoading
                      ? const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'SOS',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              if (response != null) ...[
                Card(
                  child: ListTile(
                    title: const Text('Alert Status'),
                    subtitle: Text('Alert ID: ${response.alertId}'),
                    trailing: Text(response.status),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Notified Contacts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (response.notifiedContacts.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('No contacts were notified.'),
                    ),
                  )
                else
                  ...response.notifiedContacts.map(
                    (contact) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(contact.name.isEmpty ? 'Unknown' : contact.name),
                        subtitle: Text(contact.phone),
                        trailing: Text(contact.id),
                      ),
                    ),
                  ),
              ],
              if (vm.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    vm.error ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
