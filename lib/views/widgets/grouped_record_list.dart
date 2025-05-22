import 'package:flutter/material.dart';
import 'package:bad_calendar/models/habit_record_model.dart';
import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'package:bad_calendar/views/widgets/record_card_widget.dart';

class GroupedRecordList extends StatelessWidget {
  final HabitViewModel viewModel;

  const GroupedRecordList({super.key, required this.viewModel});

  int _countDaysInYear(
    Map<int, List<MapEntry<DateTime, HabitRecordModel>>> monthsMap,
  ) {
    return monthsMap.values.fold(0, (sum, list) => sum + list.length);
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Map<int, List<MapEntry<DateTime, HabitRecordModel>>>>
    grouped = {};

    for (var entry in viewModel.records.entries) {
      final date = entry.key;
      final year = date.year;
      final month = date.month;

      grouped.putIfAbsent(year, () => {});
      grouped[year]!.putIfAbsent(month, () => []);
      grouped[year]![month]!.add(entry);
    }

    final sortedYears = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedYears.length,
      itemBuilder: (context, yearIndex) {
        final year = sortedYears[yearIndex];
        final monthsMap = grouped[year]!;
        final sortedMonths =
            monthsMap.keys.toList()..sort((a, b) => b.compareTo(a));

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                children: [
                  const Icon(Icons.timeline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$year年（共 ${_countDaysInYear(monthsMap)} 天）',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  sortedMonths.map((month) {
                    final entries = monthsMap[month]!;
                    final sortedEntries =
                        entries.toList()
                          ..sort((a, b) => b.key.compareTo(a.key));

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              const Icon(Icons.event_note, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '$month月（共 ${entries.length} 天）',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          tilePadding: const EdgeInsets.only(
                            left: 32,
                            right: 16,
                          ),
                          childrenPadding: const EdgeInsets.only(
                            left: 40,
                            right: 16,
                            bottom: 8,
                          ),
                          children:
                              sortedEntries.map((entry) {
                                return RecordCard(
                                  date: entry.key,
                                  periods: entry.value.recordedPeriods,
                                  onDeletePeriod:
                                      (period) => viewModel.removeRecord(
                                        entry.key,
                                        period,
                                      ),
                                );
                              }).toList(),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
