import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NavbarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback callback;

  const NavbarIconButton({Key? key, required this.icon, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback,
      icon: Icon(
        icon,
        size: SizerUtil.deviceType == DeviceType.mobile ? 18.sp : 11.sp,
        color: Colors.white,
      ),
    );
  }
}
