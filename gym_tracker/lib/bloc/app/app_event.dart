part of 'app_bloc.dart';

abstract class AppEvent {}

class AppLoaded extends AppEvent {
  final CustomUser user;

  AppLoaded(this.user);
}

class LoadTrains extends AppEvent {}

class LoadExercises extends AppEvent {
  final Train train;

  LoadExercises(this.train);
}

class LoadSports extends AppEvent {
  final Train train;

  LoadSports(this.train);
}

class LoadClasses extends AppEvent {
  final Train train;

  LoadClasses(this.train);
}

class AddTrain extends AppEvent {
  final Train train;

  AddTrain(this.train);
}

class UpdateTrain extends AppEvent {
  final Train prevTrain;
  final Train train;

  UpdateTrain(this.prevTrain, this.train);
}

class DeleteTrain extends AppEvent {
  final Train train;

  DeleteTrain(this.train);
}

class AddExercise extends AppEvent {
  final Train train;
  final Exercise exercise;

  AddExercise(this.train, this.exercise);
}

class UpdateExercise extends AppEvent {
  final Train train;
  final Exercise prevExercise;
  final Exercise exercise;

  UpdateExercise(this.train, this.prevExercise, this.exercise);
}

class DeleteExercise extends AppEvent {
  final Train train;
  final Exercise exercise;

  DeleteExercise(this.train, this.exercise);
}

class AddSport extends AppEvent {
  final Train train;
  final Sport sport;

  AddSport(this.train, this.sport);
}

class UpdateSport extends AppEvent {
  final Train train;
  final Sport prevSport;
  final Sport sport;

  UpdateSport(this.train, this.prevSport, this.sport);
}

class DeleteSport extends AppEvent {
  final Train train;
  final Sport sport;

  DeleteSport(this.train, this.sport);
}

class AddClass extends AppEvent {
  final Train train;
  final Class class_;

  AddClass(this.train, this.class_);
}

class UpdateClass extends AppEvent {
  final Train train;
  final Class prevClass;
  final Class class_;

  UpdateClass(this.train, this.prevClass, this.class_);
}

class DeleteClass extends AppEvent {
  final Train train;
  final Class class_;

  DeleteClass(this.train, this.class_);
}

class LoadCategories extends AppEvent {}

class LoadAllSports extends AppEvent {}

class LoadAllClasses extends AppEvent {}

class LoadMuscles extends AppEvent {
  final String category;

  LoadMuscles(this.category);
}

class LoadMuscleExercises extends AppEvent {
  final String category;
  final String muscle;

  LoadMuscleExercises(this.category, this.muscle);
}

class LoadAllTrains extends AppEvent {}

class LoadTrainOf extends AppEvent {
  final DateTime date;

  LoadTrainOf(this.date);
}