import 'package:fluttertoast/fluttertoast.dart';

class AppAlert {
  AppAlert(String s);

  static void showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 12.0,
    );
  }
  
}
