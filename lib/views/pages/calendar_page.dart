// lib/views/pages/calendar_page.dart
import 'package:bad_calendar/views/widgets/add_record_button.dart';
import 'package:bad_calendar/views/widgets/day_cell_widget.dart';
import 'package:bad_calendar/views/widgets/record_toggle_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../view_models/habit_view_model.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${viewModel.focusedDay.year} / ${viewModel.focusedDay.month}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AddRecordButton(day: viewModel.focusedDay),
                ],
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
                HapticFeedback.lightImpact();
                viewModel.setSelectedDay(selectedDay);
              },

              onPageChanged: (focusedDay) {
                viewModel.setFocusedDay(focusedDay);
              },

              calendarBuilders: CalendarBuilders(
                defaultBuilder:
                    (context, day, focusedDay) => DayCellWidget(
                      day: day,
                      isSelected: false,
                      isToday: false,
                    ),
                selectedBuilder:
                    (context, day, focusedDay) => DayCellWidget(
                      day: day,
                      isSelected: true,
                      isToday: false,
                    ),
                todayBuilder:
                    (context, day, focusedDay) => DayCellWidget(
                      day: day,
                      isSelected: false,
                      isToday: true,
                    ),
              ),

              startingDayOfWeek: StartingDayOfWeek.monday,

              calendarStyle: const CalendarStyle(outsideDaysVisible: false),

              rowHeight: MediaQuery.of(context).size.height < 700 ? 60 : 100,
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: RecordToggleFloatingButton(),
      ),
    );
  }
}
