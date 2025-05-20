// lib/views/pages/calendar_page.dart
import 'package:bad_calendar/views/widgets/day_cell.dart';
import 'package:bad_calendar/views/widgets/record_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../view_models/habit_view_model.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                16.0,
                0.0,
                16.0,
              ), // 左 上 右 下
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${viewModel.focusedDay.year} / ${viewModel.focusedDay.month}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCalendar(
              headerVisible: false,

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

              startingDayOfWeek: StartingDayOfWeek.monday,

              calendarStyle: const CalendarStyle(outsideDaysVisible: false),

              rowHeight: 100,
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: RecordToggleButton(),
      ),
    );
  }
}
