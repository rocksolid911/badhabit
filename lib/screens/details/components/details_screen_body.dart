import 'package:badhabit/constants.dart';
import 'package:badhabit/database/habits_database.dart';
import 'package:badhabit/models/habit.dart';
import 'package:badhabit/screens/details/components/history_section.dart';
import 'package:badhabit/screens/details/components/nav_section.dart';
import 'package:badhabit/screens/details/components/stats_section.dart';
import 'package:badhabit/screens/details/components/timer_section.dart';
import 'package:flutter/material.dart';

class DetailsScreenBody extends StatefulWidget {
  final Habit habit;
  final VoidCallback editCallback;
  final VoidCallback relapseCallback;
  final Function(int) updateRecordCallback;
  final VoidCallback addCommentCallback;

  const DetailsScreenBody({
    Key? key,
    required this.habit,
    required this.editCallback,
    required this.relapseCallback,
    required this.updateRecordCallback,
    required this.addCommentCallback,
  }) : super(key: key);

  @override
  State<DetailsScreenBody> createState() => _DetailsScreenBodyState();
}

class _DetailsScreenBodyState extends State<DetailsScreenBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavSection(
            screenTitle: widget.habit.name,
            editCallback: widget.editCallback,
            deleteCallback: _deleteCallback,
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          TimerSection(
            color: Color(widget.habit.color),
            dateTime: widget.habit.dateTime,
            record: widget.habit.record,
            updateRecordCallback: widget.updateRecordCallback,
          ),
          const SizedBox(height: 5),
          StatsSection(
            color: Color(widget.habit.color),
            attempt: widget.habit.attempt,
            record: widget.habit.record,
            relapseCallback: widget.relapseCallback,
          ),
          const SizedBox(height: 10),
          HistorySection(
            habitId: widget.habit.id!,
            color: Color(widget.habit.color),
            addCommentCallback: widget.addCommentCallback,
          ),
        ],
      ),
    );
  }

  void _deleteCallback() async {
    showDeleteDialog(
      context,
      'Are you sure you want to delete the habit? Please note that it cannot be recovered.',
      () async {
        // await NotificationHelper.deleteNotification(event.id!);
        await HabitsDatabase.instance.delete(widget.habit.id!);

        Navigator.of(context).pop();
      },
    );
  }
}
