import 'package:url_launcher/url_launcher.dart';

class EmailHelper {
  static const String email = "siddhant93.saraf@gmail.com";

  static Future<void> launchEmail() async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }
}
