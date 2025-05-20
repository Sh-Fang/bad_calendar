// lib/views/calendar_page.dart
import 'package:bad_calendar/views/widgets/day_cell.dart';
import 'package:bad_calendar/views/widgets/record_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../view_models/habit_view_model.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitViewModel()..loadAll(),
      child: const _CalendarPageContent(),
    );
  }
}

class _CalendarPageContent extends StatelessWidget {
  const _CalendarPageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bad Calendar')),
      body: Column(
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
              viewModel.setSelectedDay(selectedDay);
            },

            onPageChanged: (focusedDay) {
              viewModel.setFocusedDay(focusedDay);
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

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: RecordToggleButton(),
      ),
    );
  }
}
