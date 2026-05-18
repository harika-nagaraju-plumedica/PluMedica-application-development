import 'package:flutter/material.dart';

import '../../../models/medical_history_model.dart';

class AppointmentHistoryTile extends StatelessWidget {
  const AppointmentHistoryTile({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(appointment.status);

    return Card(
      child: ListTile(
        title: Text(
          appointment.reason.isEmpty ? 'No reason provided' : appointment.reason,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Appointment ID: ${appointment.id.isEmpty ? 'N/A' : appointment.id}'),
            Text('Doctor ID: ${appointment.doctorId.isEmpty ? 'N/A' : appointment.doctorId}'),
            Text('Slot: ${appointment.slotStart ?? '--'} - ${appointment.slotEnd ?? '--'}'),
            Text('Created: ${appointment.createdAt ?? '--'}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            appointment.status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}
