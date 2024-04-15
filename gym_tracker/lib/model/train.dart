import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/model/sports.dart';

class Train {
  DateTime date;
  List<Exercise> exercises = [];
  List<Sport> sports = [];
  List<Class> classes = [];

  Train({required this.date, required this.exercises, required this.sports, required this.classes});
}
