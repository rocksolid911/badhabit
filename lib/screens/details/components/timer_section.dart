import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/helpers/current_goal_helper.dart';

import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

class TimerSection extends StatefulWidget {
  final Color color;
  final DateTime dateTime;
  final int record;
  final Function(int) updateRecordCallback;

  const TimerSection({
    Key? key,
    required this.color,
    required this.dateTime,
    required this.record,
    required this.updateRecordCallback,
  }) : super(key: key);

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  bool _isFirstLoad = true;

  Duration? currentGoal;
  Timer? _timer;
  int? _differenceInYears;
  int? _differenceInDays;
  int? _differenceInSecondsTotal;
  int? _differenceInHours;
  int? _differenceInMinutes;
  int? _differenceInSeconds;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        _updateDifference();
      },
    );
    super.initState();
  }

  _updateDifference() {
    setState(() {
      final difference = DateTime.now().difference(widget.dateTime);

      var tempDifferenceInSecondsTotal = difference.inSeconds;
      _differenceInSecondsTotal = difference.inSeconds;

      _differenceInYears = tempDifferenceInSecondsTotal ~/ 31536000;
      tempDifferenceInSecondsTotal = tempDifferenceInSecondsTotal % 31536000;
      _differenceInDays = tempDifferenceInSecondsTotal ~/ 86400;
      tempDifferenceInSecondsTotal = tempDifferenceInSecondsTotal % 86400;
      _differenceInHours = tempDifferenceInSecondsTotal ~/ 3600;
      tempDifferenceInSecondsTotal %= 3600;
      _differenceInMinutes = tempDifferenceInSecondsTotal ~/ 60;
      tempDifferenceInSecondsTotal %= 60;
      _differenceInSeconds = tempDifferenceInSecondsTotal;

      if (_differenceInSecondsTotal! >= 0) {
        final differenceInDaysTotal =
            _differenceInDays! + _differenceInYears! * 365;

        currentGoal = CurrentGoalHelper.getCurrentGoal(differenceInDaysTotal);

        if (differenceInDaysTotal > widget.record) {
          widget.updateRecordCallback(differenceInDaysTotal);
        }
      } else {
        currentGoal = CurrentGoalHelper.getCurrentGoal(0);
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  Widget _buildTimer() {
    var percent = _differenceInSecondsTotal! / currentGoal!.inSeconds;

    percent = percent > 1
        ? 1
        : percent < 0
            ? 0
            : percent;

    String firstMessage =
        CurrentGoalHelper.getFirstMessage(currentGoal!.inDays);
    String secondMessage =
        CurrentGoalHelper.getSecondMessage(currentGoal!.inDays);

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              CircularPercentIndicator(
                percent: percent,
                lineWidth:
                    SizerUtil.deviceType == DeviceType.mobile ? 15.sp : 12.sp,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: widget.color,
                backgroundColor: Colors.grey.withOpacity(0.20),
                radius:
                    SizerUtil.deviceType == DeviceType.mobile ? 160.sp : 120.sp,
                center: Padding(
                  padding: EdgeInsets.all(
                      SizerUtil.deviceType == DeviceType.mobile ? 25 : 40),
                  child: Image.asset('assets/images/tree_logo.png'),
                ),
              ),
              (_differenceInSecondsTotal! < 0)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Has not yet started',
                        style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 18.sp
                              : 13.sp,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                      ),
                    )
                  : Transform.scale(
                      child: _buildTime(),
                      scale: 0.5,
                    ),
            ],
          ),
        ),
        Positioned(
          top: 1,
          right: 1,
          child: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Column(
              children: [
                AutoSizeText(
                  'Current goal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 10.sp
                        : 8.sp,
                  ),
                ),
                AutoSizeText.rich(
                  TextSpan(text: firstMessage, children: [
                    TextSpan(
                      text: secondMessage,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 6.sp
                            : 6.sp,
                      ),
                    ),
                  ]),
                  style: TextStyle(
                    color: widget.color,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 12.sp
                        : 10.sp,
                    fontFamily: 'ProximaNovaBold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSection(String label, int difference) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
          child: AutoSizeText(
            label,
            style: TextStyle(
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 9.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
            maxLines: 1,
          ),
        ),
        AutoSizeText(
          difference.toString().padLeft(2, '0'),
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 40.sp : 30.sp,
            fontWeight: FontWeight.bold,
            color: widget.color,
            letterSpacing: 1,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return AutoSizeText(
      ':',
      style: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: SizerUtil.deviceType == DeviceType.mobile ? 40.sp : 30.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1,
      ),
      maxLines: 1,
    );
  }

  Widget _buildTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_differenceInYears! >= 1)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerSection('Years', _differenceInYears!),
              _buildSeparator(),
            ],
          ),
        _buildTimerSection('Days', _differenceInDays!),
        _buildSeparator(),
        _buildTimerSection('Hours', _differenceInHours!),
        _buildSeparator(),
        _buildTimerSection('Mins', _differenceInMinutes!),
        _buildSeparator(),
        _buildTimerSection('Secs', _differenceInSeconds!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLoad) {
      _updateDifference();

      _isFirstLoad = false;
    }

    return _buildTimer();
  }
}
