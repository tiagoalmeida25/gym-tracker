import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/bloc/auth/authentication_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(size: 100), // Example logo - replace with your own
            SizedBox(height: 20),
            Text(
              'Gym Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
