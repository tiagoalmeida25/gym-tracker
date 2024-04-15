import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_tracker/bloc/app/app_bloc.dart';
import 'package:gym_tracker/bloc/auth/authentication_bloc.dart';
import 'package:gym_tracker/model/user.dart';
import 'package:gym_tracker/pages/login_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final CustomUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CustomUser? user;
  String username = '';
  String profilePictureUrl = '';

  File? _profileImage;

  TextEditingController usernameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String selectedGender = 'Female';

  @override
  void initState() {
    super.initState();
    final authenticationBloc = context.read<AuthenticationBloc>();

    if (authenticationBloc.state is AuthenticationAuthenticated) {
      setState(() {
        user = widget.user;
        username = user!.username;
        profilePictureUrl = user!.profilePictureUrl ?? '';
        usernameController.text = username;
      });
      context.read<AppBloc>().add(AppLoaded(user!));

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            ageController.text = data['age'].toString();
            weightController.text = data['weight'].toString();
            heightController.text = data['height'].toString();
            selectedGender = data['gender'];
          });
        }
      });
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void uploadProfilePicture(String userId, File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('userProfiles/$userId/profilePicture.png');
    try {
      await storageRef.putFile(imageFile);
      String downloadUrl = await storageRef.getDownloadURL();
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadUrl);
      setState(() {
        profilePictureUrl = downloadUrl;
      });
    } catch (e) {
      print(e);
    }
  }

  void pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(listener: (context, state) {
      if (state is AuthenticationFailure) {
        Fluttertoast.showToast(msg: state.message);
      } else if (state is AuthenticationSuccess) {
        Fluttertoast.showToast(msg: state.message);
      }
    }, builder: (context, state) {
      if (state is AuthenticationLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.transparent)),
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<AuthenticationBloc>().add(LoggedOut());
                            },
                            child: const Text('Logout'),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  pickImage();
                  // cropImage();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      profilePictureUrl.isNotEmpty ? CachedNetworkImageProvider(profilePictureUrl) : null,
                  child: profilePictureUrl.isEmpty
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 50,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              DropdownButton(
                  value: selectedGender,
                  isExpanded: true,
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  items: ['Female', 'Male', 'Rather not say'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value.toString();
                    });
                  }),
              // const SizedBox(height: 16),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (usernameController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      weightController.text.isEmpty ||
                      heightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill in all fields'),
                    ));
                  } else {
                    context.read<AuthenticationBloc>().add(UpdateProfile(
                        user: widget.user,
                        username: usernameController.text,
                        age: int.parse(ageController.text),
                        weight: int.parse(weightController.text),
                        height: int.parse(heightController.text),
                        gender: selectedGender,
                        profilePictureUrl: _profileImage != null ? _profileImage!.path : null));
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
