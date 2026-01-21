// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hourlynotes/presentation/themes.dart';
import 'package:intl/intl.dart';


class FlushBarHelper {
  BuildContext c;
  Flushbar? flush;
  FlushbarPosition? flushbarPosition;
  FlushBarHelper({
    required this.c,
    this.flush,
    this.flushbarPosition,
  });

  showFlushBar(
      String message,
      FlushBarType flushBarType,
      ) {
    flush = Flushbar(
      message: reduceStringLength(message),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      borderColor: flushBarType == FlushBarType.success
          ? primaryColor
          : const Color.fromARGB(255, 204, 65, 65),
      messageColor: Colors.black,
      //AppTheme.theme.colorScheme.background != Colors.white
      //           ? Colors.white
      //           :
      flushbarPosition: flushbarPosition ?? FlushbarPosition.BOTTOM,
      backgroundColor: lightBackground,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      margin: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(12),
      isDismissible: true,
      icon: flushBarType == FlushBarType.success
          ? const SizedBox(
        width: 24,
        height: 24,
        child: Icon(Icons.done_outline_rounded),
      )
          : const SizedBox(
        width: 24,
        height: 24,
        child: Icon(Icons.cancel),
      ),
      duration: const Duration(seconds: 4),
      mainButton: IconButton(
          onPressed: () {
            flush?.dismiss(true);
          },
          icon: Icon(
            Icons.clear,
            color: Colors.white,
            size: 18,
          )),
    )..show(c);
  }
}

String reduceStringLength(String str) {
  int maxLength =600;
  if (str.length > maxLength) {
    return str.substring(0, maxLength);
  }
  return str;
}
String formatDate(String dateString) {
  List<String> parts = dateString.split('-');
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);
  DateTime date = DateTime(year, month, day);

  return DateFormat('d MMM, y').format(date);
}

enum FlushBarType { error, success }
