import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/constants.dart';
import 'package:badhabit/database/habits_database.dart';
import 'package:badhabit/models/habit.dart';
import 'package:badhabit/models/history_item.dart';
import 'package:badhabit/models/history_item_type.dart';
import 'package:badhabit/screens/components/bottom_ad_banner.dart';
import 'package:badhabit/screens/components/navbar_icon_button.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class EditScreen extends StatefulWidget {
  final Habit? habit;

  const EditScreen({Key? key, this.habit}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _dateFormat = DateFormat('dd MMMM yyyy,');
  String? _name;
  late DateTime _date;
  TimeOfDay? _time;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  int _selectedColor = primaryRedColor.value;
  bool _isFirstLoad = true;

  final List<int> colors = [
    primaryRedColor.value, // red
    Colors.orange.value,
    Colors.yellowAccent.value,
    Colors.lightGreenAccent.value,
    Colors.tealAccent.value,
    Colors.blueAccent.value,
    Colors.purpleAccent.value,
  ];

  FToast? fToast;

  @override
  void initState() {
    super.initState();

    _selectedColor = widget.habit?.color ?? primaryRedColor.value;
    _name = widget.habit?.name;
    _date = widget.habit?.dateTime ?? DateTime.now();

    _dateController.text = _dateFormat.format(_date).toString();

    fToast = FToast();
    fToast!.init(context);
  }

  Future _openDateTimePicker() async {
    await _handleDatePicker();
    await _handleTimePicker();
  }

  Future _handleDatePicker() async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();

    final firstDate = DateTime(1970);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final initialDate = _date;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate.isBefore(firstDate) ? initialDate : firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
      });

      _dateController.text = _dateFormat.format(_date).toString();
    }
  }

  Future _handleTimePicker() async {
    FocusScope.of(context).unfocus();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _time!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlackColor,
              onSurface: Color(0xFF505050),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _time) {
      setState(() {
        _time = pickedTime;
      });

      _timeController.text = _time!.format(context).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLoad) {
      _time = TimeOfDay.fromDateTime(_date);
      _timeController.text = _time!.format(context).toString();

      _isFirstLoad = false;
    }

    return GestureDetector(
      onTap: _unFocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: primaryBlackColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: 'Back',
                      child: NavbarIconButton(
                        icon: Icons.arrow_back_ios,
                        callback: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        height: SizerUtil.deviceType == DeviceType.mobile
                            ? 20.h
                            : 25.h,
                        child: Image.asset('assets/images/tree_logo.png'),
                      ),
                    ),
                  ],
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Start a new Life without',
                        style: mainTextStyle,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height:
                            SizerUtil.deviceType == DeviceType.mobile ? 50 : 65,
                        child: TextFormField(
                          initialValue: _name,
                          validator: _validateTitle,
                          onChanged: (input) => _name = input,
                          style: TextStyle(
                            color: Color(_selectedColor),
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 18.sp
                                : 14.sp,
                          ),
                          cursorColor: Colors.white,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              LineIcons.pen,
                              color: Colors.white,
                            ),
                            errorStyle: const TextStyle(height: 0),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintText: 'Enter habit name',
                            hintStyle: TextStyle(
                              color: Color(_selectedColor),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 18.sp
                                      : 14.sp,
                            ),
                          ),
                        ),
                      ),
                      if (widget.habit == null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            AutoSizeText(
                              'A new Life starts from',
                              style: mainTextStyle,
                              maxLines: 1,
                            ),
                            GestureDetector(
                              onTap: _openDateTimePicker,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      '${_dateFormat.format(_date).toString()} ${_time!.format(context).toString()}',
                                      style: TextStyle(
                                        color: Color(_selectedColor),
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.mobile
                                            ? 18.sp
                                            : 14.sp,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: 1,
                                    icon: const Icon(
                                      LineIcons.pen,
                                      color: Colors.white,
                                    ),
                                    onPressed: _openDateTimePicker,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      AutoSizeText(
                        'Choose appropriate color',
                        style: mainTextStyle,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      _buildColorDotRow(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    height:
                        SizerUtil.deviceType == DeviceType.mobile ? 6.5.h : 5.h,
                    width: 150,
                    child: TextButton(
                      onPressed: _save,
                      child: Text(
                        'GO!',
                        style: TextStyle(
                          fontFamily: 'ProximaNovaBold',
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 18.sp
                              : 9.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.white12),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.grey.withOpacity(0.20)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                SizerUtil.deviceType == DeviceType.mobile
                                    ? BorderRadius.circular(25)
                                    : BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAdBanner(
          screen: Screen.edit,
          screenWidth: MediaQuery.of(context).size.width.toInt(),
        ),
      ),
    );
  }

  Widget _buildColorDotRow() {
    final dots = <Widget>[];
    for (var element in colors) {
      dots.add(_buildColorDot(element));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dots,
    );
  }

  Widget _buildColorDot(int color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: SizerUtil.deviceType == DeviceType.mobile ? 10.5.w : 10.w,
        height: SizerUtil.deviceType == DeviceType.mobile ? 10.5.w : 10.w,
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _selectedColor == color
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '✓',
                    style: TextStyle(
                      color: primaryBlackColor,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 22.sp
                          : 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                )
              : const Text(''),
        ),
      ),
    );
  }

  Future _save() async {
    String? validationMessage = _validate();

    if (validationMessage == null) {
      DateTime newDate;
      newDate = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time!.hour,
        _time!.minute,
        DateTime.now().second,
      );

      if (widget.habit != null) {
        final habit = Habit(
          _name!,
          widget.habit!.dateTime,
          _selectedColor,
          widget.habit!.record,
          widget.habit!.recordAttempt,
          widget.habit!.attempt,
          id: widget.habit?.id,
        );

        await HabitsDatabase.instance.update(habit);

        Navigator.of(context).pop(habit);
      } else {
        final habit = Habit(
          _name!,
          newDate,
          _selectedColor,
          0,
          0,
          1,
        );

        int habitId = await HabitsDatabase.instance.insert(habit);

        final historyItem = HistoryItem(
          HistoryItemType.beginningOfJourney,
          DateTime.now(),
          'The Date of the Beginning:\n${_dateFormat.format(_date).toString()} ${_time!.format(context).toString()}',
          habitId,
        );

        await HabitsDatabase.instance.insertHistoryItem(historyItem);

        habit.id = habitId;

        Navigator.of(context).pop(habit);
      }
    } else {
      _showErrorToast(validationMessage);
    }
  }

  String? _validate() {
    var result = _validateTitle(_name);
    if (result != null) {
      return result;
    }

    result = _validateDate(_date);
    if (result != null) {
      return result;
    }

    result = _validateTime(_time);
    if (result != null) {
      return result;
    }

    return null;
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Please, enter habit name';
    }

    if (value.length > 50) {
      return 'Too long habit name';
    }

    return null;
  }

  String? _validateDate(DateTime? value) {
    if (value == null) {
      return 'Please, choose date';
    }

    return null;
  }

  String? _validateTime(TimeOfDay? value) {
    if (value == null) {
      return 'Please, choose time';
    }

    return null;
  }

  void _showErrorToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
    );

    fToast!.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 1),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: 150,
          left: 0,
          right: 0,
        );
      },
    );
  }

  void _unFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }
}
