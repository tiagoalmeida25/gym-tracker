part of 'app_bloc.dart';

abstract class AppState {}

class Loading extends AppState {}

class TrainsLoaded extends AppState {
  final List<Train> trains;

  TrainsLoaded(this.trains);
}

class AllTrainsLoaded extends AppState {
  final List<Train> allTrains;

  AllTrainsLoaded(this.allTrains);
}

class TrainOfLoaded extends AppState {
  final Train train;

  TrainOfLoaded(this.train);
}

class ExercisesLoaded extends AppState {
  final List<Exercise> exercises;

  ExercisesLoaded(this.exercises);
}

class SportsLoaded extends AppState {
  final List<Sport> sports;

  SportsLoaded(this.sports);
}

class ClassesLoaded extends AppState {
  final List<Class> classes;

  ClassesLoaded(this.classes);
}

class AllSportsLoaded extends AppState {
  final List<String> sports;

  AllSportsLoaded(this.sports);
}

class AllClassesLoaded extends AppState {
  final List<String> classes;

  AllClassesLoaded(this.classes);
}

class CategoriesLoaded extends AppState {
  final List<String> categories;

  CategoriesLoaded(this.categories);
}

class MusclesLoaded extends AppState {
  final List<String> muscles;

  MusclesLoaded(this.muscles);
}

class MuscleExercisesLoaded extends AppState {
  final List<String> muscleExercises;

  MuscleExercisesLoaded(this.muscleExercises);
}

class Failure extends AppState {
  final String error;
  Failure(this.error);
}

class Success extends AppState {
  final String message;
  Success(this.message);
}
