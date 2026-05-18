class ProfileModel {
  const ProfileModel({required this.profile});

  final PatientProfile profile;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profile: PatientProfile.fromJson(
        json['profile'] is Map<String, dynamic>
            ? json['profile'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profile': profile.toJson(),
    };
  }
}

class PatientProfile {
  const PatientProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.bloodGroup,
    required this.address,
    this.dob,
    this.generatedId,
    this.status,
  });

  final String id;
  final String fullName;
  final String email;
  final String mobile;
  final String gender;
  final String bloodGroup;
  final String address;
  final String? dob;
  final String? generatedId;
  final String? status;

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      id: _safeString(json['id']),
      fullName: _safeString(json['fullName']),
      email: _safeString(json['email']),
      mobile: _safeString(json['mobile']),
      gender: _safeString(json['gender']),
      bloodGroup: _safeString(json['bloodGroup']),
      address: _safeString(json['address']),
      dob: json['dob'] is String ? json['dob'] as String : null,
      generatedId: _safeNullableString(json['generatedId']),
      status: _safeNullableString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
      'dob': dob,
      'generatedId': generatedId,
      'status': status,
    };
  }

  PatientProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? mobile,
    String? gender,
    String? bloodGroup,
    String? address,
    String? dob,
    String? generatedId,
    String? status,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      generatedId: generatedId ?? this.generatedId,
      status: status ?? this.status,
    );
  }
}

class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    required this.fullName,
    required this.mobile,
    required this.gender,
    required this.bloodGroup,
    required this.address,
    required this.dob,
  });

  final String fullName;
  final String mobile;
  final String gender;
  final String bloodGroup;
  final String address;
  final String? dob;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fullName': fullName,
      'mobile': mobile,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
      'dob': dob,
    };
  }
}

String _safeString(dynamic value) {
  return value?.toString().trim() ?? '';
}

String? _safeNullableString(dynamic value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty || raw == '{}' || raw.toLowerCase() == 'null') {
    return null;
  }
  return raw;
}
