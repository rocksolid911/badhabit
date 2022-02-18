import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const primaryBlackColor = Color(0xFF0A0B49);
const primaryGreyColor = Color(0xFF202020);
const primaryDialogBackgroundColor = Color(0xFF252525);
const primaryPinkColor = Color(0xFFF56F83);
const primaryPurpleColor = Color(0xFFA59DE8);
const primaryRedColor = Color(0xF2FF1953);
const primaryGreenColor = Colors.lightGreen;

const MaterialColor materialDarkGreyColor = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

final mainTextStyle = TextStyle(
  fontFamily: 'ProximaNovaBold',
  color: Colors.white,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.4,
  fontSize: SizerUtil.deviceType == DeviceType.mobile ? 17.sp : 15.sp,
);

void showDeleteDialog(
    BuildContext context, String message, Function deleteCallback) {
  try {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: primaryDialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: EdgeInsets.fromLTRB(
              SizerUtil.deviceType == DeviceType.mobile ? 15.0 : 30.0,
              15.0,
              15.0,
              0),
          contentPadding: EdgeInsets.fromLTRB(
              SizerUtil.deviceType == DeviceType.mobile ? 10.0 : 25.0,
              10.0,
              10.0,
              0),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: primaryRedColor,
                size: SizerUtil.deviceType == DeviceType.mobile ? 16.sp : 10.sp,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Confirmation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 16.sp
                        : 10.sp,
                  ),
                ),
              )
            ],
          ),
          content: AspectRatio(
            aspectRatio: SizerUtil.deviceType == DeviceType.mobile ? 4 : 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 13.5.sp
                        : 8.sp,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.black12),
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: Text(
                ' Cancel ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 8.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.black12),
                backgroundColor: MaterialStateProperty.all(primaryRedColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                deleteCallback();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                ' Delete ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
