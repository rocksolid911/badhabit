import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/screens/details/components/relapse_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsSection extends StatelessWidget {
  final Color color;
  final int attempt;
  final int record;
  final VoidCallback relapseCallback;

  const StatsSection({
    Key? key,
    required this.color,
    required this.attempt,
    required this.record,
    required this.relapseCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              AutoSizeText(
                'Attempt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 15.sp : 9.sp,
                ),
                maxLines: 1,
              ),
              AutoSizeText(
                '$attempt',
                style: TextStyle(
                  color: color,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 17.sp : 11.sp,
                  fontFamily: 'ProximaNovaBold',
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        Expanded(child: RelapseButton(callback: relapseCallback)),
        Expanded(
          child: Column(
            children: [
              AutoSizeText(
                'Record',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 15.sp : 9.sp,
                ),
                maxLines: 1,
              ),
              AutoSizeText.rich(
                TextSpan(
                  text: '$record',
                  children: [
                    TextSpan(
                      text: record == 1 ? ' Day' : ' Days',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 9.sp
                            : 7.sp,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: color,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 17.sp : 11.sp,
                  fontFamily: 'ProximaNovaBold',
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
