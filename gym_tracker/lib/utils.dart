import 'package:flutter/material.dart';

class Utils {
  static String getShortDayName(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Unknown';
    }
  }

  static String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  static int getMonthNumber(String month) {
    switch (month) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
        return 6;
      case 'Jul':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 0;
    }
  }

  static String getDate(DateTime date) {
    return "${Utils.getDayName(date.weekday)}, ${date.day} ${Utils.getMonthName(date.month)} ${date.year}";
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Unknown';
    }
  }

  static Color getActivityColor(String category) {
    switch (category) {
      case 'Abs':
        return Colors.blue;
      case 'Arms':
        return Colors.red;
      case 'Back':
        return Colors.brown;
      case 'Calves':
        return Colors.purple;
      case 'Cardio':
        return Colors.lightGreen;
      case 'Chest':
        return Colors.orange;
      case 'Legs':
        return Colors.amber;
      case 'Shoulders':
        return Colors.teal;

      case 'Basketball':
        return Colors.orange;
      case 'Tennis':
        return Colors.yellow;
      case 'Padel':
        return Colors.green;
      case 'Yoga':
        return Colors.orange;
      case 'Pilates':
        return Colors.yellow;
      case 'Hiit':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
