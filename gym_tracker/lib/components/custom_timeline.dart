import 'package:flutter/material.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/model/sports.dart';
import 'package:gym_tracker/model/train.dart';
import 'package:gym_tracker/utils.dart';

// ignore: must_be_immutable
class CustomDateTimeline extends StatefulWidget {
  final List<Train> trains;
  DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color selectedBackgroundColor;
  final Color selectedTextColor;
  final Color selectedSecondaryTextColor;
  final Color scheduledBorderColor;
  final Color todayBorderColor;
  final Color scheduledColor;
  final Color todayBackgroundColor;
  final Color backgroundColor;
  final Color todayTextColor;
  final Color todaySecondaryTextColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color scheduledTextColor;
  final Color scheduledSecondaryTextColor;

  CustomDateTimeline({
    Key? key,
    required this.trains,
    required this.selectedDate,
    required this.onDateSelected,
    required this.borderColor,
    required this.selectedBorderColor,
    required this.selectedBackgroundColor,
    required this.selectedTextColor,
    required this.selectedSecondaryTextColor,
    required this.todayBorderColor,
    required this.scheduledColor,
    required this.scheduledBorderColor,
    required this.todayBackgroundColor,
    required this.backgroundColor,
    required this.todayTextColor,
    required this.todaySecondaryTextColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.scheduledTextColor,
    required this.scheduledSecondaryTextColor,
  }) : super(key: key);

  @override
  State<CustomDateTimeline> createState() => _CustomDateTimelineState();
}

class _CustomDateTimelineState extends State<CustomDateTimeline> {
  String selectedMonth = Utils.getMonthName(DateTime.now().month);
  DateTime today = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 365 * 2));
  DateTime endDate = DateTime.now().add(const Duration(days: 365));

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  late ScrollController _scrollController;

  void scrollToToday() {
    double offset = (MediaQuery.of(context).size.width - 80) / 7 + 8;
    int difference = today.difference(startDate).inDays;
    double todayPosition = difference * offset;
    _scrollController.animateTo(
      todayPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollTo(DateTime date) {
    double offset = (MediaQuery.of(context).size.width - 80) / 7 + 8;

    int difference = date.difference(startDate).inDays;
    double position = difference * offset;
    _scrollController.jumpTo(position);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedDate.day == DateTime.now().day &&
          widget.selectedDate.month == DateTime.now().month &&
          widget.selectedDate.year == DateTime.now().year) {
        scrollToToday();
      } else {
        scrollTo(widget.selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateList = List.generate(
      endDate.difference(startDate).inDays,
      (index) => DateTime(startDate.year, startDate.month, startDate.day + index),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.selectedDate.day == DateTime.now().day &&
                  widget.selectedDate.month == DateTime.now().month &&
                  widget.selectedDate.year == DateTime.now().year)
                const SizedBox()
              else
                GestureDetector(
                  onTap: () {
                    scrollToToday();
                    widget.onDateSelected(DateTime.now());
                    selectedMonth = Utils.getMonthName(widget.selectedDate.month);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              DropdownButton(
                  items: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                      .map((String month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    int month = Utils.getMonthNumber(value);
                    widget.onDateSelected(DateTime(widget.selectedDate.year, month, 1));

                    selectedMonth = value;
                    scrollTo(DateTime(widget.selectedDate.year, month, 1));
                  },
                  value: selectedMonth),
            ],
          ),
        ),
        SizedBox(
          height: 71,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: dateList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DateTime date = dateList[index];
              bool isScheduled = widget.trains.any((workout) =>
                  workout.date.day == date.day &&
                  workout.date.month == date.month &&
                  workout.date.year == date.year &&
                  (workout.exercises.isNotEmpty || workout.sports.isNotEmpty || workout.classes.isNotEmpty));
              bool isToday = date.day == today.day && date.month == today.month && date.year == today.year;
              bool isSelected = date.day == widget.selectedDate.day &&
                  date.month == widget.selectedDate.month &&
                  date.year == widget.selectedDate.year;

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getShortDayName(date.weekday),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () => widget.onDateSelected(date),
                    child: Stack(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 80) / 7,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isScheduled
                                ? Colors.transparent
                                : isToday
                                    ? widget.todayBackgroundColor
                                    : widget.backgroundColor,
                            borderRadius: isSelected ? BorderRadius.circular(6) : BorderRadius.circular(6),
                            border: Border.all(
                              width: 2,
                              color: isSelected
                                  ? widget.selectedBorderColor
                                  : isToday
                                      ? widget.todayBorderColor
                                      : isScheduled
                                          ? widget.scheduledBorderColor
                                          : widget.borderColor,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    isSelected ? BorderRadius.circular(4) : BorderRadius.circular(4),
                                child: SizedBox(
                                  height: 53,
                                  child: Column(
                                    children: _buildCategoryProportionWidgets(date),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Utils.getMonthName(date.month),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isScheduled
                                                ? isToday
                                                    ? widget.todaySecondaryTextColor
                                                    : widget.scheduledSecondaryTextColor
                                                : isSelected
                                                    ? widget.selectedSecondaryTextColor
                                                    : isToday
                                                        ? widget.todaySecondaryTextColor
                                                        : widget.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isScheduled
                                            ? date.day == today.day &&
                                                    date.month == today.month &&
                                                    date.year == today.year
                                                ? widget.todayTextColor
                                                : widget.scheduledTextColor
                                            : isSelected
                                                ? widget.selectedTextColor
                                                : isToday
                                                    ? widget.todayTextColor
                                                    : widget.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryProportionWidgets(DateTime date) {
    // Assuming you have a method to calculate the proportions

    Map<String, double> proportions = _calculateCategoryProportionsForDate(date);

    List<Widget> widgets = [];
    proportions.forEach((category, proportion) {
      widgets.add(
        Expanded(
          flex: (proportion * 100).toInt(),
          child: Container(
            color: Utils.getActivityColor(category),
          ),
        ),
      );
    });

    return widgets;
  }

  Map<String, double> _calculateCategoryProportionsForDate(DateTime date) {
    List<dynamic> allActivities = [];
    List<Exercise> todaysExercises = widget.trains
        .where((workout) =>
            workout.date.day == date.day &&
            workout.date.month == date.month &&
            workout.date.year == date.year)
        .expand((workout) => workout.exercises)
        .toList();

    List<Sport> todaysSports = widget.trains
        .where((workout) =>
            workout.date.day == date.day &&
            workout.date.month == date.month &&
            workout.date.year == date.year)
        .expand((workout) => workout.sports)
        .toList();

    List<Class> todaysClasses = widget.trains
        .where((workout) =>
            workout.date.day == date.day &&
            workout.date.month == date.month &&
            workout.date.year == date.year)
        .expand((workout) => workout.classes)
        .toList();

    allActivities.addAll(todaysExercises);
    allActivities.addAll(todaysSports);
    allActivities.addAll(todaysClasses);

    // Count the occurrences of each category
    Map<String, int> categoryCounts = {};
    for (var activity in allActivities) {
      String key;
      if (activity is Exercise) {
        key = activity.category;
      } else if (activity is Sport || activity is Class) {
        key = activity.name; // Assuming Sport and Class have a 'name' property
      } else {
        continue; // Skip if the activity is not one of the recognized types
      }

      if (!categoryCounts.containsKey(key)) {
        categoryCounts[key] = 1;
      } else {
        categoryCounts[key] = categoryCounts[key]! + 1;
      }
    }

    // Calculate the total number of exercises
    int totalActivities = allActivities.length;
    // Calculate proportions
    Map<String, double> categoryProportions = {};
    categoryCounts.forEach((category, count) {
      categoryProportions[category] = count / totalActivities.toDouble();
    });

    return categoryProportions;
  }
}
