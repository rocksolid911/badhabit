import 'package:badhabit/screens/components/navbar_icon_button.dart';
import 'package:badhabit/screens/details/components/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class NavSection extends StatelessWidget {
  final String screenTitle;
  final VoidCallback editCallback;
  final VoidCallback deleteCallback;

  const NavSection({
    Key? key,
    required this.screenTitle,
    required this.editCallback,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            message: 'Back',
            child: NavbarIconButton(
              icon: Icons.arrow_back_ios,
              callback: () => Navigator.pop(context),
            ),
          ),
          Expanded(child: ScreenTitle(title: screenTitle)),
          PopupMenuButton<ActionMenuItem>(
            tooltip: 'Menu',
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            //offset: const Offset(10, -100),
            color: const Color(0xFF181818),
            icon: Icon(
              LineIcons.verticalEllipsis,
              size: SizerUtil.deviceType == DeviceType.mobile ? 20.sp : 11.sp,
              color: Colors.white,
            ),
            onSelected: (value) {
              value.callback();
            },
            itemBuilder: (BuildContext context) {
              return <ActionMenuItem>[
                ActionMenuItem('Edit', editCallback),
                ActionMenuItem('Delete', deleteCallback)
              ].map((ActionMenuItem item) {
                return PopupMenuItem<ActionMenuItem>(
                  value: item,
                  child: ActionMenuItemWidget(label: item.title),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}

class ActionMenuItem {
  String title;
  VoidCallback callback;

  ActionMenuItem(this.title, this.callback);
}

class ActionMenuItemWidget extends StatelessWidget {
  final String label;

  const ActionMenuItemWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
