import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../services/patient_api_exception.dart';
import 'base_view_model.dart';

class PatientProfileViewModel extends BaseViewModel {
  PatientProfileViewModel(this._repository);

  final ProfileRepository _repository;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String gender = '';
  String bloodGroup = '';

  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  Future<void> fetchProfile() async {
    setLoading(true);
    clearMessages();

    try {
      _profileModel = await _repository.fetchProfile();
      _syncFormFromModel(_profileModel?.profile);
      setSuccess('Profile fetched');
    } on PatientApiException catch (error) {
      setError(error.message);
    } catch (_) {
      setError('Unable to load profile right now.');
    } finally {
      setLoading(false);
    }
  }

  void setEditMode(bool enabled) {
    _isEditMode = enabled;
    notifyListeners();
  }

  void updateGender(String? value) {
    gender = value ?? '';
    notifyListeners();
  }

  void updateBloodGroup(String? value) {
    bloodGroup = value ?? '';
    notifyListeners();
  }

  Future<bool> updateProfile() async {
    clearMessages();

    final fullName = fullNameController.text.trim();
    final mobile = mobileController.text.trim();
    final selectedGender = gender.trim();
    final selectedBloodGroup = bloodGroup.trim();
    final address = addressController.text.trim();
    final dob = _normalizeDob(dobController.text.trim());

    if (fullName.isEmpty ||
        mobile.isEmpty ||
        selectedGender.isEmpty ||
        selectedBloodGroup.isEmpty ||
        address.isEmpty) {
      setError('Please fill all required profile fields.');
      return false;
    }

    if (dobController.text.trim().isNotEmpty && dob == null) {
      setError('DOB must be in YYYY-MM-DD format.');
      return false;
    }

    setLoading(true);

    try {
      final updated = await _repository.updateProfile(
        ProfileUpdateRequest(
          fullName: fullName,
          mobile: mobile,
          gender: selectedGender,
          bloodGroup: selectedBloodGroup,
          address: address,
          dob: dob,
        ),
      );

      _profileModel = updated;
      _syncFormFromModel(updated.profile);
      _isEditMode = false;
      setSuccess('Profile updated successfully.');
      return true;
    } on PatientApiException catch (error) {
      setError(error.message);
      return false;
    } catch (_) {
      setError('Unable to update profile right now.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  void _syncFormFromModel(PatientProfile? profile) {
    if (profile == null) {
      return;
    }

    fullNameController.text = profile.fullName;
    emailController.text = profile.email;
    mobileController.text = profile.mobile;
    addressController.text = profile.address;
    dobController.text = profile.dob ?? '';
    gender = profile.gender;
    bloodGroup = profile.bloodGroup;
    notifyListeners();
  }

  String? _normalizeDob(String value) {
    if (value.isEmpty) {
      return null;
    }

    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) {
      return null;
    }
    return value;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
