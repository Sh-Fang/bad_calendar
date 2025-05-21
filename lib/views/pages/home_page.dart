// lib/views/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../view_models/home_view_model.dart';
import 'calendar_page.dart';
import 'statistics_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Widget> _pages = const [CalendarPage(), StatisticPage()];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final currentIndex = viewModel.currentIndex;

    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '日历',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: '统计'),
        ],
        onTap: (index) {
          HapticFeedback.selectionClick();
          viewModel.setIndex(index);
        },
      ),
    );
  }
}
