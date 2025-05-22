import 'package:bad_calendar/view_models/habit_view_model.dart';
import 'package:bad_calendar/views/widgets/grouped_record_list.dart';
import 'package:bad_calendar/views/widgets/summary_card.dart';
import 'package:bad_calendar/views/widgets/about_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          '统计记录',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 26.0),
            child: AboutButton(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryCard(viewModel: viewModel),
            const SizedBox(height: 12),
            GroupedRecordList(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
