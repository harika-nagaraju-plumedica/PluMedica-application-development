import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class PatientSosController extends GetxController {
  final isSOSActive = false.obs;
  final emergencyContacts = <Map<String, String>>[].obs;
  final sosHistory = [].obs;
  static const String _emergencyContactsKey = 'patient_emergency_contacts';

  @override
  void onInit() {
    super.onInit();
    loadEmergencyContacts();
  }

  Future<void> loadEmergencyContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_emergencyContactsKey);
      if (rawJson == null || rawJson.isEmpty) {
        emergencyContacts.clear();
        return;
      }

      final decoded = jsonDecode(rawJson);
      if (decoded is List) {
        emergencyContacts.value = decoded
            .whereType<Map>()
            .map(
              (item) => item.map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
            .toList();
      } else {
        emergencyContacts.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contacts');
    }
  }

  Future<void> _saveEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _emergencyContactsKey,
      jsonEncode(emergencyContacts),
    );
  }

  bool _isValidPhoneNumber(String value) {
    final trimmed = value.trim();
    final allowedPattern = RegExp(r'^[0-9+\-() ]+$');
    if (!allowedPattern.hasMatch(trimmed)) {
      return false;
    }

    final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  String _sanitizeDialNumber(String value) {
    final trimmed = value.trim();
    final keepLeadingPlus = trimmed.startsWith('+');
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }
    return keepLeadingPlus ? '+$digits' : digits;
  }

  String _buildSosMessage() {
    final timestamp = DateTime.now().toLocal().toString();
    return 'SOS ALERT: I need immediate assistance. Triggered at $timestamp.';
  }

  List<Map<String, String>> _getValidContacts() {
    return emergencyContacts.where((contact) {
      final phone = contact['phone'] ?? '';
      return _sanitizeDialNumber(phone).isNotEmpty;
    }).toList();
  }

  Map<String, String>? _getPrimaryContact(List<Map<String, String>> contacts) {
    if (contacts.isEmpty) {
      return null;
    }

    // The first valid contact is treated as the primary emergency contact.
    return contacts.first;
  }

  Future<void> _notifyEmergencyContacts(List<Map<String, String>> contacts) async {
    final recipients = contacts
        .map((contact) => _sanitizeDialNumber(contact['phone'] ?? ''))
        .where((phone) => phone.isNotEmpty)
        .toList();

    if (recipients.isEmpty) {
      Get.snackbar('Warning', 'No valid contact numbers found');
      return;
    }

    final smsUri = Uri(
      scheme: 'sms',
      path: recipients.join(','),
      queryParameters: {
        'body': _buildSosMessage(),
      },
    );

    final launched = await launchUrl(
      smsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      Get.snackbar('Error', 'Unable to open SMS app for emergency alert');
    }
  }

  Future<void> _promptAddEmergencyContact() async {
    await Get.defaultDialog(
      title: 'No Emergency Contacts',
      middleText:
          'Add at least one emergency contact before activating SOS.',
      textConfirm: 'Add Contact',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        addEmergencyContact();
      },
    );
  }

  Future<void> _callPrimaryContact(List<Map<String, String>> contacts) async {
    final primaryContact = _getPrimaryContact(contacts);
    if (primaryContact == null) {
      return;
    }

    final primaryName = primaryContact['name'] ?? 'Primary contact';
    final primaryPhone = primaryContact['phone'] ?? '';
    await callEmergencyContact(primaryPhone);
    Get.snackbar('Calling', 'Opening dialer for $primaryName');
  }

  Future<void> activateSOS() async {
    final validContacts = _getValidContacts();
    if (validContacts.isEmpty) {
      await _promptAddEmergencyContact();
      return;
    }

    isSOSActive.value = true;
    // TODO: Send SOS alert to emergency services
    await _notifyEmergencyContacts(validContacts);
    await _callPrimaryContact(validContacts);
    // TODO: Share live location

    final primaryContact = _getPrimaryContact(validContacts);

    sosHistory.add({
      'timestamp': DateTime.now().toIso8601String(),
      'notifiedContacts': validContacts.length,
      'primaryContact': primaryContact?['name'] ?? '',
      'status': 'active',
    });

    Get.snackbar(
      'Alert Sent',
      'SOS activated and ${validContacts.length} contact(s) prepared for notification',
    );
  }

  Future<void> cancelSOS() async {
    isSOSActive.value = false;
    // TODO: Cancel SOS alert

    sosHistory.add({
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'cancelled',
    });

    Get.snackbar('Alert', 'SOS Cancelled');
  }

  Future<void> addEmergencyContact() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();

    await Get.defaultDialog(
      title: 'Add Emergency Contact',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            controller: relationController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Relation (Optional)'),
          ),
        ],
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () async {
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();
        final relation = relationController.text.trim();

        if (name.isEmpty || phone.isEmpty) {
          Get.snackbar('Validation', 'Name and phone number are required');
          return;
        }

        if (!_isValidPhoneNumber(phone)) {
          Get.snackbar(
            'Validation',
            'Enter a valid phone number (10 to 15 digits)',
          );
          return;
        }

        emergencyContacts.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'phone': phone,
          'relation': relation,
        });
        await _saveEmergencyContacts();
        Get.back();
        Get.snackbar('Success', 'Emergency contact added');
      },
    );
  }

  Future<void> editEmergencyContact(String contactId) async {
    final index = emergencyContacts.indexWhere(
      (contact) => contact['id'] == contactId,
    );
    if (index == -1) {
      Get.snackbar('Error', 'Contact not found');
      return;
    }

    final contact = emergencyContacts[index];
    final nameController = TextEditingController(text: contact['name'] ?? '');
    final phoneController =
        TextEditingController(text: contact['phone'] ?? '');
    final relationController =
        TextEditingController(text: contact['relation'] ?? '');

    await Get.defaultDialog(
      title: 'Edit Emergency Contact',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            controller: relationController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Relation (Optional)'),
          ),
        ],
      ),
      textConfirm: 'Update',
      textCancel: 'Cancel',
      onConfirm: () async {
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();
        final relation = relationController.text.trim();

        if (name.isEmpty || phone.isEmpty) {
          Get.snackbar('Validation', 'Name and phone number are required');
          return;
        }

        if (!_isValidPhoneNumber(phone)) {
          Get.snackbar(
            'Validation',
            'Enter a valid phone number (10 to 15 digits)',
          );
          return;
        }

        emergencyContacts[index] = {
          'id': contactId,
          'name': name,
          'phone': phone,
          'relation': relation,
        };
        await _saveEmergencyContacts();
        Get.back();
        Get.snackbar('Success', 'Emergency contact updated');
      },
    );
  }

  Future<void> deleteEmergencyContact(String contactId) async {
    final deletedCount = emergencyContacts
        .where((contact) => contact['id'] == contactId)
        .length;
    emergencyContacts.removeWhere((contact) => contact['id'] == contactId);

    if (deletedCount == 0) {
      Get.snackbar('Error', 'Contact not found');
      return;
    }

    await _saveEmergencyContacts();
    Get.snackbar('Success', 'Emergency contact deleted');
  }

  Future<void> callEmergencyContact(String phoneNumber) async {
    final dialNumber = _sanitizeDialNumber(phoneNumber);
    if (dialNumber.isEmpty) {
      Get.snackbar('Error', 'Invalid phone number');
      return;
    }

    final uri = Uri.parse('tel:$dialNumber');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      Get.snackbar('Error', 'Unable to open phone dialer');
    }
  }
}
