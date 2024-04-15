import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_tracker/app_colors.dart';
import 'package:gym_tracker/bloc/app/app_bloc.dart';
import 'package:gym_tracker/bloc/auth/authentication_bloc.dart';
import 'package:gym_tracker/components/class_component.dart';
import 'package:gym_tracker/components/custom_nav_bar.dart';
import 'package:gym_tracker/components/custom_timeline.dart';
import 'package:gym_tracker/components/exercise_component.dart';
import 'package:gym_tracker/components/sport_component.dart';
import 'package:gym_tracker/components/workout_component.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/model/sports.dart';
import 'package:gym_tracker/model/train.dart';
import 'package:gym_tracker/model/user.dart';
import 'package:gym_tracker/pages/add_new_class.dart';
import 'package:gym_tracker/pages/add_new_exercise.dart';
import 'package:gym_tracker/pages/add_new_sport.dart';
import 'package:gym_tracker/pages/login_screen.dart';
import 'package:gym_tracker/pages/profile.dart';
import 'package:gym_tracker/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CustomUser user;
  String username = '';
  String profilePictureUrl = '';
  DateTime selectedDate = DateTime.now();
  String selectedMonth = Utils.getMonthName(DateTime.now().month);
  List<Train> allTrains = [];
  List<Train> trains = [];
  Train? workout;

  List<Exercise> exercises = [];
  List<Class> classes = [];
  List<Sport> sports = [];

  @override
  void initState() {
    super.initState();
    final authenticationBloc = context.read<AuthenticationBloc>();

    if (authenticationBloc.state is AuthenticationAuthenticated) {
      setState(() {
        user = authenticationBloc.state.props[0] as CustomUser;
        username = user.username;
        profilePictureUrl = user.profilePictureUrl ?? '';
      });
      context.read<AppBloc>().add(AppLoaded(user));
      context.read<AppBloc>().add(LoadCategories());
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state is ExercisesLoaded) {
          setState(() {
            exercises = state.exercises;
          });
        } else if (state is SportsLoaded) {
          setState(() {
            sports = state.sports;
          });
        } else if (state is ClassesLoaded) {
          setState(() {
            classes = state.classes;
          });
        } else if (state is TrainOfLoaded) {
          for (var train in trains) {
            if (train.date == state.train.date) {
              setState(() {
                trains.remove(train);
              });
            }
          }

          for (var train in allTrains) {
            if (train.date == state.train.date) {
              setState(() {
                allTrains.remove(train);
              });
            }
          }

          setState(() {
            trains.add(state.train);
            allTrains.add(state.train);
            allTrains.sort((a, b) => b.date.compareTo(a.date));
            workout = state.train;
            exercises = workout!.exercises;
            classes = workout!.classes;
            sports = workout!.sports;
            selectedDate = workout!.date;
            selectedMonth = Utils.getMonthName(workout!.date.month);
          });
        } else if (state is TrainsLoaded) {
          setState(() {
            allTrains = state.trains;
            allTrains.sort((a, b) => b.date.compareTo(a.date));

            trains = allTrains
                .where((train) =>
                    train.date.day == selectedDate.day &&
                    train.date.month == selectedDate.month &&
                    train.date.year == selectedDate.year)
                .toList();
            workout = null;
            exercises = [];
            classes = [];
            sports = [];
          });

          if (trains.isNotEmpty) {
            setState(() {
              workout = trains[0];
              exercises = workout!.exercises;
              classes = workout!.classes;
              sports = workout!.sports;
            });
            context.read<AppBloc>().add(LoadExercises(workout!));
            context.read<AppBloc>().add(LoadSports(workout!));
            context.read<AppBloc>().add(LoadClasses(workout!));
          }
        } else if (state is Success) {
          if (state.message == 'Train updated') {
            setState(() {});
          }
        } else if (state is Failure) {
          print(state.error);
          Fluttertoast.showToast(msg: state.error);
        }
      },
      builder: (context, state) {
        print(state);
        return Scaffold(
          backgroundColor: AppColors().backgroundColor,
          body: Stack(
            children: [
              if (state is Loading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (state is AllTrainsLoaded)
                Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 90),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      header(),
                      allWorkoutContainer(),
                    ],
                  )),
                )
              else if (exercises.isEmpty && sports.isEmpty && classes.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 90),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      header(),
                      calendarContainer(),
                      const SizedBox(height: 32),
                      const Text('No workout on this day.',
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
                    ],
                  )),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 16),
                  child: SingleChildScrollView(
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        header(),
                        calendarContainer(),
                        const SizedBox(height: 16),
                        workoutContainer(),
                      ],
                    )),
                  ),
                ),
              CustomNavBar(
                  context: context,
                  navBarColor: AppColors().navBarColor,
                  buttonColor: AppColors().primaryColor,
                  onPressedExercise: () {
                    late Train newWorkout;
                    if (workout == null) {
                      newWorkout = Train(date: selectedDate, exercises: [], classes: [], sports: []);
                      context.read<AppBloc>().add(AddTrain(newWorkout));
                    } else {
                      newWorkout = workout!;
                    }

                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddNewExercise(workout: newWorkout)))
                        .then((value) {
                      context.read<AppBloc>().add(LoadTrainOf(newWorkout.date));
                    });
                  },
                  onPressedClasses: () {
                    late Train newWorkout;
                    if (workout == null) {
                      newWorkout = Train(date: selectedDate, exercises: [], classes: [], sports: []);
                      context.read<AppBloc>().add(AddTrain(newWorkout));
                    } else {
                      newWorkout = workout!;
                    }

                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddNewClass(workout: newWorkout)))
                        .then((value) {
                      context.read<AppBloc>().add(LoadTrainOf(newWorkout.date));
                    });
                  },
                  onPressedSports: () {
                    late Train newWorkout;
                    if (workout == null) {
                      newWorkout = Train(date: selectedDate, exercises: [], classes: [], sports: []);
                      context.read<AppBloc>().add(AddTrain(newWorkout));
                    } else {
                      newWorkout = workout!;
                    }

                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddNewSport(workout: newWorkout)))
                        .then((value) {
                      context.read<AppBloc>().add(LoadTrainOf(newWorkout.date));
                    });
                  },
                  homeFunction: () {
                    context.read<AppBloc>().add(LoadTrains());
                  },
                  historyFunction: () {
                    workout = null;
                    exercises = [];
                    classes = [];
                    sports = [];
                    context.read<AppBloc>().add(LoadAllTrains());
                  },
                  chartFunction: () {},
                  profileFunction: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ProfileScreen(user: user)));
                  })
            ],
          ),
        );
      },
    );
  }

  Widget header() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gym Tracker',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget calendarContainer() {
    return CustomDateTimeline(
      trains: allTrains,
      borderColor: AppColors().borderColor,
      selectedBorderColor: AppColors().selectedBorderColor,
      selectedTextColor: AppColors().selectedTextColor,
      selectedBackgroundColor: AppColors().selectedBackground,
      selectedSecondaryTextColor: AppColors().selectedSecondaryTextColor,
      todayBorderColor: AppColors().todayBorder,
      scheduledBorderColor: AppColors().scheduledBorderColor,
      scheduledColor: AppColors().scheduledColor,
      todayBackgroundColor: AppColors().todayBackground,
      backgroundColor: AppColors().cellBackgroundColor,
      todayTextColor: AppColors().todayTextColor,
      todaySecondaryTextColor: AppColors().todaySecondaryTextColor,
      textColor: AppColors().textColor,
      secondaryTextColor: AppColors().secondaryTextColor,
      scheduledTextColor: AppColors().scheduledTextColor,
      scheduledSecondaryTextColor: AppColors().scheduledSecondaryTextColor,
      selectedDate: selectedDate,
      onDateSelected: (date) {
        if (selectedDate == date) {
          return;
        }

        setState(() {
          selectedDate = date;
          selectedMonth = Utils.getMonthName(date.month);
        });

        trains = allTrains
            .where((train) =>
                train.date.day == date.day && train.date.month == date.month && train.date.year == date.year)
            .toList();

        if (trains.isNotEmpty) {
          setState(() {
            workout = trains[0];
            exercises = workout!.exercises;
            classes = workout!.classes;
            sports = workout!.sports;
          });
          context.read<AppBloc>().add(LoadExercises(workout!));
        } else {
          setState(() {
            workout = null;
            exercises = [];
            classes = [];
            sports = [];
          });
        }
      },
    );
  }

  Widget workoutContainer() {
    if (workout != null) {
      exercises = workout!.exercises;
      classes = workout!.classes;
      sports = workout!.sports;
    }

    return Column(
      children: [
        if (exercises.isNotEmpty)
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex >= exercises.length) {
                newIndex = exercises.length - 1;
              }
              final Exercise item = exercises.removeAt(oldIndex);

              setState(() {
                exercises.insert(newIndex, item);
              });

              Train newWorkout =
                  Train(date: workout!.date, exercises: exercises, classes: classes, sports: sports);

              context.read<AppBloc>().add(UpdateTrain(workout!, newWorkout));
            },
            children: exercises
                .map((exercise) => Container(
                      key: Key(exercise.name),
                      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          dragDismissible: false,
                          extentRatio: 0.20,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                confirmDeletePopUp(workout, exercise, 'exercise');
                              },
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: ExerciseComponent(
                          exercise: exercise,
                          backgroundColor: AppColors().exerciseBackgroundColor,
                          textColor: AppColors().exerciseTextColor,
                          secondaryTextColor: AppColors().exerciseSecondaryTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNewExercise(exercise: exercise, workout: workout!, isEdit: true)),
                            ).then((value) => context.read<AppBloc>().add(LoadTrainOf(workout!.date)));
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        if (sports.isNotEmpty)
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex >= sports.length) {
                newIndex = sports.length - 1;
              }
              final Sport item = sports.removeAt(oldIndex);

              setState(() {
                sports.insert(newIndex, item);
              });

              Train newWorkout =
                  Train(date: workout!.date, exercises: exercises, classes: classes, sports: sports);

              context.read<AppBloc>().add(UpdateTrain(workout!, newWorkout));
            },
            children: sports
                .map((sport) => Container(
                      key: Key(sport.name),
                      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          dragDismissible: false,
                          extentRatio: 0.20,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                confirmDeletePopUp(workout, sport, 'sport');
                              },
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: SportComponent(
                          sport: sport,
                          backgroundColor: AppColors().exerciseBackgroundColor,
                          textColor: AppColors().exerciseTextColor,
                          secondaryTextColor: AppColors().exerciseSecondaryTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNewSport(sport: sport, workout: workout!, isEdit: true)),
                            ).then((value) => context.read<AppBloc>().add(LoadTrainOf(workout!.date)));
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        if (classes.isNotEmpty)
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex >= classes.length) {
                newIndex = classes.length - 1;
              }
              final Class item = classes.removeAt(oldIndex);

              setState(() {
                classes.insert(newIndex, item);
              });

              Train newWorkout =
                  Train(date: workout!.date, exercises: exercises, classes: classes, sports: sports);

              context.read<AppBloc>().add(UpdateTrain(workout!, newWorkout));
            },
            children: classes
                .map((class_) => Container(
                      key: Key(class_.name),
                      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          dragDismissible: false,
                          extentRatio: 0.20,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                confirmDeletePopUp(workout, class_, 'class');
                              },
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: ClassComponent(
                          classs: class_,
                          backgroundColor: AppColors().exerciseBackgroundColor,
                          textColor: AppColors().exerciseTextColor,
                          secondaryTextColor: AppColors().exerciseSecondaryTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNewClass(class_: class_, workout: workout!, isEdit: true)),
                            ).then((value) => context.read<AppBloc>().add(LoadTrainOf(workout!.date)));
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        const SizedBox(height: 90),
      ],
    );
  }

  void confirmDeletePopUp(Train? workout, dynamic exercise, String type) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              type == 'exercise'
                  ? 'Delete Exercise'
                  : type == 'class'
                      ? 'Delete Class'
                      : type == 'sport'
                          ? 'Delete Sport'
                          : 'Delete Workout',
            ),
            content: Text(
                'Are you sure you want to delete this ${type == 'exercise' ? 'exercise' : type == 'class' ? 'class' : type == 'sport' ? 'sport' : 'workout'}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (type == 'exercise') {
                    context.read<AppBloc>().add(DeleteExercise(workout!, exercise));
                  } else if (type == 'class') {
                    context.read<AppBloc>().add(DeleteClass(workout!, exercise));
                  } else if (type == 'sport') {
                    context.read<AppBloc>().add(DeleteSport(workout!, exercise));
                  } else {
                    context.read<AppBloc>().add(DeleteTrain(workout!));
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  Widget allWorkoutContainer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('All Workouts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            if (allTrains.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('No workouts yet.',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey))
                ]),
              )
            else
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: allTrains.length,
                  itemBuilder: (context, index) {
                    if (allTrains[index].exercises.isEmpty) {
                      return const SizedBox();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Slidable(
                        key: Key(allTrains[index].date.toString()),
                        startActionPane: ActionPane(
                          extentRatio: 0.2,
                          dragDismissible: false,
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                confirmDeletePopUp(allTrains[index], null, 'workout');
                              },
                              spacing: 8,
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: WorkoutComponent(
                          workout: allTrains[index],
                          onTap: () {
                            context.read<AppBloc>().add(LoadExercises(allTrains[index]));
                            setState(() {
                              selectedDate = allTrains[index].date;
                              selectedMonth = Utils.getMonthName(allTrains[index].date.month);
                              workout = allTrains[index];
                              exercises = allTrains[index].exercises;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
