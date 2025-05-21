// lib/views/pages/statistics_page.dart
import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'package:bad_calendar/views/widgets/record_card.dart';
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

            return RecordCard(date: date, periods: periods);
          },
        ),
      ),
    );
  }
}
