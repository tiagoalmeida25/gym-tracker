import 'package:flutter/material.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/model/sports.dart';
import 'package:gym_tracker/model/train.dart';
import 'package:gym_tracker/utils.dart';

class WorkoutComponent extends StatefulWidget {
  final Train workout;
  final Function() onTap;

  const WorkoutComponent({
    Key? key,
    required this.workout,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WorkoutComponent> createState() => _WorkoutComponentState();
}

class _WorkoutComponentState extends State<WorkoutComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Utils.getDate(widget.workout.date),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Exercises: ',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                Text(widget.workout.exercises.length.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 4),
            if (widget.workout.sports.isNotEmpty) ...[
              Row(
                children: [
                  const Text('Sports: ',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                  Text(widget.workout.sports.length.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 4)
            ],
            if (widget.workout.classes.isNotEmpty) ...[
              Row(
                children: [
                  const Text('Classes: ',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                  Text(widget.workout.classes.length.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 4),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 15,
                child: Row(
                  children: _buildCategoryProportionWidgets(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryProportionWidgets() {
    // Assuming you have a method to calculate the proportions

    Map<String, double> proportions = _calculateCategoryProportionsForDate();

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

  Map<String, double> _calculateCategoryProportionsForDate() {
    List<dynamic> allActivities = [];
    List<Exercise> todaysExercises = widget.workout.exercises;

    List<Sport> todaysSports = widget.workout.sports;

    List<Class> todaysClasses = widget.workout.classes;

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
