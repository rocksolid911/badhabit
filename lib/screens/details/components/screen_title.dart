import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 2),
      child: AutoSizeText(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'ProximaNovaBold',
          color: Colors.white,
          fontSize: SizerUtil.deviceType == DeviceType.mobile ? 20.sp : 12.5.sp,
          fontWeight: FontWeight.bold,
          fontFeatures: const [
            FontFeature.tabularFigures(),
          ],
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
    );
  }
}
