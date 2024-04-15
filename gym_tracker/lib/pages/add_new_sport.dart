import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_tracker/app_colors.dart';
import 'package:gym_tracker/bloc/app/app_bloc.dart';
import 'package:gym_tracker/model/sports.dart';
import 'package:gym_tracker/model/train.dart';

class AddNewSport extends StatefulWidget {
  final bool isEdit;
  final Train workout;
  final Sport? sport;

  const AddNewSport({
    Key? key,
    required this.workout,
    this.isEdit = false,
    this.sport,
  }) : super(key: key);

  @override
  State<AddNewSport> createState() => _AddNewSportState();
}

class _AddNewSportState extends State<AddNewSport> {
  List<String> sports = [];
  String selectedSport = '';
  TextEditingController durationController = TextEditingController();

  bool isFirstLoad = true;

  late Train workout;
  late Sport sport;

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(LoadAllSports());
    workout = widget.workout;

    if (widget.isEdit) {
      setState(() {
        sport = widget.sport!;
        selectedSport = sport.name;
        durationController.text = sport.duration.toString();
        isFirstLoad = false;
      });
    }
  }

  @override
  void dispose() {
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AllSportsLoaded) {
          if (widget.isEdit && isFirstLoad) {
            setState(() {
              sports = state.sports;
              selectedSport = sport.name;
              isFirstLoad = false;
            });
          } else {
            setState(() {
              sports = state.sports;
              selectedSport = sports[0];
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
        if (state is Loading || sports.isEmpty) {
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
                          ? const Text('Edit Sport',
                              style:
                                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black))
                          : const Text('Add New Sport',
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
                          value: selectedSport,
                          isExpanded: true,
                          menuMaxHeight: 300,
                          onChanged: (String? value) {
                            setState(() {
                              selectedSport = value!;
                            });
                          },
                          items: sports.map((String sport) {
                            return DropdownMenuItem<String>(
                              value: sport,
                              child: Text(sport),
                            );
                          }).toList(),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          hint: const Text('Sport',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                      ),
                      onPressed: () {
                        if (durationController.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Please fill in the duration.');
                          return;
                        }

                        int duration =
                            durationController.text.isEmpty ? 0 : int.parse(durationController.text);
                        Sport newSport = Sport(
                            name: selectedSport, duration: duration, order: widget.workout.sports.length);

                        List<Sport> workoutSports = widget.workout.sports;

                        if (widget.isEdit) {
                          workoutSports.remove(sport);
                        }

                        workoutSports.add(newSport);

                        setState(() {
                          durationController.clear();
                        });
                        Train newWorkout = Train(
                            date: widget.workout.date,
                            exercises: widget.workout.exercises,
                            sports: workoutSports,
                            classes: widget.workout.classes);

                        widget.isEdit
                            ? context.read<AppBloc>().add(UpdateSport(workout, sport, newSport))
                            : context.read<AppBloc>().add(AddSport(newWorkout, newSport));

                        Navigator.pop(context);
                      },
                      child: widget.isEdit ? const Text('Save') : const Text('Add sport')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
