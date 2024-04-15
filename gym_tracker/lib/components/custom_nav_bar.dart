import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomNavBar extends StatelessWidget {
  final BuildContext context;
  final Color buttonColor;
  final Color navBarColor;
  final Function() onPressedExercise;
  final Function() onPressedClasses;
  final Function() onPressedSports;
  final Function() homeFunction;
  final Function() historyFunction;
  final Function() chartFunction;
  final Function() profileFunction;

  const CustomNavBar(
      {Key? key,
      required this.context,
      required this.buttonColor,
      required this.navBarColor,
      required this.onPressedExercise,
      required this.onPressedClasses,
      required this.onPressedSports,
      required this.homeFunction,
      required this.historyFunction,
      required this.chartFunction,
      required this.profileFunction})
      : super(key: key);

  @override
  Widget build(context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: size.width,
            height: 120,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: CustomPaint(
                    size: Size(size.width, 90),
                    painter: BNBCustomPainter(
                      color: navBarColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  left: MediaQuery.of(context).size.width / 2 - 28,
                  child: SpeedDial(
                    icon: Icons.add,
                    activeIcon: Icons.close,
                    animatedIconTheme: const IconThemeData(size: 22.0),
                    backgroundColor: buttonColor,
                    visible: true,
                    curve: Curves.bounceIn,
                    overlayOpacity: 0,
                    spacing: 15,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.fitness_center, color: Colors.white),
                        backgroundColor: buttonColor,
                        onTap: onPressedExercise,
                        // labelWidget: const Text('Add Exercise'),
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.group, color: Colors.white),
                        backgroundColor: buttonColor,
                        onTap: onPressedClasses,
                        // label: 'Add Class',
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.sports_tennis_rounded, color: Colors.white),
                        backgroundColor: buttonColor,
                        onTap: onPressedSports,
                        // label: 'Add Sport',
                        
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                      width: size.width,
                      height: 90,
                      padding: const EdgeInsets.only(bottom: 8, left: 32, right: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: homeFunction,
                              icon: const Icon(Icons.home_filled,
                                  color: Color.fromRGBO(186, 186, 186, 1), size: 40)),
                          IconButton(
                              onPressed: historyFunction,
                              icon: const Icon(Icons.history,
                                  color: Color.fromRGBO(186, 186, 186, 1), size: 40)),
                          Container(width: size.width * 0.20),
                          IconButton(
                              onPressed: chartFunction,
                              icon: const Icon(Icons.bar_chart,
                                  color: Color.fromRGBO(186, 186, 186, 1), size: 40)),
                          IconButton(
                              onPressed: profileFunction,
                              icon:
                                  const Icon(Icons.person, color: Color.fromRGBO(186, 186, 186, 1), size: 40))
                        ],
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  final Color color;

  BNBCustomPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(42, 16);

    path.lineTo(size.width * 0.40, 16);
    path.arcToPoint(Offset(size.width * 0.60, 16), radius: const Radius.circular(42.5), clockwise: true);
    path.lineTo(size.width - 42, 16);
    path.quadraticBezierTo(size.width - 16, 16, size.width - 16, 42);
    path.lineTo(size.width - 16, size.height - 42);
    path.quadraticBezierTo(size.width - 16, size.height - 16, size.width - 42, size.height - 16);
    path.lineTo(42, size.height - 16);
    path.quadraticBezierTo(16, size.height - 16, 16, size.height - 42);
    path.lineTo(16, 42);
    path.quadraticBezierTo(16, 16, 42, 16);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
