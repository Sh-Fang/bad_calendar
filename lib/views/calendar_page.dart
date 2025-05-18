// lib/views/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/calendar_view_model.dart';
import 'widgets/day_cell.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel(),
      child: const _CalendarPageContent(),
    );
  }
}

class _CalendarPageContent extends StatelessWidget {
  const _CalendarPageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bad Calendar 自控力')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: viewModel.focusedDay,
              selectedDayPredicate:
                  (day) =>
                      viewModel.selectedDay != null &&
                      isSameDay(day, viewModel.selectedDay),
              onDaySelected:
                  (selectedDay, focusedDay) => viewModel.selectDay(selectedDay),
              calendarBuilders: CalendarBuilders(
                defaultBuilder:
                    (context, day, focusedDay) =>
                        DayCell(day: day, isSelected: false, isToday: false),
                selectedBuilder:
                    (context, day, focusedDay) =>
                        DayCell(day: day, isSelected: true, isToday: false),
                todayBuilder:
                    (context, day, focusedDay) =>
                        DayCell(day: day, isSelected: false, isToday: true),
              ),
              onPageChanged: (focusedDay) {
                viewModel.updateFocusedDay(focusedDay);
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: '月',
                // CalendarFormat.week: '周', // TODO: 周视图有BUG不能切换
              },
              calendarStyle: const CalendarStyle(outsideDaysVisible: false),
              rowHeight: 100,
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: _FloatingActionButton(),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context);
    final today = DateTime.now();

    final boxWidth = 70.0;
    final boxHeight = 70.0;
    final iconSize = 37.0;

    // 如果没有选择今天，显示"今"按钮
    if (viewModel.selectedDay == null ||
        !viewModel.isToday(viewModel.selectedDay!)) {
      return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: FloatingActionButton(
          onPressed: () => viewModel.selectToday(),
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
          shape: const CircleBorder(),
          child: Icon(Icons.reply, color: Colors.blueAccent, size: iconSize),
        ),
      );
    }

    // 如果选择了今天，显示添加/删除按钮
    final currentPeriod = viewModel.getCurrentTimePeriod();
    final isRecorded = viewModel.isRecorded(today, currentPeriod);

    return SizedBox(
      width: boxWidth,
      height: boxHeight,
      child: FloatingActionButton(
        onPressed: () => viewModel.toggleRecord(),
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
