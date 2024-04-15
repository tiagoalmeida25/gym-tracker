import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_tracker/app_colors.dart';
import 'package:gym_tracker/bloc/app/app_bloc.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/model/train.dart';

class AddNewExercise extends StatefulWidget {
  final bool isEdit;
  final Train workout;
  final Exercise? exercise;

  const AddNewExercise({
    Key? key,
    required this.workout,
    this.isEdit = false,
    this.exercise,
  }) : super(key: key);

  @override
  State<AddNewExercise> createState() => _AddNewExerciseState();
}

class _AddNewExerciseState extends State<AddNewExercise> {
  String selectedCategory = '';
  String selectedMuscle = '';
  String selectedExercise = '';
  List<String> categories = [];
  List<String> muscles = [];
  List<String> muscleExercises = [];
  List<Exercise> exercises = [];
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController restController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  bool isFirstLoad = true;

  late Train workout;
  late Exercise exercise;

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(LoadCategories());
    workout = widget.workout;

    if (widget.isEdit) {
      setState(() {
        exercise = widget.exercise!;
        setsController.text =
            widget.exercise!.sets.toString() == 'null' ? '' : widget.exercise!.sets.toString();
        repsController.text =
            widget.exercise!.reps.toString() == 'null' ? '' : widget.exercise!.reps.toString();
        timeController.text =
            widget.exercise!.time.toString() == 'null' ? '' : widget.exercise!.time.toString();
        restController.text =
            widget.exercise!.rest.toString() == 'null' ? '' : widget.exercise!.rest.toString();
        durationController.text =
            widget.exercise!.duration.toString() == 'null' ? '' : widget.exercise!.duration.toString();
        distanceController.text =
            widget.exercise!.distance.toString() == 'null' ? '' : widget.exercise!.distance.toString();
        weightController.text =
            widget.exercise!.weight.toString() == 'null' ? '' : widget.exercise!.weight.toString();
      });
    }
  }

  @override
  void dispose() {
    setsController.dispose();
    repsController.dispose();
    timeController.dispose();
    restController.dispose();
    durationController.dispose();
    distanceController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          if (widget.isEdit && isFirstLoad) {
            setState(() {
              categories = state.categories;
              selectedMuscle = '';
              selectedExercise = '';
              muscles = [];
              muscleExercises = [];
              selectedCategory = widget.exercise!.category;
            });
          } else {
            setState(() {
              categories = state.categories;
              selectedMuscle = '';
              selectedExercise = '';
              muscles = [];
              muscleExercises = [];
              selectedCategory = categories.first;
            });
          }
          context.read<AppBloc>().add(LoadMuscles(selectedCategory));
        }
        if (state is MusclesLoaded) {
          if (widget.isEdit && isFirstLoad) {
            setState(() {
              muscles = state.muscles;
              selectedExercise = '';
              muscleExercises = [];
              selectedMuscle = widget.exercise!.muscle;
            });
          } else {
            setState(() {
              muscles = state.muscles;
              selectedExercise = '';
              muscleExercises = [];
              selectedMuscle = muscles.first;
            });
          }
          context.read<AppBloc>().add(LoadMuscleExercises(selectedCategory, selectedMuscle));
        }
        if (state is MuscleExercisesLoaded) {
          if (widget.isEdit && isFirstLoad) {
            setState(() {
              muscleExercises = state.muscleExercises;
              selectedExercise = widget.exercise!.name;
              isFirstLoad = false;
            });
          } else {
            setState(() {
              muscleExercises = state.muscleExercises;
              selectedExercise = muscleExercises.first;
            });
          }
        }
        if (state is Success) {
          Fluttertoast.showToast(msg: state.message);
        }
        if (state is Failure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      builder: (context, state) {
        if (state is Loading || categories.isEmpty || muscles.isEmpty || muscleExercises.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 16),
                      widget.isEdit
                          ? const Text('Edit Exercise',
                              style:
                                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black))
                          : const Text('Add New Exercise',
                              style:
                                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset('assets/categories.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          menuMaxHeight: 300,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                            context.read<AppBloc>().add(LoadMuscles(selectedCategory));
                          },
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          hint: const Text('Category',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset('assets/muscles.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton(
                          value: selectedMuscle,
                          isExpanded: true,
                          menuMaxHeight: 300,
                          onChanged: (String? value) {
                            setState(() {
                              selectedMuscle = value!;
                            });
                            context
                                .read<AppBloc>()
                                .add(LoadMuscleExercises(selectedCategory, selectedMuscle));
                          },
                          items: muscles.map((String muscle) {
                            return DropdownMenuItem<String>(
                              value: muscle,
                              child: Text(muscle),
                            );
                          }).toList(),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          hint: const Text('Muscle',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset('assets/exercises.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton(
                          value: selectedExercise,
                          isExpanded: true,
                          menuMaxHeight: 300,
                          onChanged: (String? value) {
                            setState(() {
                              selectedExercise = value!;
                            });
                          },
                          items: muscleExercises.map((String exercise) {
                            return DropdownMenuItem<String>(
                              value: exercise,
                              child: Text(exercise),
                            );
                          }).toList(),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          hint: const Text('Exercise',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset('assets/sets.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: setsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Sets'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: repsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Reps'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset('assets/time.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Time (s)'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: restController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Rest (s)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset('assets/weight.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Weight (kg)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset('assets/duration.svg', width: 30, height: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Duration (min)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (selectedCategory == 'Cardio' || selectedCategory == 'Legs')
                    Row(
                      children: [
                        SvgPicture.asset('assets/distance.svg', width: 30, height: 30),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: distanceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Distance (km)'),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                      ),
                      onPressed: () {
                        if (selectedCategory.isEmpty || selectedMuscle.isEmpty || selectedExercise.isEmpty) {
                          Fluttertoast.showToast(msg: 'Please select a category, muscle and exercise.');
                          return;
                        }

                        if ((setsController.text.isEmpty || repsController.text.isEmpty) &&
                            (timeController.text.isEmpty || restController.text.isEmpty) &&
                            (durationController.text.isEmpty || distanceController.text.isEmpty)) {
                          Fluttertoast.showToast(
                              msg: 'Please fill in sets and reps or time and rest or duration and distance.');
                          return;
                        }

                        int sets = setsController.text.isEmpty ? 0 : int.parse(setsController.text);
                        int reps = repsController.text.isEmpty ? 0 : int.parse(repsController.text);
                        int time = timeController.text.isEmpty ? 0 : int.parse(timeController.text);
                        int rest = restController.text.isEmpty ? 0 : int.parse(restController.text);
                        int duration =
                            durationController.text.isEmpty ? 0 : int.parse(durationController.text);
                        double distance =
                            distanceController.text.isEmpty ? 0 : double.parse(distanceController.text);
                        double weight =
                            weightController.text.isEmpty ? 0 : double.parse(weightController.text);

                        Exercise newExercise = Exercise(
                          category: selectedCategory,
                          muscle: selectedMuscle,
                          name: selectedExercise,
                          sets: sets,
                          reps: reps,
                          time: time,
                          rest: rest,
                          duration: duration,
                          distance: distance,
                          weight: weight,
                          order: widget.isEdit ? widget.exercise!.order : exercises.length,
                        );

                        setState(() {
                          exercises.add(newExercise);
                          setsController.clear();
                          repsController.clear();
                          timeController.clear();
                          restController.clear();
                          durationController.clear();
                          distanceController.clear();
                          weightController.clear();
                        });
                        Train newWorkout = Train(
                            date: widget.workout.date,
                            exercises: exercises,
                            sports: widget.workout.sports,
                            classes: widget.workout.classes);

                        widget.isEdit
                            ? context.read<AppBloc>().add(UpdateExercise(workout, exercise, newExercise))
                            : context.read<AppBloc>().add(AddExercise(newWorkout, newExercise));

                        Navigator.pop(context);
                      },
                      child: widget.isEdit ? const Text('Save') : const Text('Add exercise')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
