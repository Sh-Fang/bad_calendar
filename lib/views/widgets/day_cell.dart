// lib/views/widgets/day_cell.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/time_period.dart';
import '../../viewmodels/calendar_view_model.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;

  const DayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context);

    return Container(
      margin: const EdgeInsets.all(4),
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
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 16,
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
                        color: color,
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
