import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/sports.dart';
import 'package:gym_tracker/model/user.dart';
import 'package:gym_tracker/repositories/app_repository.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/model/train.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseAppRepository repository;
  late CustomUser user;
  List<Train> trains = [];
  List<Exercise> exercises = [];
  List<Sport> sports = [];
  List<Class> classes = [];
  List<String> sportsList = [];
  List<String> classesList = [];
  List<String> categories = [];
  List<String> muscles = [];
  List<String> muscleExercises = [];

  AppBloc(this.repository) : super(Loading()) {
    on<AppLoaded>(_onAppLoaded);
    on<LoadTrains>(_onLoadTrains);
    on<LoadAllTrains>(_onLoadAllTrains);
    on<LoadTrainOf>(_onLoadTrainOf);
    on<LoadExercises>(_onLoadExercises);
    on<LoadSports>(_onLoadSports);
    on<LoadClasses>(_onLoadClasses);
    on<AddTrain>(_onAddTrain);
    on<UpdateTrain>(_onUpdateTrain);
    on<DeleteTrain>(_onDeleteTrain);
    on<AddExercise>(_onAddExercise);
    on<UpdateExercise>(_onUpdateExercise);
    on<DeleteExercise>(_onDeleteExercise);
    on<AddSport>(_onAddSport);
    on<UpdateSport>(_onUpdateSport);
    on<DeleteSport>(_onDeleteSport);
    on<AddClass>(_onAddClass);
    on<UpdateClass>(_onUpdateClass);
    on<DeleteClass>(_onDeleteClass);
    on<LoadAllSports>(_onLoadAllSports);
    on<LoadAllClasses>(_onLoadAllClasses);
    on<LoadCategories>(_onGetCategories);
    on<LoadMuscles>(_onGetMuscles);
    on<LoadMuscleExercises>(_onGetMuscleExercises);
  }

  void _onAppLoaded(AppLoaded event, Emitter<AppState> emit) {
    user = event.user;
    emit(Loading());

    add(LoadTrains());
  }

  void _onLoadTrains(LoadTrains event, Emitter<AppState> emit) async {
    try {
      trains = await repository.loadTrains(user.id);
      emit(TrainsLoaded(trains));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadAllTrains(LoadAllTrains event, Emitter<AppState> emit) async {
    try {
      trains = await repository.loadTrains(user.id);
      emit(AllTrainsLoaded(trains));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadExercises(LoadExercises event, Emitter<AppState> emit) async {
    try {
      exercises = await repository.loadExercises(user.id, event.train);
      emit(ExercisesLoaded(exercises));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadSports(LoadSports event, Emitter<AppState> emit) async {
    try {
      sports = await repository.loadSports(user.id, event.train);
      emit(SportsLoaded(sports));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadClasses(LoadClasses event, Emitter<AppState> emit) async {
    try {
      classes = await repository.loadClasses(user.id, event.train);
      emit(ClassesLoaded(classes));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadTrainOf(LoadTrainOf event, Emitter<AppState> emit) async {
    try {
      add(LoadAllTrains());
      Train train = await repository.loadTrainOf(user.id, event.date);
      emit(TrainOfLoaded(train));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onAddTrain(AddTrain event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.addTrain(user.id, event.train);
      trains = await repository.loadTrains(user.id);
      emit(TrainsLoaded(trains));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onUpdateTrain(UpdateTrain event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.updateTrain(user.id, event.prevTrain, event.train);
      trains = await repository.loadTrains(user.id);
      emit(TrainsLoaded(trains));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onDeleteTrain(DeleteTrain event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.deleteTrain(user.id, event.train);
      add(LoadTrains());
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onAddExercise(AddExercise event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.addExercise(user.id, event.train, event.exercise);
      add(LoadTrainOf(event.train.date));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onUpdateExercise(UpdateExercise event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.updateExercise(user.id, event.train, event.prevExercise, event.exercise);
      emit(Success('Exercise updated'));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onDeleteExercise(DeleteExercise event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.deleteExercise(user.id, event.train, event.exercise);

      if (event.train.exercises.length <= 1) {
        add(DeleteTrain(event.train));
      } else {
        add(LoadExercises(event.train));
      }
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onAddSport(AddSport event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.addSport(user.id, event.train, event.sport);
      add(LoadSports(event.train));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onUpdateSport(UpdateSport event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.updateSport(user.id, event.train, event.prevSport, event.sport);
      emit(Success('Sport updated'));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onDeleteSport(DeleteSport event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.deleteSport(user.id, event.train, event.sport);
      add(LoadSports(event.train));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onAddClass(AddClass event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.addClass(user.id, event.train, event.class_);
      add(LoadClasses(event.train));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onUpdateClass(UpdateClass event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.updateClass(user.id, event.train, event.prevClass, event.class_);
      emit(Success('Class updated'));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onDeleteClass(DeleteClass event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      await repository.deleteClass(user.id, event.train, event.class_);
      add(LoadClasses(event.train));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onGetCategories(LoadCategories event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      categories = await repository.loadCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onGetMuscles(LoadMuscles event, Emitter<AppState> emit) async {
    try {
      muscles = await repository.loadMuscles(event.category);
      emit(MusclesLoaded(muscles));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onGetMuscleExercises(LoadMuscleExercises event, Emitter<AppState> emit) async {
    try {
      muscleExercises = await repository.loadMuscleExercises(event.category, event.muscle);
      emit(MuscleExercisesLoaded(muscleExercises));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadAllSports(LoadAllSports event, Emitter<AppState> emit) async {
    try {
      sportsList = await repository.loadAllSports();
      emit(AllSportsLoaded(sportsList));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void _onLoadAllClasses(LoadAllClasses event, Emitter<AppState> emit) async {
    try {
      classesList = await repository.loadAllClasses();
      emit(AllClassesLoaded(classesList));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  @override
  void onTransition(Transition<AppEvent, AppState> transition) {
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }
}
