import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/utils.dart';

class ClassComponent extends StatelessWidget {
  final Class classs;
  final Function() onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;

  const ClassComponent({
    Key? key,
    required this.classs,
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
                color: Utils.getActivityColor(classs.name),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(classs.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (classs.duration != 0)
                        Column(
                          children: [
                            SvgPicture.asset('assets/duration.svg', width: 30, height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(classs.duration.toString(),
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
