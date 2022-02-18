import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NavDrawerListTile extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const NavDrawerListTile({
    Key? key,
    required this.iconData,
    required this.iconColor,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: SizerUtil.deviceType == DeviceType.mobile ? 10 : 1.h + 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: SizerUtil.deviceType == DeviceType.mobile
              ? BorderRadius.circular(15)
              : BorderRadius.circular(20),
        ),
        padding:
            SizerUtil.deviceType == DeviceType.mobile ? EdgeInsets.zero : const EdgeInsets.all(10),
        child: ListTile(
          minLeadingWidth: 0,
          dense: true,
          leading: Icon(
            iconData,
            color: iconColor,
            size: SizerUtil.deviceType == DeviceType.mobile ? 20.sp : 14.sp,
          ),
          title: AutoSizeText(
            label,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 10.sp,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
