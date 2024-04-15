// import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gym_tracker/bloc/app/app_bloc.dart';
// import 'package:gym_tracker/model/exercise.dart';
// import 'package:gym_tracker/model/train.dart';
// import 'package:gym_tracker/utils.dart';

// class TrainScreen extends StatefulWidget {
//   final Train train;

//   const TrainScreen({Key? key, required this.train}) : super(key: key);

//   @override
//   State<TrainScreen> createState() => _TrainScreenState();
// }

// class _TrainScreenState extends State<TrainScreen> with TickerProviderStateMixin {
//   final EasyInfiniteDateTimelineController _dateController = EasyInfiniteDateTimelineController();
//   List<Exercise> exercises = [];
//   List<String> categories = [];
//   List<String> muscles = [];
//   List<String> muscleExercises = [];
//   String selectedCategory = '';
//   String selectedMuscle = '';
//   String selectedExercise = '';
//   String selectedMonth = '';
//   DateTime selectedDate = DateTime.now();
//   int hours = 0;
//   int minutes = 0;
//   bool expander = false;

//   int sets = 0;
//   int reps = 0;
//   int time = 0;
//   int rest = 0;
//   int duration = 0;
//   double distance = 0;
//   double weight = 0;

//   @override
//   void initState() {
//     super.initState();
//     selectedDate = widget.train.date;
//     hours = selectedDate.hour;
//     minutes = selectedDate.minute;
//     selectedMonth = Utils.getMonthName(selectedDate.month);
//     context.read<AppBloc>().add(LoadCategories());
//     context.read<AppBloc>().add(LoadExercises(widget.train));

//     if (widget.train.exercises.isNotEmpty) {
//       exercises = widget.train.exercises;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppBloc, AppState>(
//       listener: (context, state) {
//         if (state is ExercisesLoaded) {
//           setState(() {
//             exercises = state.exercises;
//           });
//         }
//         if (state is CategoriesLoaded) {
//           setState(() {
//             categories = state.categories;
//             selectedCategory = categories[0];
//           });
//           context.read<AppBloc>().add(LoadMuscles(selectedCategory));
//         }

//         if (state is MusclesLoaded) {
//           setState(() {
//             muscles = state.muscles;
//             selectedMuscle = state.muscles[0];
//           });
//           context.read<AppBloc>().add(LoadMuscleExercises(selectedCategory, selectedMuscle));
//         }

//         if (state is MuscleExercisesLoaded) {
//           setState(() {
//             muscleExercises = state.muscleExercises;
//             selectedExercise = state.muscleExercises[0];
//           });
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
//               child: Center(
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.arrow_back),
//                         ),
//                         const SizedBox(width: 16),
//                         const Text(
//                           'Edit Train',
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     EasyInfiniteDateTimeLine(
//                       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//                       lastDate: DateTime.now().add(const Duration(days: 365)),
//                       controller: _dateController,
//                       focusDate: selectedDate,
//                       dayProps: const EasyDayProps(
//                         width: 60,
//                         height: 60,
//                       ),
//                       onDateChange: (DateTime date) {
//                         setState(() {
//                           selectedDate = date;
//                           selectedMonth = Utils.getMonthName(selectedDate.month);
//                         });
//                       },
//                       headerBuilder: (context, date) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               if (date.day == DateTime.now().day &&
//                                   date.month == DateTime.now().month &&
//                                   date.year == DateTime.now().year)
//                                 const SizedBox()
//                               else
//                                 GestureDetector(
//                                   onTap: () {
//                                     _dateController.jumpToDate(DateTime.now());
//                                     setState(() {
//                                       selectedDate = DateTime.now();
//                                       selectedMonth = Utils.getMonthName(selectedDate.month);
//                                     });
//                                   },
//                                   child: const Text(
//                                     'Today',
//                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               DropdownButton(
//                                   items: [
//                                     'Jan',
//                                     'Feb',
//                                     'Mar',
//                                     'Apr',
//                                     'May',
//                                     'Jun',
//                                     'Jul',
//                                     'Aug',
//                                     'Sep',
//                                     'Oct',
//                                     'Nov',
//                                     'Dec'
//                                   ].map((String month) {
//                                     return DropdownMenuItem(
//                                       value: month,
//                                       child: Text(month),
//                                     );
//                                   }).toList(),
//                                   onChanged: (dynamic value) {
//                                     setState(() {
//                                       int month = Utils.getMonthNumber(value);
//                                       selectedDate = DateTime(selectedDate.year, month, 1);
//                                       _dateController.jumpToDate(selectedDate);
//                                       selectedMonth = value;
//                                     });
//                                   },
//                                   value: selectedMonth),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextButton(
//                       onPressed: () => Navigator.of(context).push(
//                         showPicker(
//                           context: context,
//                           value: Time(hour: hours, minute: minutes),
//                           onChange: (TimeOfDay time) {
//                             setState(() {
//                               selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
//                                   time.hour, time.minute);
//                               hours = time.hour;
//                               minutes = time.minute;
//                             });
//                           },
//                         ),
//                       ),
//                       child: Text(
//                           'Time: ${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}'),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (!(selectedDate.day == widget.train.date.day &&
//                                 selectedDate.month == widget.train.date.month &&
//                                 selectedDate.year == widget.train.date.year) ||
//                             !(hours == widget.train.date.hour && minutes == widget.train.date.minute))
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedDate = widget.train.date;
//                                   hours = widget.train.date.hour;
//                                   minutes = widget.train.date.minute;
//                                 });
//                               },
//                               icon: const Icon(Icons.close)),
//                         ElevatedButton(
//                           onPressed: () {
//                             DateTime newDate = DateTime(
//                                 selectedDate.year, selectedDate.month, selectedDate.day, hours, minutes);
//                             Train newTrain = Train(date: newDate, exercises: exercises, 
//                             context.read<AppBloc>().add(UpdateTrain(widget.train, newTrain));
//                           },
//                           child: const Text('Save'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () => setState(() {
//                                 expander = !expander;
//                               }),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text('Add exercise',
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                                   Icon(expander ? Icons.arrow_drop_up : Icons.arrow_drop_down),
//                                 ],
//                               ),
//                             ),
//                             if (expander)
//                               Column(
//                                 children: [
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       DropdownMenu(
//                                         width: MediaQuery.of(context).size.width / 2 - 42,
//                                         label: const Text('Category',
//                                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                                         initialSelection: selectedCategory,
//                                         dropdownMenuEntries: categories.map((String category) {
//                                           return DropdownMenuEntry<dynamic>(
//                                             value: category,
//                                             label: category,
//                                           );
//                                         }).toList(),
//                                         onSelected: (dynamic value) {
//                                           setState(() {
//                                             selectedCategory = value;
//                                             selectedMuscle = '';
//                                             selectedExercise = '';
//                                           });
//                                           context.read<AppBloc>().add(LoadMuscles(selectedCategory));
//                                         },
//                                       ),
//                                       DropdownMenu(
//                                         width: MediaQuery.of(context).size.width / 2 - 42,
//                                         label: const Text('Muscle',
//                                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                                         initialSelection: selectedMuscle,
//                                         dropdownMenuEntries: muscles.map((String muscle) {
//                                           return DropdownMenuEntry<dynamic>(
//                                             value: muscle,
//                                             label: muscle,
//                                           );
//                                         }).toList(),
//                                         onSelected: (dynamic value) {
//                                           setState(() {
//                                             selectedMuscle = value;
//                                             selectedExercise = '';
//                                           });
//                                           context
//                                               .read<AppBloc>()
//                                               .add(LoadMuscleExercises(selectedCategory, selectedMuscle));
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   DropdownMenu(
//                                     width: MediaQuery.of(context).size.width - 64,
//                                     label: const Text('Exercises',
//                                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                                     initialSelection: selectedExercise,
//                                     dropdownMenuEntries: muscleExercises.map((String exercise) {
//                                       return DropdownMenuEntry<dynamic>(
//                                         value: exercise,
//                                         label: exercise,
//                                       );
//                                     }).toList(),
//                                     onSelected: (dynamic value) {
//                                       setState(() {
//                                         selectedExercise = value;
//                                       });
//                                     },
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Sets'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               sets = int.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Reps'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reps = int.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Time'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               time = int.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Rest'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               rest = int.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Duration'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               duration = int.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Distance'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               distance = double.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(labelText: 'Weight'),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               weight = double.parse(value);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   ElevatedButton(
//                                       onPressed: () {
//                                         if (selectedCategory.isEmpty ||
//                                             selectedMuscle.isEmpty ||
//                                             selectedExercise.isEmpty) {
//                                           Fluttertoast.showToast(
//                                               msg: 'Please select a category, muscle and exercise.');
//                                           return;
//                                         }

//                                         if ((sets == 0 || reps == 0) &&
//                                             (time == 0 || rest == 0) &&
//                                             duration == 0) {
//                                           Fluttertoast.showToast(
//                                               msg:
//                                                   'Please fill in sets and reps or time and rest or duration.');
//                                           return;
//                                         }
//                                         setState(() {
//                                           exercises.add(Exercise(
//                                             category: selectedCategory,
//                                             muscle: selectedMuscle,
//                                             name: selectedExercise,
//                                             sets: sets,
//                                             reps: reps,
//                                             time: time,
//                                             rest: rest,
//                                             duration: duration,
//                                             distance: distance,
//                                             weight: weight,
//                                             order: exercises.length,
//                                           ));
//                                           sets = 0;
//                                           reps = 0;
//                                           time = 0;
//                                           rest = 0;
//                                           duration = 0;
//                                           distance = 0;
//                                           weight = 0;
//                                         });
//                                         context
//                                             .read<AppBloc>()
//                                             .add(AddExercise(widget.train, exercises.last));
//                                       },
//                                       child: const Text('Add exercise')),
//                                 ],
//                               ),
//                           ],
//                         )),
//                     const SizedBox(height: 16),
//                     if (exercises.isNotEmpty)
//                       ReorderableListView(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         onReorder: (int oldIndex, int newIndex) {
//                           setState(() {
//                             if (newIndex > oldIndex) {
//                               newIndex -= 1;
//                             }
//                             final Exercise item = exercises.removeAt(oldIndex);
//                             exercises.insert(newIndex, item);
//                           });
//                         },
//                         children: exercises
//                             .map((exercise) => Card(
//                                   key: ValueKey(exercise),
//                                   child: ListTile(
//                                     title: Text(exercise.name),
//                                     subtitle: Text(
//                                         'Sets: ${exercise.sets}, Reps: ${exercise.reps} | Time: ${exercise.time}, Rest: ${exercise.rest} | Duration: ${exercise.duration}'),
//                                     trailing: IconButton(
//                                       icon: const Icon(Icons.delete),
//                                       onPressed: () {
//                                         setState(() {
//                                           exercises.remove(exercise);
//                                         });
//                                         context.read<AppBloc>().add(DeleteExercise(widget.train, exercise));
//                                       },
//                                     ),
//                                   ),
//                                 ))
//                             .toList(),
//                       )
//                     else
//                       const Text('No exercises.'),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
