import 'package:flutter/material.dart';
import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'summary_item.dart';

class SummaryCard extends StatelessWidget {
  final HabitViewModel viewModel;
  const SummaryCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final allRecords = viewModel.records;
    if (allRecords.isEmpty) return const SizedBox.shrink();

    final sortedDates = allRecords.keys.toList()..sort();
    final firstDate = sortedDates.first;
    final lastDate = sortedDates.last;
    final totalSpanDays = lastDate.difference(firstDate).inDays + 1;

    final totalPeriods = allRecords.values
        .map((r) => r.recordedPeriods.length)
        .fold(0, (a, b) => a + b);

    List<int> dayGaps = [];
    for (int i = 1; i < sortedDates.length; i++) {
      final gap = sortedDates[i].difference(sortedDates[i - 1]).inDays - 1;
      dayGaps.add(gap);
    }

    final minGap =
        dayGaps.isEmpty ? 0 : dayGaps.reduce((a, b) => a < b ? a : b);
    final maxGap =
        dayGaps.isEmpty ? 0 : dayGaps.reduce((a, b) => a > b ? a : b);

    String formatDate(DateTime date) =>
        '${date.year}/${date.month}/${date.day}';

    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${formatDate(firstDate)} ~ ${formatDate(lastDate)}（共 $totalSpanDays 天）',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SummaryItem(title: '记录总数', value: '$totalPeriods'),
                SummaryItem(title: '最小间隔', value: '$minGap 天'),
                SummaryItem(title: '最大间隔', value: '$maxGap 天'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
