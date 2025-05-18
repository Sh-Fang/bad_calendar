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
      appBar: AppBar(title: const Text('坏习惯时间段记录')),
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
              onDaySelected: (selectedDay, focusedDay) {
                viewModel.selectDay(selectedDay);
              },
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
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableCalendarFormats: const {CalendarFormat.month: '月'},
              rowHeight: 60,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final viewModel = context.read<CalendarViewModel>();
                if (viewModel.selectedDay == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('请先选择日期')));
                  return;
                }

                if (!viewModel.isToday(viewModel.selectedDay!)) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('只能记录当天时间段')));
                  return;
                }

                viewModel.toggleRecord();
              },
              child: const Text('记录当前时间段'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => viewModel.selectToday(),
              icon: const Icon(Icons.calendar_today),
              label: const Text('回到今天'),
            ),
            const SizedBox(height: 20),
            if (viewModel.selectedDay != null)
              Text(
                '选择日期：${viewModel.selectedDay!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: _FloatingActionButton(),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalendarViewModel>(context);
    final today = DateTime.now();

    // 如果没有选择今天，显示"今"按钮
    if (viewModel.selectedDay == null ||
        !viewModel.isToday(viewModel.selectedDay!)) {
      return FloatingActionButton(
        onPressed: () => viewModel.selectToday(),
        child: const Text('今'),
      );
    }

    // 如果选择了今天，显示添加/删除按钮
    final currentPeriod = viewModel.getCurrentTimePeriod();
    final isRecorded = viewModel.isRecorded(today, currentPeriod);

    return FloatingActionButton(
      onPressed: () => viewModel.toggleRecord(),
      backgroundColor: isRecorded ? Colors.red : Colors.blue,
      tooltip: isRecorded ? '删除记录' : '记录当前时间段',
      child: Icon(isRecorded ? Icons.remove_circle : Icons.add_circle),
    );
  }
}
