// lib/views/pages/statistics_page.dart
import 'package:bad_calendar/models/time_period.dart';
import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);
    final records = viewModel.records;

    // 过滤出有记录的
    final nonEmptyRecords =
        records.entries
            .where((e) => e.value.recordedPeriods.isNotEmpty)
            .toList()
          ..sort((a, b) => b.key.compareTo(a.key)); // 时间倒序

    return Scaffold(
      appBar: AppBar(title: const Text('统计记录'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: nonEmptyRecords.length,
          itemBuilder: (context, index) {
            final entry = nonEmptyRecords[index];
            final date = entry.key;
            final periods = entry.value.recordedPeriods;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                leading: const Icon(Icons.sell, color: Colors.blueAccent),
                title: Text(
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
          },
        ),
      ),
    );
  }
}
