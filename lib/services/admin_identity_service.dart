import 'package:get/get.dart';

import 'patient_session_service.dart';

class AdminIdentityProfile {
  final AppRole role;
  final String id;
  final String name;

  const AdminIdentityProfile({
    required this.role,
    required this.id,
    required this.name,
  });
}

class AdminIdentityService extends GetxService {
  final identities = <AppRole, List<AdminIdentityProfile>>{
    AppRole.patient: const [
      AdminIdentityProfile(
        role: AppRole.patient,
        id: 'P1',
        name: 'Rajesh Kumar',
      ),
      AdminIdentityProfile(
        role: AppRole.patient,
        id: 'P2',
        name: 'Priya Singh',
      ),
    ],
    AppRole.doctor: const [
      AdminIdentityProfile(
        role: AppRole.doctor,
        id: 'DOC001',
        name: 'Dr. Priya Sharma',
      ),
      AdminIdentityProfile(
        role: AppRole.doctor,
        id: 'DOC002',
        name: 'Dr. Amit Patel',
      ),
      AdminIdentityProfile(
        role: AppRole.doctor,
        id: 'DOC003',
        name: 'Dr. Nisha Verma',
      ),
    ],
    AppRole.pharmacy: const [
      AdminIdentityProfile(
        role: AppRole.pharmacy,
        id: 'PH001',
        name: 'City Medicos',
      ),
    ],
    AppRole.diagnostics: const [
      AdminIdentityProfile(
        role: AppRole.diagnostics,
        id: 'DIA001',
        name: 'Plumedica Diagnostics',
      ),
    ],
    AppRole.hospital: const [
      AdminIdentityProfile(
        role: AppRole.hospital,
        id: 'HOS001',
        name: 'Plumedica Hospital',
      ),
    ],
    AppRole.partner: const [
      AdminIdentityProfile(
        role: AppRole.partner,
        id: 'PAR001',
        name: 'Partner One',
      ),
    ],
    AppRole.jobSeeker: const [
      AdminIdentityProfile(
        role: AppRole.jobSeeker,
        id: 'JOBSEEK001',
        name: 'Job Seeker',
      ),
    ],
    AppRole.employer: const [
      AdminIdentityProfile(
        role: AppRole.employer,
        id: 'EMP001',
        name: 'Employer',
      ),
    ],
  }.obs;

  AdminIdentityProfile getPrimaryIdentity(AppRole role) {
    final list = identities[role] ?? const <AdminIdentityProfile>[];
    if (list.isEmpty) {
      return AdminIdentityProfile(role: role, id: 'UNKNOWN', name: 'Unknown');
    }
    return list.first;
  }

  String getPrimaryId(AppRole role) => getPrimaryIdentity(role).id;

  String getPrimaryName(AppRole role) => getPrimaryIdentity(role).name;
}
