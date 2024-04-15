import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_tracker/app_colors.dart';
import 'package:gym_tracker/bloc/app/app_bloc.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/train.dart';

class AddNewClass extends StatefulWidget {
  final bool isEdit;
  final Train workout;
  final Class? class_;

  const AddNewClass({
    Key? key,
    required this.workout,
    this.isEdit = false,
    this.class_,
  }) : super(key: key);

  @override
  State<AddNewClass> createState() => _AddNewClassState();
}

class _AddNewClassState extends State<AddNewClass> {
  List<String> classes = [];
  String selectedClass = '';
  TextEditingController durationController = TextEditingController();

  bool isFirstLoad = true;

  late Train workout;
  late Class class_;

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(LoadAllClasses());
    workout = widget.workout;

    if (widget.isEdit) {
      setState(() {
        class_ = widget.class_!;
        selectedClass = class_.name;
        durationController.text = class_.duration.toString();
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
        if (state is AllClassesLoaded) {
          if (widget.isEdit && isFirstLoad) {
            setState(() {
              classes = state.classes;
              selectedClass = class_.name;
              isFirstLoad = false;
            });
          } else {
            setState(() {
              classes = state.classes;
              selectedClass = classes[0];
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
        if (state is Loading || classes.isEmpty) {
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
                          ? const Text('Edit Class',
                              style:
                                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black))
                          : const Text('Add New Class',
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
                          value: selectedClass,
                          isExpanded: true,
                          menuMaxHeight: 300,
                          onChanged: (String? value) {
                            setState(() {
                              selectedClass = value!;
                            });
                          },
                          items: classes.map((String classs) {
                            return DropdownMenuItem<String>(
                              value: classs,
                              child: Text(classs),
                            );
                          }).toList(),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          hint: const Text('Class',
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
                        Class newClass = Class(
                            name: selectedClass, duration: duration, order: widget.workout.classes.length);

                        List<Class> workoutClasses = widget.workout.classes;

                        if (widget.isEdit) {
                          workoutClasses.remove(class_);
                        }

                        workoutClasses.add(newClass);

                        setState(() {
                          durationController.clear();
                        });
                        Train newWorkout = Train(
                            date: widget.workout.date,
                            exercises: widget.workout.exercises,
                            classes: workoutClasses,
                            sports: widget.workout.sports);

                        widget.isEdit
                            ? context.read<AppBloc>().add(UpdateClass(workout, class_, newClass))
                            : context.read<AppBloc>().add(AddClass(newWorkout, newClass));

                        Navigator.pop(context);
                      },
                      child: widget.isEdit ? const Text('Save') : const Text('Add class')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
