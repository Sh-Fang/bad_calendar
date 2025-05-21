// lib/views/widgets/record_card.dart
import 'package:flutter/material.dart';
import 'package:bad_calendar/models/time_period.dart';

class RecordCard extends StatelessWidget {
  final DateTime date;
  final Set<TimePeriod> periods;

  const RecordCard({super.key, required this.date, required this.periods});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100], // 显式指定为白色
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        leading: const Icon(Icons.sell, color: Colors.blueAccent),
        title: Text(
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: periods.map((p) => periodToIcon(p)).toList(),
          ),
        ),
      ),
    );
  }
}
