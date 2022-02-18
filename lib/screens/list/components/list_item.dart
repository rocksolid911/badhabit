import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/helpers/current_goal_helper.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

class ListItem extends StatelessWidget {
  final int attempt;
  final int record;
  final String title;
  final Color color;
  final Duration currentGoal;
  final double indicatorPercent;

  const ListItem({
    Key? key,
    required this.attempt,
    required this.record,
    required this.title,
    required this.color,
    required this.currentGoal,
    required this.indicatorPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstMessage = CurrentGoalHelper.getFirstMessage(currentGoal.inDays);
    String secondMessage =
        CurrentGoalHelper.getSecondMessage(currentGoal.inDays);

    return Container(
      padding: SizerUtil.deviceType == DeviceType.mobile
          ? const EdgeInsets.all(10.0)
          : const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
      height: SizerUtil.deviceType == DeviceType.mobile ? 102 : 150,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: SizerUtil.deviceType == DeviceType.mobile
            ? BorderRadius.circular(20)
            : BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            percent: indicatorPercent,
            lineWidth: SizerUtil.deviceType == DeviceType.mobile ? 9.sp : 6.sp,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: color,
            backgroundColor: Colors.grey.withOpacity(0.20),
            radius: SizerUtil.deviceType == DeviceType.mobile ? 60.sp : 40.sp,
            center: Padding(
              padding: EdgeInsets.all(
                  SizerUtil.deviceType == DeviceType.mobile ? 18 : 22),
              child: Image.asset('assets/images/tree_logo.png'),
            ),
          ),
          SizedBox(width: SizerUtil.deviceType == DeviceType.mobile ? 10 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    title,
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'ProximaNovaBold',
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 22
                          : 12.sp,
                    ),
                    maxLines: 2,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(
                              'Current goal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 12.sp
                                        : 7.sp,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText.rich(
                              TextSpan(text: firstMessage, children: [
                                TextSpan(
                                  text: secondMessage,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 7.sp
                                        : 6.sp,
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: color,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 14.sp
                                        : 9.sp,
                                fontFamily: 'ProximaNovaBold',
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(
                              'Attempt',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 12.sp
                                        : 7.sp,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              '$attempt',
                              style: TextStyle(
                                color: color,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 14.sp
                                        : 9.sp,
                                fontFamily: 'ProximaNovaBold',
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(
                              'Record',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 12.sp
                                        : 7.sp,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText.rich(
                              TextSpan(text: '$record', children: [
                                TextSpan(
                                  text: record == 1 ? ' Day' : ' Days',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 7.sp
                                        : 6.sp,
                                  ),
                                ),
                              ]),
                              style: TextStyle(
                                color: color,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 14.sp
                                        : 9.sp,
                                fontFamily: 'ProximaNovaBold',
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
