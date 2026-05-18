import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/emergency_contact.dart';
import '../repositories/emergency_contact_repository.dart';
import '../repositories/health_metrics_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/patient_health_api_viewmodel.dart';

class AddEmergencyContactScreen extends StatelessWidget {
  const AddEmergencyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PatientHealthApiViewModel>(
      create: (_) {
        final api = PatientApiService();
        return PatientHealthApiViewModel(
          HealthMetricsRepository(api),
          EmergencyContactRepository(api),
        );
      },
      child: const _AddEmergencyContactBody(),
    );
  }
}

class _AddEmergencyContactBody extends StatefulWidget {
  const _AddEmergencyContactBody();

  @override
  State<_AddEmergencyContactBody> createState() => _AddEmergencyContactBodyState();
}

class _AddEmergencyContactBodyState extends State<_AddEmergencyContactBody> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  int _priority = 1;
  bool _isPrimary = true;

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = CreateEmergencyContactRequest(
      name: _nameController.text.trim(),
      relation: _relationController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      priority: _priority,
      isPrimary: _isPrimary,
    );

    final ok = await context
        .read<PatientHealthApiViewModel>()
        .createEmergencyContact(request);

    if (!mounted) {
      return;
    }

    if (ok) {
      final created = context.read<PatientHealthApiViewModel>().lastCreatedContact;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Contact created${created == null ? '' : ': ${created.name}'}',
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientHealthApiViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Emergency Contact (API)'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return 'Name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _relationController,
                    decoration: const InputDecoration(labelText: 'Relation'),
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return 'Relation is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      final raw = value?.trim() ?? '';
                      if (raw.isEmpty) {
                        return 'Phone is required.';
                      }
                      if (raw.length < 7) {
                        return 'Enter a valid phone number.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email (Optional)',
                    ),
                    validator: (value) {
                      final raw = value?.trim() ?? '';
                      if (raw.isEmpty) {
                        return null;
                      }
                      final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(raw);
                      if (!valid) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: _priority,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Priority 1')),
                      DropdownMenuItem(value: 2, child: Text('Priority 2')),
                      DropdownMenuItem(value: 3, child: Text('Priority 3')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _priority = value ?? 1;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Priority'),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _isPrimary,
                    title: const Text('Set as primary contact'),
                    onChanged: (value) {
                      setState(() {
                        _isPrimary = value;
                      });
                    },
                  ),
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
                          : const Text('Create Contact'),
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
