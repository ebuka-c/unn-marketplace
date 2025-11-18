import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

/// type: 1 = Success, 2 = Warning, Null = Error

void appSnackBar(
  BuildContext context, {
  required String message,
  int? type,
  int duration = 4,
}) {
  Flushbar(
    backgroundColor: getSnackColor(type),
    messageColor: Colors.white,
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration),
    margin: EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(9),
    icon: Icon(getSnackIcon(type), size: 28.0, color: Colors.white),
  ).show(context);
}

Color getSnackColor(int? value) {
  switch (value) {
    case 1:
      return Colors.green;
    case 2:
      return const Color.fromARGB(255, 198, 121, 5);
    default:
      return Colors.red;
  }
}

IconData getSnackIcon(int? value) {
  switch (value) {
    case 1:
      return Icons.done;
    case 2:
      return Icons.warning_amber_rounded;
    default:
      return Icons.info_outline;
  }
}

//APP EXIT SNACKBAR
// exitAppSnackbar(BuildContext context) {
//   return Flushbar(
//     message: 'Press again to exit',
//     duration: Duration(seconds: 2),
//     margin: EdgeInsets.all(8),
//     borderRadius: BorderRadius.circular(8),
//     flushbarPosition: FlushbarPosition.TOP,
//   ).show(context);
// }
