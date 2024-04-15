import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_tracker/bloc/auth/authentication_bloc.dart';
import 'package:gym_tracker/model/user.dart';
import 'package:gym_tracker/pages/home_screen.dart';

class UserInfoScreen extends StatefulWidget {
  final User user;

  const UserInfoScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String selectedGender = '';
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Welcome to Gym Tracker',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: selectedGender,
                items: ['Female', 'Male', 'Rather not say']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value.toString();
                  });
                },
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedGender.isEmpty ||
                      weightController.text.isEmpty ||
                      heightController.text.isEmpty ||
                      ageController.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please fill in all fields');
                  } else {
                    User user = FirebaseAuth.instance.currentUser!;

                    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                      'gender': selectedGender,
                      'weight': int.parse(weightController.text),
                      'height': int.parse(heightController.text),
                      'age': int.parse(ageController.text),
                    });

                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
                        user: CustomUser(
                      id: user.uid,
                      username: user.displayName!,
                      email: user.email!,
                      profilePictureUrl: user.photoURL,
                    )));

                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
