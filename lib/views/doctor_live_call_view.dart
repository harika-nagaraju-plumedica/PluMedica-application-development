import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Live call screen for doctor virtual consultations.
class DoctorLiveCallView extends StatefulWidget {
  const DoctorLiveCallView({super.key});

  @override
  State<DoctorLiveCallView> createState() => _DoctorLiveCallViewState();
}

class _DoctorLiveCallViewState extends State<DoctorLiveCallView> {
  late final Map<String, dynamic> _args;
  bool _checkingPermission = true;
  bool _hasMediaPermission = false;
  bool _joiningCall = false;

  @override
  void initState() {
    super.initState();
    _args = Map<String, dynamic>.from(Get.arguments ?? <String, dynamic>{});
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _checkingPermission = true;
    });

    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    setState(() {
      _hasMediaPermission = cameraStatus.isGranted && micStatus.isGranted;
      _checkingPermission = false;
    });

    if (!_hasMediaPermission) {
      Get.snackbar(
        'Permission Required',
        'Camera and microphone permission are required for live video consultation.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _joinLiveCall() async {
    if (!_hasMediaPermission) {
      await _requestPermissions();
      if (!_hasMediaPermission) {
        return;
      }
    }

    final appointmentId = (_args['appointmentId'] ?? 'appointment').toString();
    final patientId = (_args['patientId'] ?? 'patient').toString();
    final doctorId = (_args['doctorId'] ?? 'doctor').toString();
    final roomName = 'plumedica_${doctorId}_${patientId}_$appointmentId'
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')
        .toLowerCase();

    final uri = Uri.parse(
      'https://meet.jit.si/$roomName#config.prejoinPageEnabled=false&config.startWithVideoMuted=false&config.startWithAudioMuted=false',
    );

    setState(() {
      _joiningCall = true;
    });

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        Get.snackbar(
          'Error',
          'Unable to launch live call screen. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Unable to launch live call screen. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _joiningCall = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientName = (_args['patientName'] ?? 'Patient').toString();
    final patientId = (_args['patientId'] ?? '-').toString();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Live Video Consultation'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium,
                ),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Patient ID: $patientId',
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This consultation opens a secure live room with real-time video and in-call chat.',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_checkingPermission)
              const Center(child: CircularProgressIndicator())
            else if (!_hasMediaPermission)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Camera or microphone permission denied',
                      style: AppFonts.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enable camera and microphone permission to continue with live video consultation.',
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: _requestPermissions,
                          child: const Text('Retry Permission'),
                        ),
                        OutlinedButton(
                          onPressed: openAppSettings,
                          child: const Text('Open Settings'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Camera and microphone access ready. You can start the consultation now.',
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _joiningCall ? null : _joinLiveCall,
                icon: _joiningCall
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.videocam),
                label: Text(_joiningCall ? 'Connecting...' : 'Join Live Video Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
