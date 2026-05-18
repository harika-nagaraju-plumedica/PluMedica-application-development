import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/profile_repository.dart';
import '../services/patient_api_service.dart';
import '../viewmodels/patient_profile_viewmodel.dart';

class PatientApiProfileScreen extends StatelessWidget {
  const PatientApiProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PatientProfileViewModel>(
      create: (_) => PatientProfileViewModel(
        ProfileRepository(PatientApiService()),
      )..fetchProfile(),
      child: const _PatientApiProfileBody(),
    );
  }
}

class _PatientApiProfileBody extends StatelessWidget {
  const _PatientApiProfileBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProfileViewModel>(
      builder: (context, vm, _) {
        final profile = vm.profileModel?.profile;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient Profile (API)'),
            actions: [
              TextButton(
                onPressed: vm.isLoading
                    ? null
                    : () {
                        vm.setEditMode(!vm.isEditMode);
                      },
                child: Text(vm.isEditMode ? 'Cancel' : 'Edit'),
              ),
            ],
          ),
          body: vm.isLoading && profile == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: vm.fetchProfile,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (vm.hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            vm.error ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      if (vm.hasSuccess)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            vm.success ?? '',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      TextFormField(
                        controller: vm.fullNameController,
                        enabled: vm.isEditMode,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: vm.emailController,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: vm.mobileController,
                        enabled: vm.isEditMode,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Mobile'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: vm.gender.isEmpty ? null : vm.gender,
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                        decoration: const InputDecoration(labelText: 'Gender'),
                        onChanged: vm.isEditMode ? vm.updateGender : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: vm.bloodGroup.isEmpty ? null : vm.bloodGroup,
                        items: const [
                          DropdownMenuItem(value: 'A+', child: Text('A+')),
                          DropdownMenuItem(value: 'A-', child: Text('A-')),
                          DropdownMenuItem(value: 'B+', child: Text('B+')),
                          DropdownMenuItem(value: 'B-', child: Text('B-')),
                          DropdownMenuItem(value: 'O+', child: Text('O+')),
                          DropdownMenuItem(value: 'O-', child: Text('O-')),
                          DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                          DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        ],
                        decoration: const InputDecoration(labelText: 'Blood Group'),
                        onChanged: vm.isEditMode ? vm.updateBloodGroup : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: vm.addressController,
                        enabled: vm.isEditMode,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: vm.dobController,
                        readOnly: true,
                        enabled: vm.isEditMode,
                        decoration: const InputDecoration(
                          labelText: 'DOB (YYYY-MM-DD)',
                        ),
                        onTap: vm.isEditMode
                            ? () async {
                                final now = DateTime.now();
                                final picked = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  lastDate: now,
                                  initialDate: DateTime(now.year - 18),
                                );
                                if (picked != null) {
                                  final month = picked.month
                                      .toString()
                                      .padLeft(2, '0');
                                  final day = picked.day
                                      .toString()
                                      .padLeft(2, '0');
                                  vm.dobController.text =
                                      '${picked.year}-$month-$day';
                                }
                              }
                            : null,
                      ),
                      const SizedBox(height: 20),
                      if (vm.isEditMode)
                        ElevatedButton(
                          onPressed: vm.isLoading
                              ? null
                              : () {
                                  vm.updateProfile();
                                },
                          child: vm.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Update Profile'),
                        ),
                      if (!vm.isEditMode)
                        Card(
                          child: ListTile(
                            title: const Text('Status'),
                            subtitle: Text(profile?.status ?? 'Pending'),
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
