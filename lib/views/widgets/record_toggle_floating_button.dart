import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../view_models/habit_view_model.dart';

class RecordToggleFloatingButton extends StatelessWidget {
  const RecordToggleFloatingButton({super.key});

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
      final isBeforeToday = selectedDay!.isBefore(today);

      return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            viewModel.backToToday();
          },
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
          shape: const CircleBorder(),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isBeforeToday ? 3.1416 : 0), // 翻转图标
            child: Icon(Icons.reply, color: Colors.blueAccent, size: iconSize),
          ),
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
          onPressed: () {
            HapticFeedback.lightImpact();
            viewModel.togglePeriod(today, currentPeriod);
          },
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
          shape: const CircleBorder(),
          tooltip: isRecorded ? '删除记录' : '添加记录',
          child: Icon(
            isRecorded ? Icons.event_busy : Icons.event_available,
            color: isRecorded ? Colors.green : Colors.red,
            size: iconSize,
          ),
        ),
      );
    }
  }
}
