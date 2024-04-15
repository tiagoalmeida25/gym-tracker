import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_tracker/model/exercise.dart';
import 'package:gym_tracker/utils.dart';

class ExerciseComponent extends StatelessWidget {
  final Exercise exercise;
  final Function() onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;

  const ExerciseComponent({
    Key? key,
    required this.exercise,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: backgroundColor, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ]),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Container(
              width: 4,
              height: 70,
              decoration: BoxDecoration(
                color: Utils.getActivityColor(exercise.category),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 75,
                        child: Text(
                          exercise.muscle,
                          style:
                              TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: secondaryTextColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (exercise.weight != 0 && exercise.weight != null)
                        Column(
                          children: [
                            SvgPicture.asset('assets/weight.svg', width: 30, height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(exercise.weight.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text('kg',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      if (exercise.distance != 0 && exercise.distance != null)
                        Column(
                          children: [
                            SvgPicture.asset('assets/distance.svg', width: 30, height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(exercise.distance.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text('km',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      if (exercise.duration != 0 && exercise.duration != null)
                        Column(
                          children: [
                            SvgPicture.asset('assets/duration.svg', width: 30, height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(exercise.duration.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text('min',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      if (exercise.time != 0 &&
                          exercise.time != null &&
                          exercise.rest != 0 &&
                          exercise.rest != null)
                        Column(
                          children: [
                            SvgPicture.asset('assets/time.svg', width: 30, height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(exercise.time.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text('s',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text('/',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text(exercise.rest.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text('s',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      if (exercise.sets != 0 &&
                          exercise.sets != null &&
                          exercise.reps != 0 &&
                          exercise.reps != null)
                        Column(
                          children: [
                            SvgPicture.asset('assets/sets.svg', width: 30, height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${exercise.sets}x',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                                Text(exercise.reps.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
