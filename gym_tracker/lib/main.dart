import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/bloc/app/app_bloc.dart';
import 'package:gym_tracker/bloc/auth/authentication_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/firebase_options.dart';
import 'package:gym_tracker/pages/home_screen.dart';
import 'package:gym_tracker/pages/login_screen.dart';
import 'package:gym_tracker/pages/splash_screen.dart';
import 'package:gym_tracker/repositories/app_repository.dart';
import 'package:gym_tracker/repositories/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => AppBloc(FirebaseAppRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUnauthenticated) {
              return const LoginScreen();
            } else if (state is AuthenticationAuthenticated) {
              return const HomeScreen();
            }

            return const SplashScreen();
          },
        ),
      ),
    );
  }
}
