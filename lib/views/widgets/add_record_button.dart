import 'package:bad_calendar/models/time_period.dart';
import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecordButton extends StatelessWidget {
  final DateTime day;

  const AddRecordButton({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            TimePeriod selectedPeriod = TimePeriod.morning;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('${day.year} / ${day.month} / ${day.day}'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        TimePeriod.values.map((period) {
                          return RadioListTile<TimePeriod>(
                            title: periodToIcon(period),
                            value: period,
                            groupValue: selectedPeriod,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedPeriod = value;
                                });
                              }
                            },
                          );
                        }).toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 取消关闭
                      },
                      child: const Text('取消'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final viewModel = Provider.of<HabitViewModel>(
                          context,
                          listen: false,
                        );
                        viewModel.addRecord(day, selectedPeriod);
                        Navigator.of(context).pop(); // 添加后关闭
                      },
                      child: const Text('添加'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
