import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RelapseButton extends StatelessWidget {
  final VoidCallback callback;

  const RelapseButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizerUtil.deviceType == DeviceType.mobile ? 6.5.h : 5.h,
      width: 150,
      child: TextButton(
        onPressed: callback,
        child: Text(
          'Relapse',
          style: TextStyle(
            fontFamily: 'ProximaNovaBold',
            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 17.sp : 9.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.white12),
          backgroundColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.20)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: SizerUtil.deviceType == DeviceType.mobile
                  ? BorderRadius.circular(25)
                  : BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
