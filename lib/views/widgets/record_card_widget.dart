// lib/views/widgets/record_card.dart
import 'package:flutter/material.dart';
import 'package:bad_calendar/models/time_period_model.dart';
import 'package:flutter/services.dart';

class RecordCard extends StatelessWidget {
  final DateTime date;
  final Set<TimePeriodModel> periods;
  final void Function(TimePeriodModel period) onDeletePeriod; // 新增回调

  const RecordCard({
    super.key,
    required this.date,
    required this.periods,
    required this.onDeletePeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showDeleteDialog(context);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          leading: const Icon(Icons.sell, color: Colors.blueAccent),
          title: Text(
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: periods.map((p) => periodToIcon(p)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    TimePeriodModel? selected;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('删除 ${date.year}-${date.month}-${date.day} 的记录'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    periods.map((p) {
                      return RadioListTile<TimePeriodModel>(
                        title: periodToIcon(p),
                        value: p,
                        groupValue: selected,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            selected = val;
                          });
                        },
                      );
                    }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed:
                      selected == null
                          ? null
                          : () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            onDeletePeriod(selected!); // 调用删除逻辑
                          },
                  child: const Text('删除'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
