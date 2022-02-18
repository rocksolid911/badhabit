import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HistoryListTileWithSubtitle extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback deleteCallback;

  const HistoryListTileWithSubtitle({
    Key? key,
    required this.iconData,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.symmetric(
        vertical: SizerUtil.deviceType == DeviceType.mobile ? 5.0 : 10.0,
        horizontal: SizerUtil.deviceType == DeviceType.mobile ? 0.0 : 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: SizerUtil.deviceType == DeviceType.mobile
            ? BorderRadius.circular(15)
            : BorderRadius.circular(25),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: SizerUtil.deviceType == DeviceType.mobile ? 10 : 20,
        //minVerticalPadding: 0,
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.only(left: 10),
        leading: Icon(
          iconData,
          color: color,
          size: SizerUtil.deviceType == DeviceType.mobile ? 23.sp : 14.sp,
        ),
        title: AutoSizeText(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 9.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ],
          ),
          maxLines: 1,
        ),
        subtitle: AutoSizeText(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 6.5.sp,
            letterSpacing: 0.2,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ],
          ),
          maxLines: 10,
        ),
        trailing: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: deleteCallback,
        ),
      ),
    );
  }
}
