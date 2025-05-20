// lib/models/time_period.dart
import 'package:flutter/material.dart';

enum TimePeriod { morning, noon, afternoon, evening }

Widget periodToIcon(TimePeriod period) {
  switch (period) {
    case TimePeriod.morning:
      return _buildIconText(Icons.wb_sunny, '早上', Colors.green);
    case TimePeriod.noon:
      return _buildIconText(Icons.lunch_dining, '中午', Colors.orange);
    case TimePeriod.afternoon:
      return _buildIconText(Icons.wb_cloudy, '下午', Colors.blue);
    case TimePeriod.evening:
      return _buildIconText(Icons.nightlight_round, '晚上', Colors.deepPurple);
  }
}

Widget _buildIconText(IconData icon, String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: color)),
    ],
  );
}
