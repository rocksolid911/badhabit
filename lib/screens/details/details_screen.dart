import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/constants.dart';
import 'package:badhabit/database/habits_database.dart';
import 'package:badhabit/models/habit.dart';
import 'package:badhabit/models/history_item.dart';
import 'package:badhabit/models/history_item_type.dart';
import 'package:badhabit/screens/components/bottom_ad_banner.dart';
import 'package:badhabit/screens/details/components/details_screen_body.dart';
import 'package:badhabit/screens/edit/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  final Habit? habit;

  const DetailsScreen({
    Key? key,
    required this.id,
    this.habit,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Habit? habit;

  @override
  void initState() {
    habit = widget.habit;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryBlackColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 50, 5, 0),
        child: habit != null
            ? DetailsScreenBody(
                habit: habit!,
                relapseCallback: _relapseCallback,
                editCallback: _editCallback,
                updateRecordCallback: _updateRecordCallback,
                addCommentCallback: _addCommentCallback,
              )
            : FutureBuilder(
                future: HabitsDatabase.instance.getById(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    habit = snapshot.data as Habit;
                    return DetailsScreenBody(
                      habit: habit!,
                      relapseCallback: _relapseCallback,
                      editCallback: _editCallback,
                      updateRecordCallback: _updateRecordCallback,
                      addCommentCallback: _addCommentCallback,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
      ),
      bottomNavigationBar: BottomAdBanner(
        screen: Screen.details,
        screenWidth: MediaQuery.of(context).size.width.toInt(),
      ),
    );
  }

  void _relapseCallback() async {
    HapticFeedback.vibrate();

    final relapse = await showYesNoDialog(
      context,
      'Do you really want to start your Journey from the beginning?',
      primaryRedColor,
      primaryGreenColor,
    );

    if (relapse == null || !relapse) return;

    bool? hasComment;
    String? comment;

    do {
      hasComment = await showYesNoDialog(
        context,
        'Would you like to add a comment?\n (Reasons, feelings, mood)',
        primaryGreenColor,
        primaryRedColor,
      );

      if (hasComment == null || !hasComment) break;

      comment = await showCommentDialog(context);
    } while (hasComment && comment == null);

    final now = DateTime.now();

    final updatedHabit = Habit(
      habit!.name,
      now,
      habit!.color,
      habit!.record,
      habit!.recordAttempt,
      habit!.attempt + 1,
      id: habit!.id,
    );

    await HabitsDatabase.instance.update(updatedHabit);

    final differenceInDays = DateTime.now().difference(habit!.dateTime).inDays;

    comment = comment == null ? '' : '\n$comment';

    final daysMessage = differenceInDays == 1 ? 'day' : 'days';

    var relapseComment =
        'Streak before relapse - $differenceInDays $daysMessage.' + comment;

    final historyItem = HistoryItem(
      HistoryItemType.relapse,
      now,
      relapseComment,
      updatedHabit.id!,
    );

    await HabitsDatabase.instance.insertHistoryItem(historyItem);

    setState(() {
      habit = updatedHabit;
    });
  }

  void _addCommentCallback() async {
    final comment = await showCommentDialog(context);

    if (comment == null || comment.isEmpty) return;

    final historyItem = HistoryItem(
      HistoryItemType.comment,
      DateTime.now(),
      comment,
      habit!.id!,
    );

    await HabitsDatabase.instance.insertHistoryItem(historyItem);

    setState(() {});
  }

  void _updateRecordCallback(int newRecord) async {
    if (habit!.recordAttempt < habit!.attempt) {
      var recordComment = 'New record! Previous - ${habit!.record} days.';

      if (habit!.record == 0) {
        recordComment = 'New record!';
      }

      if (habit!.record == 1) {
        recordComment = 'New record! Previous - ${habit!.record} day.';
      }

      final historyItem = HistoryItem(
        HistoryItemType.newRecord,
        DateTime.now(),
        recordComment,
        habit!.id!,
      );

      await HabitsDatabase.instance.insertHistoryItem(historyItem);
    }

    final updatedHabit = Habit(
      habit!.name,
      habit!.dateTime,
      habit!.color,
      newRecord,
      habit!.attempt,
      habit!.attempt,
      id: habit!.id,
    );

    await HabitsDatabase.instance.update(updatedHabit);

    setState(() {
      habit = updatedHabit;
    });
  }

  void _editCallback() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditScreen(habit: habit),
      ),
    );

    setState(() {
      habit = result;
    });
  }

  Future<bool?> showYesNoDialog(BuildContext context, String message,
      Color yesColor, Color noColor) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: primaryDialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.fromLTRB(
              SizerUtil.deviceType == DeviceType.mobile ? 10.0 : 25.0,
              15.0,
              10.0,
              10),
          content: AspectRatio(
            aspectRatio: SizerUtil.deviceType == DeviceType.mobile ? 4 : 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AutoSizeText(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 15.sp
                        : 10.sp,
                  ),
                  maxLines: 3,
                ),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.black12),
                backgroundColor: MaterialStateProperty.all(yesColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.black12),
                backgroundColor: MaterialStateProperty.all(noColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 8.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> showCommentDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        var comment = '';
        return AlertDialog(
          backgroundColor: primaryDialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: EdgeInsets.fromLTRB(
              SizerUtil.deviceType == DeviceType.mobile ? 15.0 : 30.0,
              15.0,
              15.0,
              0),
          contentPadding: EdgeInsets.fromLTRB(
              SizerUtil.deviceType == DeviceType.mobile ? 10.0 : 25.0,
              10.0,
              10.0,
              0),
          title: Row(
            children: [
              Icon(
                LineIcons.comment,
                color: primaryRedColor,
                size: SizerUtil.deviceType == DeviceType.mobile ? 16.sp : 10.sp,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Comment',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 16.sp
                          : 10.sp,
                      color: Colors.white),
                ),
              )
            ],
          ),
          content: AspectRatio(
            aspectRatio: SizerUtil.deviceType == DeviceType.mobile ? 3 : 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                cursorColor: Colors.white,
                autovalidateMode: AutovalidateMode.always,
                autofocus: true,
                style: TextStyle(
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 10.sp,
                  color: Colors.white,
                ),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  // errorStyle: TextStyle(
                  //   fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 8.sp,
                  //   color: Colors.black,
                  // ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: primaryRedColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: primaryRedColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                initialValue: comment,
                validator: _validateComment,
                onChanged: (input) => comment = input,
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.black12),
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: Text(
                ' Cancel ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 8.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.black12),
                backgroundColor: MaterialStateProperty.all(primaryGreenColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                final errorMessage = _validateComment(comment);
                if (errorMessage == null) {
                  Navigator.pop(context, comment.trim());
                }
              },
              child: Text(
                ' Save ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String? _validateComment(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Please, enter comment';
    }

    if (value.length > 250) {
      return 'Too long comment';
    }

    return null;
  }
}
