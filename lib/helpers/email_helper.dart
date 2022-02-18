import 'package:url_launcher/url_launcher.dart';

class EmailHelper {
  static const String email = "help@kingit.com";

  static Future<void> launchEmail() async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }
}
