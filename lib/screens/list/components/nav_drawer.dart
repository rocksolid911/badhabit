import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/constants.dart';
import 'package:badhabit/helpers/email_helper.dart';
import 'package:badhabit/screens/list/components/nav_drawer_list_tile.dart';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class NavDrawer extends StatelessWidget {
  final InAppReview _inAppReview = InAppReview.instance;
  final VoidCallback closeCallback;

  NavDrawer({Key? key, required this.closeCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBlackColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              SizedBox(
                child: Image.asset('assets/images/tree_logo.png'),
                width: SizerUtil.deviceType == DeviceType.mobile ? 28.w : 20.w,
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                'Bad Habit Break',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 15.sp : 12.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(
                  height: SizerUtil.deviceType == DeviceType.mobile ? 30 : 60),
            ],
          ),
          NavDrawerListTile(
            iconData: Icons.list,
            iconColor: const Color(0xCBFF1953),
            label: 'Home',
            onTap: closeCallback,
          ),
          NavDrawerListTile(
            iconData: Icons.star_rate,
            iconColor: Colors.yellowAccent,
            label: 'Rate App',
            onTap: () async => {
              await _inAppReview.openStoreListing(),
            },
          ),
          NavDrawerListTile(
            iconData: Icons.share,
            iconColor: const Color(0xFFFF6F00),
            label: 'Share App',
            onTap: () async => {
              await Share.share('https://play.google.com/'),
            },
          ),
          NavDrawerListTile(
            iconData: Icons.help,
            iconColor: Colors.purpleAccent,
            label: 'Help & Feedback',
            onTap: () async => {
              await EmailHelper.launchEmail(),
            },
          ),
        ],
      ),
    );
  }
}
