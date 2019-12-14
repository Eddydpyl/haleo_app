import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtility {
  static String currentDate() {
    DateTime dateTime = DateTime.now().toUtc();
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return format.format(dateTime) + "Z";
  }

  static DateTime parseDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime;
  }

  static String formatFullDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return dateTime.day.toString().padLeft(2, '0') + "-"
        + dateTime.month.toString().padLeft(2, '0') + "-"
        + dateTime.year.toString().substring(2,4).padLeft(2, '0') + "  "
        + dateTime.hour.toString().padLeft(2, '0') + ":"
        + dateTime.minute.toString().padLeft(2, '0');
  }

  static String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return dateTime.day.toString().padLeft(2, '0') + "-"
        + dateTime.month.toString().padLeft(2, '0') + "-"
        + dateTime.year.toString().substring(2,4).padLeft(2, '0');
  }

  static String formatTime(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return dateTime.hour.toString().padLeft(2, '0') + ":"
        + dateTime.minute.toString().padLeft(2, '0') + ":"
        + dateTime.second.toString().padLeft(2, '0');
  }
}

class SnackBarUtility {
  static show(BuildContext context, String text) {
    ScaffoldState scaffold = Scaffold.of(context);
    scaffold.removeCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  static remove(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);
    scaffold.removeCurrentSnackBar();
  }
}