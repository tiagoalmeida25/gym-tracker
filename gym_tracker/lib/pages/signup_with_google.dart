import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gym_tracker/pages/user_info.dart';

class SignupWithGoogle extends StatefulWidget {
  final User user;

  const SignupWithGoogle({Key? key, required this.user}) : super(key: key);

  @override
  State<SignupWithGoogle> createState() => _SignupWithGoogleState();
}

class _SignupWithGoogleState extends State<SignupWithGoogle> {
  final TextEditingController usernameController = TextEditingController();

  File? _profileImage;

  Future<String?> uploadProfilePicture(String userId, File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('userProfiles/$userId/profilePicture.png');
    try {
      await storageRef.putFile(imageFile);
      String downloadUrl = await storageRef.getDownloadURL();
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      return File(pickedFile.path);
    }
    return null;
  }

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
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null ? const Icon(Icons.add_a_photo, size: 50) : null,
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_profileImage == null) {
                    Fluttertoast.showToast(msg: 'Please select a profile image');
                  } else if (usernameController.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please enter a username');
                  } else {
                    User user = FirebaseAuth.instance.currentUser!;

                    await user.updateDisplayName(usernameController.text.trim());
                    await uploadProfilePicture(user.uid, _profileImage!);

                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) =>  UserInfoScreen(user: user)));
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
