import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/habit_view_model.dart';

class RecordToggleButton extends StatelessWidget {
  const RecordToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);
    final selectedDay = viewModel.selectedDay;
    final today = viewModel.today;
    final currentPeriod = viewModel.getCurrentTimePeriod();

    final boxWidth = 70.0;
    final boxHeight = 70.0;
    final iconSize = 37.0;

    // 如果没有选择今天，显示"今"按钮
    if (today != selectedDay) {
      return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: FloatingActionButton(
          onPressed: () => viewModel.backToToday(),
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
          shape: const CircleBorder(),
          child: Icon(Icons.reply, color: Colors.blueAccent, size: iconSize),
        ),
      );
    }
    // 如果是今天,显示操作图标
    else {
      final isRecorded = viewModel.hasRecord(selectedDay!, currentPeriod);

      return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: FloatingActionButton(
          onPressed: () => viewModel.togglePeriod(today, currentPeriod),
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
          shape: const CircleBorder(),
          tooltip: isRecorded ? '删除记录' : '添加记录',
          child: Icon(
            isRecorded ? Icons.event_busy : Icons.event_available,
            color: isRecorded ? Colors.red : Colors.green,
            size: iconSize,
          ),
        ),
      );
    }
  }
}
