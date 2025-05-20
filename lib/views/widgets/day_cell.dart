// lib/views/widgets/day_cell.dart
import 'package:bad_calendar/models/time_period.dart';
import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final Color? backgroundColor; // 新增参数

  const DayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isToday,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              isSelected
                  ? Colors.blue
                  : isToday
                  ? Colors.orange
                  : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? Colors.blue : Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 12,
            child: Row(
              children:
                  TimePeriod.values.map((period) {
                    final color = viewModel.getCellColor(day, period);

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2), // 设置圆角半径
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
